#!/bin/bash
# macOS 客户端编译打包脚本
# 用法: ./scripts/build_macos.sh
# 产物: dist/telegram-macos-v<版本号>.dmg 和 .zip
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

GREEN='\033[0;32m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${CYAN}ℹ️  $1${NC}"; }
ok()    { echo -e "${GREEN}✅ $1${NC}"; }
fail()  { echo -e "${RED}❌ $1${NC}"; exit 1; }

VERSION=$(grep -E '^version:' pubspec.yaml | sed -E 's/version:[[:space:]]*([^+[:space:]]+).*/\1/')
info "版本号: $VERSION"

info "获取依赖..."
flutter pub get

info "编译 macOS Release 版本(需要几分钟)..."
flutter build macos --release

APP_PATH="build/macos/Build/Products/Release/Telegram.app"
[ -d "$APP_PATH" ] || fail "未找到编译产物: $APP_PATH"
ok "编译完成: $APP_PATH"

DIST_DIR="$PROJECT_DIR/dist"
mkdir -p "$DIST_DIR"

# zip 包(保留 .app 结构与资源 fork)
ZIP_PATH="$DIST_DIR/telegram-macos-v$VERSION.zip"
rm -f "$ZIP_PATH"
info "打包 zip..."
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" "$ZIP_PATH"
ok "已生成: $ZIP_PATH ($(du -h "$ZIP_PATH" | cut -f1))"

# dmg 包(拖拽安装)
DMG_PATH="$DIST_DIR/telegram-macos-v$VERSION.dmg"
rm -f "$DMG_PATH"
info "打包 dmg..."
DMG_STAGE=$(mktemp -d)
cp -R "$APP_PATH" "$DMG_STAGE/"
ln -s /Applications "$DMG_STAGE/Applications"
hdiutil create -volname "Telegram" -srcfolder "$DMG_STAGE" -ov -format UDZO "$DMG_PATH" >/dev/null
rm -rf "$DMG_STAGE"
ok "已生成: $DMG_PATH ($(du -h "$DMG_PATH" | cut -f1))"

echo ""
ok "macOS 打包完成，产物在 dist/ 目录"
echo "   提示: 应用未经过 Apple 公证，首次打开需右键 → 打开(或在 系统设置→隐私与安全性 中允许)"
