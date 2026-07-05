// 计算文件MD5工具
// 用于计算升级包的MD5值，并可选更新数据库
// 使用方法:
//   1. 只计算MD5: go run calculate_md5.go -file "path/to/file.exe"
//   2. 计算并更新数据库: go run calculate_md5.go -file "path/to/file.exe" -update -id 1

package main

import (
	"crypto/md5"
	"database/sql"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	_ "github.com/lib/pq"
)

func main() {
	// 解析命令行参数
	filePath := flag.String("file", "", "文件路径（本地文件）")
	fileURL := flag.String("url", "", "文件URL（远程文件）")
	updateDB := flag.Bool("update", false, "是否更新数据库")
	versionID := flag.Int("id", 0, "版本ID（更新数据库时必需）")
	dbHost := flag.String("dbhost", "localhost", "数据库主机")
	dbPort := flag.Int("dbport", 5432, "数据库端口")
	dbUser := flag.String("dbuser", "postgres", "数据库用户")
	dbPass := flag.String("dbpass", "", "数据库密码")
	dbName := flag.String("dbname", "youdu", "数据库名称")

	flag.Parse()

	// 验证参数
	if *filePath == "" && *fileURL == "" {
		printUsage()
		os.Exit(1)
	}

	if *updateDB && *versionID == 0 {
		fmt.Println("❌ 错误: 更新数据库时必须指定版本ID (-id)")
		os.Exit(1)
	}

	fmt.Println("\n╔════════════════════════════════════════╗")
	fmt.Println("║        MD5 计算工具 v1.0             ║")
	fmt.Println("╚════════════════════════════════════════╝\n")

	var md5Hash string
	var fileSize int64
	var err error

	// 计算MD5
	if *filePath != "" {
		fmt.Printf("📁 本地文件: %s\n", *filePath)
		md5Hash, fileSize, err = calculateFileMD5(*filePath)
	} else {
		fmt.Printf("🌐 远程文件: %s\n", *fileURL)
		md5Hash, fileSize, err = calculateURLMD5(*fileURL)
	}

	if err != nil {
		fmt.Printf("❌ 错误: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("\n✅ 计算完成!\n")
	fmt.Printf("📦 文件大小: %.2f MB (%d 字节)\n", float64(fileSize)/1024/1024, fileSize)
	fmt.Printf("🔐 MD5: %s\n", md5Hash)

	// 更新数据库
	if *updateDB {
		fmt.Printf("\n📝 更新数据库 (版本ID: %d)...\n", *versionID)
		if err := updateDatabase(*dbHost, *dbPort, *dbUser, *dbPass, *dbName, *versionID, md5Hash, fileSize); err != nil {
			fmt.Printf("❌ 错误: %v\n", err)
			os.Exit(1)
		}
		fmt.Println("✅ 数据库更新成功!")
	}

	fmt.Println("\n" + strings.Repeat("═", 42))
	fmt.Println("💡 提示:")
	if !*updateDB {
		fmt.Println("  使用 -update -id <版本ID> 可直接更新数据库")
	}
	fmt.Println("  发布新版本时使用以下参数:")
	fmt.Printf("    -size %d \\\n", fileSize)
	fmt.Printf("    -md5 \"%s\"\n", md5Hash)
	fmt.Println(strings.Repeat("═", 42))
}

func printUsage() {
	fmt.Println("用法:")
	fmt.Println("  go run calculate_md5.go -file <文件路径> [options]")
	fmt.Println("  go run calculate_md5.go -url <文件URL> [options]")
	fmt.Println("\n必需参数 (二选一):")
	fmt.Println("  -file        本地文件路径")
	fmt.Println("  -url         远程文件URL")
	fmt.Println("\n可选参数:")
	fmt.Println("  -update      更新数据库 (默认: false)")
	fmt.Println("  -id          版本ID (更新数据库时必需)")
	fmt.Println("  -dbhost      数据库主机 (默认: localhost)")
	fmt.Println("  -dbport      数据库端口 (默认: 5432)")
	fmt.Println("  -dbuser      数据库用户 (默认: postgres)")
	fmt.Println("  -dbpass      数据库密码")
	fmt.Println("  -dbname      数据库名称 (默认: youdu)")
	fmt.Println("\n示例:")
	fmt.Println("  # 只计算本地文件MD5")
	fmt.Println("  go run calculate_md5.go -file \"C:\\Downloads\\telegram_1.0.2.exe\"")
	fmt.Println("\n  # 计算远程文件MD5")
	fmt.Println("  go run calculate_md5.go -url \"https://cdn.example.com/telegram_1.0.2.exe\"")
	fmt.Println("\n  # 计算并更新数据库")
	fmt.Println("  go run calculate_md5.go \\")
	fmt.Println("    -file \"C:\\Downloads\\telegram_1.0.2.exe\" \\")
	fmt.Println("    -update \\")
	fmt.Println("    -id 1 \\")
	fmt.Println("    -dbpass \"your_password\"")
}

// calculateFileMD5 计算本地文件的MD5
func calculateFileMD5(filePath string) (string, int64, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return "", 0, fmt.Errorf("打开文件失败: %v", err)
	}
	defer file.Close()

	// 获取文件大小
	fileInfo, err := file.Stat()
	if err != nil {
		return "", 0, fmt.Errorf("获取文件信息失败: %v", err)
	}
	fileSize := fileInfo.Size()

	fmt.Printf("⏳ 正在计算MD5 (文件大小: %.2f MB)...\n", float64(fileSize)/1024/1024)

	hash := md5.New()
	if _, err := io.Copy(hash, file); err != nil {
		return "", 0, fmt.Errorf("计算MD5失败: %v", err)
	}

	return fmt.Sprintf("%x", hash.Sum(nil)), fileSize, nil
}

// calculateURLMD5 计算远程文件的MD5
func calculateURLMD5(url string) (string, int64, error) {
	fmt.Println("⏳ 正在下载文件...")

	resp, err := http.Get(url)
	if err != nil {
		return "", 0, fmt.Errorf("下载文件失败: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return "", 0, fmt.Errorf("下载失败，状态码: %d", resp.StatusCode)
	}

	fileSize := resp.ContentLength
	fmt.Printf("⏳ 正在计算MD5 (文件大小: %.2f MB)...\n", float64(fileSize)/1024/1024)

	hash := md5.New()
	written, err := io.Copy(hash, resp.Body)
	if err != nil {
		return "", 0, fmt.Errorf("计算MD5失败: %v", err)
	}

	return fmt.Sprintf("%x", hash.Sum(nil)), written, nil
}

// updateDatabase 更新数据库中的MD5和文件大小
func updateDatabase(host string, port int, user, password, dbname string, versionID int, md5Hash string, fileSize int64) error {
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return fmt.Errorf("连接数据库失败: %v", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		return fmt.Errorf("数据库连接测试失败: %v", err)
	}

	_, err = db.Exec(`
		UPDATE app_versions 
		SET file_hash = $1, file_size = $2, updated_at = NOW()
		WHERE id = $3
	`, md5Hash, fileSize, versionID)

	if err != nil {
		return fmt.Errorf("更新数据库失败: %v", err)
	}

	return nil
}
