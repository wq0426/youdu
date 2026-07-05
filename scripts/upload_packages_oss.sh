#!/bin/bash
# 上传客户端安装包到阿里云 OSS
# 用法:
#   ./scripts/upload_packages_oss.sh            # 上传 dist/ 下的 windows 和 macos 包
#   ./scripts/upload_packages_oss.sh <文件路径>  # 上传指定文件(自动按扩展名归类平台)
#
# 凭证从 server/.env 读取(S3_ENDPOINT / S3_ACCESS_KEY / S3_SECRET_KEY / S3_BUCKET)
# OSS Key 约定: releases/<平台>/<文件名> (与 server/scripts/publish_version 一致)
# 零依赖: 仅用 curl + openssl 做 OSS V1 签名直传
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/server/.env"
DIST_DIR="$PROJECT_DIR/dist"

GREEN='\033[0;32m'; CYAN='\033[0;36m'; RED='\033[0;31m'; YELLOW='\033[0;33m'; NC='\033[0m'
info() { echo -e "${CYAN}ℹ️  $1${NC}"; }
ok()   { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
fail() { echo -e "${RED}❌ $1${NC}"; exit 1; }

# ── 读取 OSS 凭证(不回显任何密钥) ──────────────────────────
[ -f "$ENV_FILE" ] || fail "未找到 $ENV_FILE"
get_env() { grep -E "^$1=" "$ENV_FILE" | head -1 | cut -d= -f2- | tr -d '\r'; }
OSS_ENDPOINT=$(get_env S3_ENDPOINT)
OSS_AK=$(get_env S3_ACCESS_KEY)
OSS_SK=$(get_env S3_SECRET_KEY)
OSS_BUCKET=$(get_env S3_BUCKET)
[ -n "$OSS_ENDPOINT" ] && [ -n "$OSS_AK" ] && [ -n "$OSS_SK" ] && [ -n "$OSS_BUCKET" ] \
    || fail "server/.env 中 S3_ENDPOINT/S3_ACCESS_KEY/S3_SECRET_KEY/S3_BUCKET 不完整"
ENDPOINT_HOST=${OSS_ENDPOINT#https://}; ENDPOINT_HOST=${ENDPOINT_HOST#http://}
info "OSS Bucket: $OSS_BUCKET ($ENDPOINT_HOST)"

# ── 签名请求辅助 ───────────────────────────────────────────
oss_sign() { # $1=StringToSign
    printf "$1" | openssl dgst -sha1 -hmac "$OSS_SK" -binary | base64
}

# ── 清空平台目录下的所有旧安装包(先列举再逐个删除) ─────────
CLEANED_PLATFORMS=""
clean_platform_prefix() {
    local platform="$1"
    case " $CLEANED_PLATFORMS " in *" $platform "*) return 0 ;; esac
    CLEANED_PLATFORMS="$CLEANED_PLATFORMS $platform"

    local prefix="releases/$platform/"
    local date_gmt sig keys
    date_gmt=$(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S GMT')
    sig=$(oss_sign "GET\n\n\n$date_gmt\n/$OSS_BUCKET/")
    keys=$(curl -sS --retry 3 --retry-delay 2 \
        -H "Date: $date_gmt" \
        -H "Authorization: OSS $OSS_AK:$sig" \
        "https://$OSS_BUCKET.$ENDPOINT_HOST/?prefix=$prefix&max-keys=1000" \
        | grep -o '<Key>[^<]*</Key>' | sed 's|</*Key>||g') || true

    if [ -z "$keys" ]; then
        info "远程 $prefix 下没有旧安装包，无需清理"
        return 0
    fi

    info "清理远程 $prefix 下的旧安装包:"
    local key http_code
    while IFS= read -r key; do
        [ -n "$key" ] || continue
        date_gmt=$(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S GMT')
        sig=$(oss_sign "DELETE\n\n\n$date_gmt\n/$OSS_BUCKET/$key")
        http_code=$(curl -sS -o /dev/null -w '%{http_code}' -X DELETE \
            --retry 3 --retry-delay 2 \
            -H "Date: $date_gmt" \
            -H "Authorization: OSS $OSS_AK:$sig" \
            "https://$OSS_BUCKET.$ENDPOINT_HOST/$key")
        if [ "$http_code" = "204" ] || [ "$http_code" = "200" ]; then
            echo "   🗑  已删除: $key"
        else
            fail "删除失败 (HTTP $http_code): $key"
        fi
    done <<< "$keys"
}

# ── 单文件上传(OSS V1 签名: PUT Object) ────────────────────
upload_one() {
    local file="$1" platform="$2"
    clean_platform_prefix "$platform"
    local name; name=$(basename "$file")
    local key="releases/$platform/$name"
    local url="https://$OSS_BUCKET.$ENDPOINT_HOST/$key"
    local size; size=$(du -h "$file" | cut -f1)

    local content_type
    case "$name" in
        *.zip) content_type="application/zip" ;;
        *.dmg) content_type="application/x-apple-diskimage" ;;
        *.exe) content_type="application/octet-stream" ;;
        *.apk) content_type="application/vnd.android.package-archive" ;;
        *)     content_type="application/octet-stream" ;;
    esac

    local date_gmt; date_gmt=$(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S GMT')
    local string_to_sign="PUT\n\n$content_type\n$date_gmt\n/$OSS_BUCKET/$key"
    local signature
    signature=$(printf "$string_to_sign" | openssl dgst -sha1 -hmac "$OSS_SK" -binary | base64)

    info "上传 $name ($size) → $key"
    local http_code
    http_code=$(curl -sS -o /dev/null -w '%{http_code}' -X PUT \
        --retry 3 --retry-delay 2 \
        -H "Date: $date_gmt" \
        -H "Content-Type: $content_type" \
        -H "Authorization: OSS $OSS_AK:$signature" \
        -T "$file" \
        "https://$OSS_BUCKET.$ENDPOINT_HOST/$key")
    [ "$http_code" = "200" ] || fail "上传失败 (HTTP $http_code): $name"

    local md5; md5=$(openssl md5 -r "$file" | cut -d' ' -f1)
    ok "上传成功: $url"
    echo "   文件MD5: $md5"
    UPLOADED_URLS+=("$url")
}

