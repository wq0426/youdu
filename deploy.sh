#!/usr/bin/env bash
#
# deploy.sh — 打包 server(Go) 和 admin(后台 TS/Node) 并发布到远程服务器
#
# 用法:
#   ./deploy.sh              # 构建 + 上传 + 远程部署 + 重启 server 和 admin
#   ./deploy.sh server       # 只部署 server
#   ./deploy.sh admin        # 只部署 admin
#   ./deploy.sh --build-only # 只本地打包，不上传
#   ./deploy.sh --no-restart # 部署但不重启服务
#
# 说明:
#   - Go server 交叉编译为 linux/amd64
#   - admin 用 `npm run build`(tsc) 打包到 dist/
#   - 部署流程: 上传前先停止远程服务 → 上传 → 解压 → 重新启动
#     (--no-restart 则不停止也不启动; 中途失败会自动回启已停止的服务)
#   - 远程 .env 文件会被保留，不会被本次部署覆盖(生产密钥安全)
#   - 首次部署会自动创建 systemd unit(telegram-server / telegram-admin)
#
set -euo pipefail

# ============ 配置(按需修改) ============
REMOTE_HOST="141.140.14.83"
REMOTE_PORT="16374"
REMOTE_USER="root"
REMOTE_BASE="/opt/telegram"          # server -> /opt/telegram/server, admin -> /opt/telegram/admin
SERVER_SVC="telegram-server"         # systemd 服务名
ADMIN_SVC="telegram-admin"           # systemd 服务名
SERVER_BIN="telegram-server"         # 远程二进制文件名
# ========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
STAGING="$SCRIPT_DIR/.deploy_build"
SSH="ssh -p $REMOTE_PORT ${REMOTE_USER}@${REMOTE_HOST}"

# 颜色输出
c_info()  { printf '\033[36m▶ %s\033[0m\n' "$*"; }
c_ok()    { printf '\033[32m✓ %s\033[0m\n' "$*"; }
c_warn()  { printf '\033[33m! %s\033[0m\n' "$*"; }
c_err()   { printf '\033[31m✗ %s\033[0m\n' "$*" >&2; }
die()     { c_err "$*"; exit 1; }

# 参数解析
TARGET="all"; BUILD_ONLY=0; DO_RESTART=1
for arg in "$@"; do
  case "$arg" in
    server|admin|all) TARGET="$arg" ;;
    --build-only)     BUILD_ONLY=1 ;;
    --no-restart)     DO_RESTART=0 ;;
    -h|--help) grep '^#' "$0" | sed 's/^#//'; exit 0 ;;
    *) die "未知参数: $arg" ;;
  esac
done

do_server() { [[ "$TARGET" == "all" || "$TARGET" == "server" ]]; }
do_admin()  { [[ "$TARGET" == "all" || "$TARGET" == "admin"  ]]; }

# ---------- 预检查 ----------
c_info "预检查工具链..."
do_server && ! command -v go   >/dev/null && die "未找到 go，请先安装 Go"
do_admin  && ! command -v npm  >/dev/null && die "未找到 npm，请先安装 Node.js"
command -v ssh >/dev/null || die "未找到 ssh"
command -v scp >/dev/null || die "未找到 scp"

rm -rf "$STAGING"; mkdir -p "$STAGING"

# ---------- 构建 server ----------
if do_server; then
  c_info "交叉编译 Go server (linux/amd64)..."
  ( cd server && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
      go build -trimpath -ldflags "-s -w" -o "$STAGING/$SERVER_BIN" main.go )
  c_ok "server 编译完成: $(du -h "$STAGING/$SERVER_BIN" | cut -f1)"

  c_info "打包 server..."
  # 汇集到 staging 目录再一次性打包(二进制 + 运行时资源，不含 .env)
  pkg_root="$STAGING/server_pkg"
  mkdir -p "$pkg_root"
  cp "$STAGING/$SERVER_BIN" "$pkg_root/"
  for d in migrations db cert; do
    [[ -d "server/$d" ]] && cp -R "server/$d" "$pkg_root/"
  done
  tar -czf "$STAGING/server.tar.gz" --exclude='.env*' -C "$pkg_root" .
  c_ok "server 打包完成: $(du -h "$STAGING/server.tar.gz" | cut -f1)"
fi

