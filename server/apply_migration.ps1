# 应用数据库迁移脚本
# 用于添加 group_messages.deleted_by_users 字段

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  应用群消息删除功能数据库迁移" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# 数据库连接信息
$DB_USER = "youdu_user"
$DB_NAME = "youdu_db"
$DB_HOST = "127.0.0.1"
$DB_PORT = "5432"
$MIGRATION_FILE = "db/migrations/add_deleted_by_users_to_group_messages.sql"

# 检查迁移文件是否存在
if (-not (Test-Path $MIGRATION_FILE)) {
    Write-Host "❌ 错误: 迁移文件不存在: $MIGRATION_FILE" -ForegroundColor Red
    exit 1
}

Write-Host "📄 迁移文件: $MIGRATION_FILE" -ForegroundColor Green
Write-Host "🗄️  数据库: $DB_NAME @ $DB_HOST:$DB_PORT" -ForegroundColor Green
Write-Host "👤 用户: $DB_USER" -ForegroundColor Green
Write-Host ""

# 提示用户输入密码
Write-Host "请输入数据库密码:" -ForegroundColor Yellow
$DB_PASSWORD = Read-Host -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASSWORD)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# 设置环境变量
$env:PGPASSWORD = $PlainPassword

Write-Host ""
Write-Host "正在应用迁移..." -ForegroundColor Yellow

# 执行迁移
try {
    $output = & psql -U $DB_USER -d $DB_NAME -h $DB_HOST -p $DB_PORT -f $MIGRATION_FILE 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ 迁移成功应用！" -ForegroundColor Green
        Write-Host ""
        Write-Host "输出:" -ForegroundColor Cyan
        Write-Host $output
    } else {
        Write-Host ""
        Write-Host "❌ 迁移失败！" -ForegroundColor Red
        Write-Host ""
        Write-Host "错误信息:" -ForegroundColor Red
        Write-Host $output
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "❌ 执行迁移时出错: $_" -ForegroundColor Red
    exit 1
}

# 验证迁移
Write-Host ""
Write-Host "正在验证迁移..." -ForegroundColor Yellow

$verifySQL = @"
SELECT column_name, data_type, column_default, is_nullable
FROM information_schema.columns 
WHERE table_name = 'group_messages' AND column_name = 'deleted_by_users';
"@

try {
    $verifyOutput = $verifySQL | & psql -U $DB_USER -d $DB_NAME -h $DB_HOST -p $DB_PORT -t 2>&1
    
    if ($LASTEXITCODE -eq 0 -and $verifyOutput) {
        Write-Host ""
        Write-Host "✅ 验证成功！字段已成功添加。" -ForegroundColor Green
        Write-Host ""
        Write-Host "字段信息:" -ForegroundColor Cyan
        Write-Host $verifyOutput
    } else {
        Write-Host ""
        Write-Host "⚠️  警告: 无法验证迁移结果。" -ForegroundColor Yellow
        Write-Host "请手动检查 group_messages 表是否包含 deleted_by_users 字段。" -ForegroundColor Yellow
    }
} catch {
    Write-Host ""
    Write-Host "⚠️  警告: 验证时出错: $_" -ForegroundColor Yellow
}

# 清除密码环境变量
$env:PGPASSWORD = $null

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  迁移完成！" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步:" -ForegroundColor Green
Write-Host "1. 重新编译服务器: go build -o telegram-server.exe main.go" -ForegroundColor White
Write-Host "2. 运行服务器: ./telegram-server.exe" -ForegroundColor White
Write-Host "3. 测试群消息删除功能" -ForegroundColor White
Write-Host ""

