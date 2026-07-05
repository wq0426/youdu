#!/bin/bash
# 清除测试数据(聊天相关) —— 只针对本地开发库
# 用法:
#   ./scripts/clear_test_data.sh          # 演练模式: 只显示将被清除的行数，不删除
#   ./scripts/clear_test_data.sh --yes    # 真正执行清除(会先自动备份)
#
# 清除范围(保留表结构，序列重置):
#   消息归档: synced_messages, synced_group_messages
#   群组:     groups, group_members
#   好友关系: user_relations
#   收藏/常用: favorites, favorite_contacts, favorite_groups
#   其他聊天: file_assistant_messages, scheduled_messages
# 保留: users, admin_user, app_versions, device_registrations,
#       invite_codes, invite_code_usages, server_settings, verification_codes
#
# ⚠️ 注意: Agora Chat 云端的会话/群组不在此脚本范围内，
#          客户端本地 sqlite 缓存也不清(重新登录即可重建)。
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/server/.env.development"

DB_HOST=$(grep '^DB_HOST=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
DB_PORT=$(grep '^DB_PORT=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
DB_USER=$(grep '^DB_USER=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
DB_NAME=$(grep '^DB_NAME=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
DB_PASSWORD=$(grep '^DB_PASSWORD=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
export PGPASSWORD="$DB_PASSWORD"

PSQL="psql -h $DB_HOST -p ${DB_PORT:-5432} -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1"

# ── 安全阀 1: 只允许连本地库 ──────────────────────────────
if [ "$DB_HOST" != "localhost" ] && [ "$DB_HOST" != "127.0.0.1" ]; then
    echo "❌ 拒绝执行: DB_HOST=$DB_HOST 不是本地库。此脚本只允许清除本地开发数据。"
    exit 1
fi

# ── 安全阀 2: 检测是否身处生产服务器(防止脚本被拷到生产机执行) ──
# 生产机上 DB_HOST 也是 127.0.0.1，安全阀1 挡不住，必须靠环境特征识别。
PROD_HOSTNAMES="FC-5038ML-50"          # 已知生产服务器主机名
CUR_HOST=$(hostname 2>/dev/null)
for ph in $PROD_HOSTNAMES; do
    if [ "$CUR_HOST" = "$ph" ]; then
        echo "❌❌ 拒绝执行: 当前主机名 '$CUR_HOST' 是生产服务器！此脚本严禁在生产环境运行。"
        exit 1
    fi
done
# 生产 Go 服务部署目录存在 = 生产机，拒绝(此目录仅生产机有，开发机无)
if [ -d /opt/telegram/server ]; then
    echo "❌❌ 拒绝执行: 检测到生产部署目录 /opt/telegram/server，判定为生产环境，拒绝清库。"
    exit 1
fi
# 必须存在开发工程标志(本地仓库),否则不是开发机
if [ ! -f "$PROJECT_DIR/pubspec.yaml" ]; then
    echo "❌ 拒绝执行: 未找到 $PROJECT_DIR/pubspec.yaml，无法确认这是本地开发工程。"
    exit 1
fi

TABLES=(
    synced_messages
    synced_group_messages
    group_members
    groups
    user_relations
    favorites
    favorite_contacts
    favorite_groups
    file_assistant_messages
    scheduled_messages
)

echo "目标数据库: $DB_USER@$DB_HOST:${DB_PORT:-5432}/$DB_NAME"
echo ""
echo "各表当前行数:"
for t in "${TABLES[@]}"; do
    count=$($PSQL -t -A -c "SELECT COUNT(*) FROM $t" 2>/dev/null || echo "表不存在")
    printf "  %-28s %s\n" "$t" "$count"
done
echo ""

if [ "$1" != "--yes" ]; then
    echo "🔍 演练模式：未删除任何数据。确认无误后执行:"
    echo "   ./scripts/clear_test_data.sh --yes"
    exit 0
fi

# 执行前备份受影响的表
BACKUP_DIR="$PROJECT_DIR/server/backups"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/test_data_before_clear_$(date +%Y%m%d_%H%M%S).sql"
echo "📦 备份受影响的表到: $BACKUP_FILE"
TABLE_ARGS=""
for t in "${TABLES[@]}"; do TABLE_ARGS="$TABLE_ARGS -t $t"; done
pg_dump -h "$DB_HOST" -p "${DB_PORT:-5432}" -U "$DB_USER" -d "$DB_NAME" $TABLE_ARGS --data-only > "$BACKUP_FILE"
echo "✅ 备份完成 ($(du -h "$BACKUP_FILE" | cut -f1))"
echo ""

echo "🗑  清除数据..."
TRUNCATE_LIST=$(IFS=,; echo "${TABLES[*]}")
$PSQL -c "TRUNCATE TABLE $TRUNCATE_LIST RESTART IDENTITY CASCADE;"
echo ""
echo "✅ 测试数据已清除(用户账号保留)。各表行数:"
for t in "${TABLES[@]}"; do
    count=$($PSQL -t -A -c "SELECT COUNT(*) FROM $t" 2>/dev/null || echo "-")
    printf "  %-28s %s\n" "$t" "$count"
done
echo ""
echo "提示: Agora Chat 云端会话不受影响；客户端重新登录后本地缓存会按服务器数据重建。"