# ---------- 构建 admin ----------
if do_admin; then
  c_info "构建 admin (tsc)..."
  ( cd admin && npm run build )
  [[ -d admin/dist ]] || die "admin/dist 不存在，构建失败"

  c_info "打包 admin..."
  admin_pkg="$STAGING/admin.tar.gz"
  # dist + 前端静态资源 + 依赖清单(远程 npm ci 安装生产依赖)，不含 .env
  tar -czf "$admin_pkg" --exclude='.env*' -C admin dist public package.json package-lock.json
  c_ok "admin 打包完成"
fi

if [[ "$BUILD_ONLY" == "1" ]]; then
  c_ok "仅构建模式，产物在 $STAGING"
  exit 0
fi

# ---------- 上传 ----------
c_info "检查 SSH 连接 ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PORT}..."
$SSH -o ConnectTimeout=10 -o BatchMode=yes true 2>/dev/null \
  || die "SSH 连接失败，请确认已配置免密登录或密钥"
c_ok "SSH 连接正常"

# SSH 命令重试: 链路走代理出口不稳定，普通 SSH 命令也会偶发断连
ssh_retry() {
  local attempt
  for attempt in 1 2 3 4 5; do
    $SSH "$1" && return 0
    c_warn "SSH 命令中断(第 $attempt 次)，2 秒后重试"
    sleep 2
  done
  return 1
}

# ---------- 停止远程服务(上传前) ----------
# 上传/解压期间服务不运行，避免二进制被占用或新旧文件混跑。
# --no-restart 模式不停止(也不启动)，保持原有行为。
STOPPED_SVCS=""
if [[ "$DO_RESTART" == "1" ]]; then
  c_info "停止远程服务..."
  do_server && { ssh_retry "systemctl stop $SERVER_SVC 2>/dev/null || true"; STOPPED_SVCS="$STOPPED_SVCS $SERVER_SVC"; }
  do_admin  && { ssh_retry "systemctl stop $ADMIN_SVC 2>/dev/null || true";  STOPPED_SVCS="$STOPPED_SVCS $ADMIN_SVC"; }
  c_ok "远程服务已停止:$STOPPED_SVCS"
  # 兜底：部署中途失败(上传断连等)时把已停止的服务拉起来，避免服务一直挂着
  on_exit() {
    local code=$?
    if [[ $code -ne 0 && -n "$STOPPED_SVCS" ]]; then
      c_warn "部署未完成，回启远程服务:$STOPPED_SVCS"
      ssh_retry "systemctl start$STOPPED_SVCS" \
        || c_err "回启失败，请手动: ssh -p $REMOTE_PORT ${REMOTE_USER}@${REMOTE_HOST} systemctl start$STOPPED_SVCS"
    fi
  }
  trap on_exit EXIT
fi

REMOTE_TMP="/tmp/telegram_deploy_$$"
ssh_retry "mkdir -p $REMOTE_TMP" || die "无法在远程创建临时目录"

# 上传(带重试): 链路走代理出口，大文件传输偶发被中途掐断，失败自动重试
upload() {
  local src="$1" attempt
  for attempt in 1 2 3 4 5; do
    scp -P "$REMOTE_PORT" "$src" "${REMOTE_USER}@${REMOTE_HOST}:$REMOTE_TMP/" && return 0
    c_warn "上传中断(第 $attempt 次)，2 秒后重试: $(basename "$src")"
    sleep 2
  done
  die "上传失败(已重试 5 次): $src"
}

do_server && { c_info "上传 server 包..."; upload "$STAGING/server.tar.gz"; }
do_admin  && { c_info "上传 admin 包...";  upload "$STAGING/admin.tar.gz"; }
c_ok "上传完成"

