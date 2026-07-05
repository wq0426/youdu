#!/bin/bash
# 重置测试环境 —— 清空除配置表外的所有数据(从 0 开始测试)
# 只针对本地开发库；生产环境会被硬拒绝。
#
# 用法:
#   ./scripts/reset_test_env.sh          # 演练: 列出将清空/保留的表，不删除
#   ./scripts/reset_test_env.sh --yes    # 真正执行(先自动全库备份)
#
# 策略: 动态发现 public schema 下所有表，除 KEEP_TABLES 外全部 TRUNCATE
#       (RESTART IDENTITY 重置自增，CASCADE 处理外键)。
#       动态发现保证新增的表也会被清，不会漏。
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/server/.env"

# ── 保留的配置表(不清空)。如需多留几张，往这里加即可 ──
KEEP_TABLES="server_settings"

DB_HOST=$(grep '^DB_HOST=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
DB_PORT=$(grep '^DB_PORT=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
DB_USER=$(grep '^DB_USER=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
DB_NAME=$(grep '^DB_NAME=' "$ENV_FILE" | cut -d= -f2- | tr -d '\r')
# 密码变量名兼容: 优先 DB_PASSWORD，回退 PASSWORD2(生产环境用的名字)；都没有则走 trust 认证
DB_PASSWORD=$(grep -E '^(DB_PASSWORD|PASSWORD2)=' "$ENV_FILE" | head -1 | cut -d= -f2- | tr -d '\r' | tr -d "'\"")
export PGPASSWORD="$DB_PASSWORD"
PSQL="psql -h $DB_HOST -p ${DB_PORT:-5432} -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1"

# ⚠️ 环境限制已按要求移除：本脚本可在任何环境(含生产)执行。
#    仍保留的保险: 默认演练模式(不删) + 删前全库备份 + 必须显式 --yes。

# ── 动态发现所有表，拆分为 保留 / 清空 ──
ALL_TABLES=$($PSQL -t -A -c "SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY tablename")
KEEP_LIST=" $KEEP_TABLES "
TRUNCATE_TABLES=""
for t in $ALL_TABLES; do
    case "$KEEP_LIST" in
        *" $t "*) : ;;                       # 在保留清单里，跳过
        *) TRUNCATE_TABLES="$TRUNCATE_TABLES $t" ;;
    esac
done

echo "目标数据库: $DB_USER@$DB_HOST:${DB_PORT:-5432}/$DB_NAME"
echo ""
echo "【保留】配置表:"
for t in $KEEP_TABLES; do
    c=$($PSQL -t -A -c "SELECT COUNT(*) FROM $t" 2>/dev/null || echo "表不存在")
    printf "  ✅ %-26s %s 行\n" "$t" "$c"
done
echo ""
echo "【清空】以下表(含 users、admin_user、app_versions 等):"
for t in $TRUNCATE_TABLES; do
    c=$($PSQL -t -A -c "SELECT COUNT(*) FROM $t" 2>/dev/null || echo "?")
    printf "  🗑  %-26s %s 行\n" "$t" "$c"
done
echo ""

if [ "$1" != "--yes" ]; then
    echo "🔍 演练模式：未删除任何数据。确认无误后执行:"
    echo "   ./scripts/reset_test_env.sh --yes"
    exit 0
fi

# ── 真正执行前再打印一次目标，给最后一次核对机会 ──
echo "═══════════════════════════════════════════════"
echo " ⚠️  即将清空数据库: $DB_NAME @ $DB_HOST:${DB_PORT:-5432}"
echo "     配置文件: $ENV_FILE"
echo "═══════════════════════════════════════════════"

# ── 执行前: 全库备份 ──
BACKUP_DIR="$PROJECT_DIR/server/backups"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/reset_test_env_$(date +%Y%m%d_%H%M%S).sql.gz"
echo "📦 全库备份到: $BACKUP_FILE"
pg_dump -h "$DB_HOST" -p "${DB_PORT:-5432}" -U "$DB_USER" -d "$DB_NAME" | gzip > "$BACKUP_FILE"
echo "✅ 备份完成 ($(du -h "$BACKUP_FILE" | cut -f1))"
echo ""

# ── 清空(一条 TRUNCATE 处理所有表，CASCADE + 重置自增) ──
echo "🗑  清空数据..."
TRUNCATE_CSV=$(echo $TRUNCATE_TABLES | tr ' ' ',')
$PSQL -c "TRUNCATE TABLE $TRUNCATE_CSV RESTART IDENTITY CASCADE;"
echo ""
echo "✅ 完成。现在各表行数:"
for t in $ALL_TABLES; do
    c=$($PSQL -t -A -c "SELECT COUNT(*) FROM $t" 2>/dev/null || echo "-")
    printf "  %-28s %s\n" "$t" "$c"
done
echo ""
echo "⚠️  提醒:"
echo "   - admin_user 已清空 → 需重新创建后台管理员才能登录管理后台"
echo "   - app_versions 已清空 → 客户端\"检查更新\"在重新录入版本前会查不到"
echo "   - 聊天消息在 Agora Chat 云端，本脚本不涉及，需要时去 Agora 控制台清"
