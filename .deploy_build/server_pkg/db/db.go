package db

import (
	"database/sql"
	"fmt"

	"telegram-server/config"

	_ "github.com/lib/pq"
)

var DB *sql.DB

// InitDB 初始化数据库连接
func InitDB() error {
	cfg := config.AppConfig

	// 调试输出
	fmt.Printf("数据库配置:\n")
	fmt.Printf("  Host: %s\n", cfg.DBHost)
	fmt.Printf("  Port: %s\n", cfg.DBPort)
	fmt.Printf("  User: %s\n", cfg.DBUser)
	fmt.Printf("  Password: %s (len=%d)\n", cfg.DBPassword, len(cfg.DBPassword))
	fmt.Printf("  DBName: %s\n", cfg.DBName)
	fmt.Printf("  SSLMode: %s\n", cfg.DBSSLMode)

	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBName,
		cfg.DBSSLMode,
	)
	fmt.Printf("连接字符串: %s\n", connStr)

	var err error
	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		fmt.Printf("failed to open database: %w", err)
		return err
	}

	// 测试数据库连接
	if err = DB.Ping(); err != nil {
		fmt.Printf("failed to ping database: %w", err)
		return err
	}

	// 设置连接池参数
	DB.SetMaxOpenConns(25)
	DB.SetMaxIdleConns(5)

	// 🔴 设置数据库会话时区为 UTC
	// 服务器代码使用 time.Now().UTC() 存储 UTC 时间
	// 客户端收到带 Z 后缀的时间后会转换为本地时间显示
	_, err = DB.Exec("SET TIME ZONE 'UTC'")
	if err != nil {
		fmt.Printf("⚠️ 设置数据库时区失败: %v\n", err)
		// 不返回错误，继续运行
	} else {
		fmt.Printf("✅ 数据库时区已设置为 UTC\n")
	}

	// 轻量自迁移：消息体系迁移到 Agora Chat 后，groups 表需要存放 Agora 分配的群ID。
	// 无独立迁移执行器，这里用 IF NOT EXISTS 幂等补列，避免漏跑 SQL 脚本。
	if _, err = DB.Exec(`ALTER TABLE groups ADD COLUMN IF NOT EXISTS agora_group_id varchar(64)`); err != nil {
		fmt.Printf("⚠️ 添加 groups.agora_group_id 列失败: %v\n", err)
	}

	// 轻量自迁移：邀请码支持多次使用，需要 total_count / used_count 两列。
	// 对应 db/migrations/add_invite_codes_usage_count.sql，缺列会导致注册时邀请码校验报错。
	if _, err = DB.Exec(`ALTER TABLE invite_codes ADD COLUMN IF NOT EXISTS total_count INTEGER DEFAULT 1`); err != nil {
		fmt.Printf("⚠️ 添加 invite_codes.total_count 列失败: %v\n", err)
	}
	if _, err = DB.Exec(`ALTER TABLE invite_codes ADD COLUMN IF NOT EXISTS used_count INTEGER DEFAULT 0`); err != nil {
		fmt.Printf("⚠️ 添加 invite_codes.used_count 列失败: %v\n", err)
	}
	// 历史数据回填：已标记为 used 的邀请码补齐 used_count
	if _, err = DB.Exec(`UPDATE invite_codes SET used_count = 1 WHERE status = 'used' AND used_count = 0`); err != nil {
		fmt.Printf("⚠️ 回填 invite_codes.used_count 失败: %v\n", err)
	}

	// 轻量自迁移：消息同步归档表（对应 migrations/create_synced_message_tables.sql）。
	// 消息迁移到 Agora Chat 后服务器不再经手聊天消息，由接收方客户端异步上报归档，
	// 供管理后台展示/搜索单聊与群聊记录。agora_msg_id 唯一约束保证重复上报幂等。
	for _, q := range []string{
		`CREATE TABLE IF NOT EXISTS synced_messages (
			id BIGSERIAL PRIMARY KEY,
			agora_msg_id VARCHAR(64) NOT NULL UNIQUE,
			sender_id INTEGER NOT NULL,
			sender_name VARCHAR(255) DEFAULT '',
			receiver_id INTEGER NOT NULL,
			receiver_name VARCHAR(255) DEFAULT '',
			content TEXT DEFAULT '',
			message_type VARCHAR(32) DEFAULT 'text',
			file_name VARCHAR(512),
			voice_duration INTEGER,
			call_type VARCHAR(32),
			quoted_message_content TEXT,
			status VARCHAR(16) DEFAULT 'normal',
			is_read BOOLEAN DEFAULT FALSE,
			created_at TIMESTAMP NOT NULL,
			synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)`,
		`CREATE INDEX IF NOT EXISTS idx_synced_messages_created_at ON synced_messages (created_at DESC)`,
		`CREATE INDEX IF NOT EXISTS idx_synced_messages_sender ON synced_messages (sender_id)`,
		`CREATE INDEX IF NOT EXISTS idx_synced_messages_receiver ON synced_messages (receiver_id)`,
		`CREATE TABLE IF NOT EXISTS synced_group_messages (
			id BIGSERIAL PRIMARY KEY,
			agora_msg_id VARCHAR(64) NOT NULL UNIQUE,
			group_id INTEGER NOT NULL,
			sender_id INTEGER NOT NULL,
			sender_name VARCHAR(255) DEFAULT '',
			sender_nickname VARCHAR(255),
			sender_full_name VARCHAR(255),
			content TEXT DEFAULT '',
			message_type VARCHAR(32) DEFAULT 'text',
			file_name VARCHAR(512),
			voice_duration INTEGER,
			call_type VARCHAR(32),
			quoted_message_content TEXT,
			status VARCHAR(16) DEFAULT 'normal',
			created_at TIMESTAMP NOT NULL,
			synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)`,
		`CREATE INDEX IF NOT EXISTS idx_synced_group_messages_created_at ON synced_group_messages (created_at DESC)`,
		`CREATE INDEX IF NOT EXISTS idx_synced_group_messages_group ON synced_group_messages (group_id)`,
		`CREATE INDEX IF NOT EXISTS idx_synced_group_messages_sender ON synced_group_messages (sender_id)`,
	} {
		if _, err = DB.Exec(q); err != nil {
			fmt.Printf("⚠️ 创建消息同步归档表失败: %v\n", err)
		}
	}

	fmt.Printf("Database connected successfully")
	return nil
}

// CloseDB 关闭数据库连接
func CloseDB() {
	if DB != nil {
		DB.Close()
		fmt.Printf("Database connection closed")
	}
}
