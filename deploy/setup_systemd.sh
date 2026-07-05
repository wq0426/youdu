#!/usr/bin/env bash
#
# setup_systemd.sh — 服务端脚本：用 systemd 管理 telegram-server(Go) 和 telegram-admin(Node)
# 适用: CentOS 7+ / 任何 systemd 发行版，需 root 执行
#
# 用法(在服务器上):
#   ./setup_systemd.sh install            # 写入/更新两个 unit 文件 + enable + 启动
#   ./setup_systemd.sh install server     # 只装 server
#   ./setup_systemd.sh install admin      # 只装 admin
#   ./setup_systemd.sh start|stop|restart [server|admin]
#   ./setup_systemd.sh status             # 查看两个服务状态
#   ./setup_systemd.sh logs server        # 跟踪日志(journalctl -f)
#
# 说明:
#   - install 是幂等的：unit 文件每次都会重写(以本脚本为准)，改完脚本重跑即可生效
#   - 程序目录约定与 deploy.sh 一致: /opt/telegram/server、/opt/telegram/admin
#   - 两个服务都从各自 WorkingDirectory 下的 .env 读配置，.env 不存在会拒绝启动
#
set -euo pipefail

# ============ 配置(按需修改) ============
BASE_DIR="/opt/telegram"
SERVER_DIR="$BASE_DIR/server"
ADMIN_DIR="$BASE_DIR/admin"
SERVER_BIN="telegram-server"           # Go 二进制文件名
SERVER_SVC="telegram-server"
ADMIN_SVC="telegram-admin"
RUN_USER="root"                     # 建议后续改为专用低权限用户，如 telegram
# ========================================

c_info() { printf '\033[36m▶ %s\033[0m\n' "$*"; }
c_ok()   { printf '\033[32m✓ %s\033[0m\n' "$*"; }
c_warn() { printf '\033[33m! %s\033[0m\n' "$*"; }
die()    { printf '\033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "请用 root 执行(sudo $0 ...)"
command -v systemctl >/dev/null || die "系统没有 systemctl"

ACTION="${1:-install}"
TARGET="${2:-all}"
case "$TARGET" in server|admin|all) ;; *) die "目标只能是 server / admin / all" ;; esac
do_server() { [[ "$TARGET" == "all" || "$TARGET" == "server" ]]; }
do_admin()  { [[ "$TARGET" == "all" || "$TARGET" == "admin"  ]]; }

# ---------- 写 unit 文件 ----------
write_server_unit() {
  [[ -x "$SERVER_DIR/$SERVER_BIN" ]] || die "找不到可执行文件 $SERVER_DIR/$SERVER_BIN，请先用 deploy.sh 部署程序"

  cat > "/etc/systemd/system/${SERVER_SVC}.service" <<EOF
[Unit]
Description=YouDu Server (Go)
After=network-online.target postgresql.service redis.service
Wants=network-online.target

[Service]
Type=simple
User=${RUN_USER}
WorkingDirectory=${SERVER_DIR}
ExecStart=${SERVER_DIR}/${SERVER_BIN}
# .env 缺失时拒绝启动，避免以空配置跑起来
ExecStartPre=/usr/bin/test -f ${SERVER_DIR}/.env
Restart=always
RestartSec=3
# 崩溃循环保护: 60 秒内最多重启 5 次
StartLimitInterval=60
StartLimitBurst=5
LimitNOFILE=65535
# 日志进 journald，用 journalctl -u ${SERVER_SVC} 查看
StandardOutput=journal
StandardError=journal
SyslogIdentifier=${SERVER_SVC}

[Install]
WantedBy=multi-user.target
EOF
  c_ok "已写入 /etc/systemd/system/${SERVER_SVC}.service"
}

write_admin_unit() {
  local node_bin
  node_bin="$(command -v node)" || die "找不到 node，请先安装 Node.js"
  [[ -f "$ADMIN_DIR/dist/index.js" ]] || die "找不到 $ADMIN_DIR/dist/index.js，请先用 deploy.sh 部署 admin"

  cat > "/etc/systemd/system/${ADMIN_SVC}.service" <<EOF
[Unit]
Description=YouDu Admin (Node)
After=network-online.target postgresql.service ${SERVER_SVC}.service
Wants=network-online.target

[Service]
Type=simple
User=${RUN_USER}
WorkingDirectory=${ADMIN_DIR}
ExecStart=${node_bin} dist/index.js
ExecStartPre=/usr/bin/test -f ${ADMIN_DIR}/.env
Restart=always
RestartSec=3
StartLimitInterval=60
StartLimitBurst=5
Environment=NODE_ENV=production
# 安全: admin 默认只监听 127.0.0.1(代码里已内置)，外部走 Nginx 反代
# 如确需监听所有网卡，在 ${ADMIN_DIR}/.env 里设 HOST=0.0.0.0
StandardOutput=journal
StandardError=journal
SyslogIdentifier=${ADMIN_SVC}

[Install]
WantedBy=multi-user.target
EOF
  c_ok "已写入 /etc/systemd/system/${ADMIN_SVC}.service"
}

check_env() {
  local dir="$1" svc="$2"
  if [[ ! -f "$dir/.env" ]]; then
    c_warn "$dir/.env 不存在，$svc 会拒绝启动 —— 请先创建生产 .env"
    return 1
  fi
  return 0
}

svc_list() {
  local list=()
  do_server && list+=("$SERVER_SVC")
  do_admin  && list+=("$ADMIN_SVC")
  echo "${list[@]}"
}

# ---------- 动作分发 ----------
case "$ACTION" in
  install)
    do_server && write_server_unit
    do_admin  && write_admin_unit
    systemctl daemon-reload
    c_ok "daemon-reload 完成"

    for svc in $(svc_list); do
      systemctl enable "$svc" >/dev/null 2>&1
      c_ok "已设置开机自启: $svc"
    done

    started=()
    if do_server && check_env "$SERVER_DIR" "$SERVER_SVC"; then
      systemctl restart "$SERVER_SVC" && started+=("$SERVER_SVC")
    fi
    if do_admin && check_env "$ADMIN_DIR" "$ADMIN_SVC"; then
      systemctl restart "$ADMIN_SVC" && started+=("$ADMIN_SVC")
    fi

    sleep 2
    for svc in "${started[@]:-}"; do
      [[ -n "$svc" ]] || continue
      if systemctl is-active --quiet "$svc"; then
        c_ok "$svc 运行中"
      else
        c_warn "$svc 启动失败，最近日志:"
        journalctl -u "$svc" --no-pager -n 20
      fi
    done
    ;;

  start|stop|restart)
    for svc in $(svc_list); do
      c_info "$ACTION $svc"
      systemctl "$ACTION" "$svc"
    done
    [[ "$ACTION" != "stop" ]] && { sleep 1; systemctl --no-pager -n 0 status $(svc_list) || true; }
    ;;

  status)
    systemctl --no-pager status $(svc_list) || true
    ;;

  logs)
    [[ "$TARGET" != "all" ]] || die "logs 需要指定 server 或 admin，例: $0 logs server"
    svc="$SERVER_SVC"; [[ "$TARGET" == "admin" ]] && svc="$ADMIN_SVC"
    exec journalctl -u "$svc" -f --no-pager
    ;;

  *)
    die "未知动作: $ACTION (支持 install/start/stop/restart/status/logs)"
    ;;
esac