UPLOADED_URLS=()

# ── 指定文件模式 ───────────────────────────────────────────
if [ $# -ge 1 ]; then
    for f in "$@"; do
        [ -f "$f" ] || fail "文件不存在: $f"
        case "$(basename "$f")" in
            *windows*|*.exe) upload_one "$f" windows ;;
            *macos*|*.dmg)   upload_one "$f" macos ;;
            *android*|*.apk) upload_one "$f" android ;;
            *)               upload_one "$f" misc ;;
        esac
    done
else
    # ── 默认模式: 上传 dist/ 下最新版本的 windows + macos 包 ──
    [ -d "$DIST_DIR" ] || fail "dist/ 目录不存在，请先编译打包"
    FOUND=0
    for f in "$DIST_DIR"/telegram-windows-v*.zip "$DIST_DIR"/telegram-windows-v*.exe; do
        [ -f "$f" ] && { upload_one "$f" windows; FOUND=1; }
    done
    [ "$FOUND" = "1" ] || warn "未找到 Windows 包(dist/telegram-windows-v*.zip)，跳过 — 需在 Windows 机器上运行 scripts/build_windows.ps1 -Release 后拷贝过来"
    FOUND=0
    for f in "$DIST_DIR"/telegram-macos-v*.dmg "$DIST_DIR"/telegram-macos-v*.zip; do
        [ -f "$f" ] && { upload_one "$f" macos; FOUND=1; }
    done
    [ "$FOUND" = "1" ] || warn "未找到 macOS 包(dist/telegram-macos-v*.dmg)，跳过 — 请先运行 scripts/build_macos.sh"
fi

echo ""
if [ ${#UPLOADED_URLS[@]} -gt 0 ]; then
    ok "全部上传完成，共 ${#UPLOADED_URLS[@]} 个文件:"
    for u in "${UPLOADED_URLS[@]}"; do echo "   $u"; done
    # 链接同时写入 dist/oss_links.txt 便于复制分发
    LINKS_FILE="$DIST_DIR/oss_links.txt"
    mkdir -p "$DIST_DIR"
    { echo "# 上传时间: $(date '+%Y-%m-%d %H:%M:%S')"; for u in "${UPLOADED_URLS[@]}"; do echo "$u"; done; } > "$LINKS_FILE"
    info "链接已保存到: $LINKS_FILE"
else
    fail "没有上传任何文件"
fi