# ---------- 远程部署 ----------
# 远程脚本内容先存变量，断连时可整体重试(脚本幂等: mkdir -p / tar 覆盖 / unit 存在则不建)
REMOTE_SCRIPT_BODY=$(cat <<'REMOTE_SCRIPT'
set -euo pipefail
say() { printf '  \033[36m%s\033[0m\n' "$*"; }

SERVER_DIR="$REMOTE_BASE/server"
ADMIN_DIR="$REMOTE_BASE/admin"

# ---- server ----
if [[ "$DO_SERVER" == "1" ]]; then
  say "部署 server -> $SERVER_DIR"
  mkdir -p "$SERVER_DIR"
  # 备份旧二进制
  [[ -f "$SERVER_DIR/$SERVER_BIN" ]] && cp -f "$SERVER_DIR/$SERVER_BIN" "$SERVER_DIR/$SERVER_BIN.bak" || true
  tar -xzf "$REMOTE_TMP/server.tar.gz" -C "$SERVER_DIR" --exclude='.env*'
  chmod +x "$SERVER_DIR/$SERVER_BIN"

  # 首次部署: 创建 systemd unit(存在则不覆盖)
  if [[ ! -f "/etc/systemd/system/${SERVER_SVC}.service" ]]; then
    say "创建 systemd unit: ${SERVER_SVC}"
    cat > "/etc/systemd/system/${SERVER_SVC}.service" <<EOF
[Unit]
Description=YouDu Server
After=network.target

[Service]
Type=simple
WorkingDirectory=${SERVER_DIR}
ExecStart=${SERVER_DIR}/${SERVER_BIN}
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable "$SERVER_SVC"
  fi
  [[ -f "$SERVER_DIR/.env" ]] || echo "  ! 警告: $SERVER_DIR/.env 不存在，请上传生产 .env 后再启动"
fi

# ---- admin ----
if [[ "$DO_ADMIN" == "1" ]]; then
  say "部署 admin -> $ADMIN_DIR"
  mkdir -p "$ADMIN_DIR"
  tar -xzf "$REMOTE_TMP/admin.tar.gz" -C "$ADMIN_DIR" --exclude='.env*'

  say "安装生产依赖(npm ci --omit=dev)..."
  ( cd "$ADMIN_DIR" && npm ci --omit=dev --no-audit --no-fund )

  if [[ ! -f "/etc/systemd/system/${ADMIN_SVC}.service" ]]; then
    say "创建 systemd unit: ${ADMIN_SVC}"
    NODE_BIN="$(command -v node)"
    cat > "/etc/systemd/system/${ADMIN_SVC}.service" <<EOF
[Unit]
Description=YouDu Admin
After=network.target

[Service]
Type=simple
WorkingDirectory=${ADMIN_DIR}
ExecStart=${NODE_BIN} dist/index.js
Restart=always
RestartSec=3
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable "$ADMIN_SVC"
  fi
  [[ -f "$ADMIN_DIR/.env" ]] || echo "  ! 警告: $ADMIN_DIR/.env 不存在，请上传生产 .env 后再启动"
fi

# ---- 重启 ----
if [[ "$DO_RESTART" == "1" ]]; then
  [[ "$DO_SERVER" == "1" ]] && { say "重启 $SERVER_SVC"; systemctl restart "$SERVER_SVC"; }
  [[ "$DO_ADMIN"  == "1" ]] && { say "重启 $ADMIN_SVC";  systemctl restart "$ADMIN_SVC"; }
  sleep 2
  [[ "$DO_SERVER" == "1" ]] && systemctl --no-pager --lines=0 status "$SERVER_SVC" | head -3 || true
  [[ "$DO_ADMIN"  == "1" ]] && systemctl --no-pager --lines=0 status "$ADMIN_SVC"  | head -3 || true
fi

rm -rf "$REMOTE_TMP"
REMOTE_SCRIPT
)

c_info "远程部署中..."
DEPLOY_OK=0
for attempt in 1 2 3; do
  if $SSH "REMOTE_BASE='$REMOTE_BASE' REMOTE_TMP='$REMOTE_TMP' \
        SERVER_SVC='$SERVER_SVC' ADMIN_SVC='$ADMIN_SVC' SERVER_BIN='$SERVER_BIN' \
        DO_SERVER='$(do_server && echo 1 || echo 0)' \
        DO_ADMIN='$(do_admin && echo 1 || echo 0)' \
        DO_RESTART='$DO_RESTART' bash -s" <<<"$REMOTE_SCRIPT_BODY"; then
    DEPLOY_OK=1; break
  fi
  c_warn "远程部署中断(第 $attempt 次)，3 秒后重试"
  sleep 3
done
[[ "$DEPLOY_OK" == "1" ]] || die "远程部署失败(已重试 3 次)"

STOPPED_SVCS=""   # 远程部署已成功并启动服务，清空标记避免 EXIT 兜底误触发
c_ok "部署完成！"
[[ "$DO_RESTART" == "0" ]] && c_warn "已跳过重启，需手动: ssh ... systemctl restart $SERVER_SVC $ADMIN_SVC"
