@echo off
chcp 65001 >nul
echo ========== 检查ZIP包结构 ==========
echo.

set "ZIP_FILE=C:\Users\WIN10\AppData\Local\Temp\telegram_update.zip"

if not exist "%ZIP_FILE%" (
    echo ✗ ZIP文件不存在: %ZIP_FILE%
    pause
    exit /b 1
)

echo ZIP文件: %ZIP_FILE%
echo.
echo ZIP包内容:
echo ----------------------------------------
powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::OpenRead('%ZIP_FILE%').Entries | Select-Object FullName, Length | Format-Table -AutoSize"
echo ----------------------------------------
echo.
echo 💡 提示:
echo   - 如果ZIP包内有子目录（如 windows/），需要调整解压路径
echo   - 理想的ZIP结构应该是: telegram.exe, data/, 等文件直接在根目录
echo.
pause
