-- =====================================================================
-- 上线前清空历史测试数据脚本
-- 数据库: youdu_db
--
-- ⚠️⚠️ 本脚本会清空所有用户、好友关系、群组、收藏、邀请码等业务数据，
--      不可恢复！执行前必须先备份：
--
--   pg_dump -h localhost -U postgres -d youdu_db -F c \
--     -f youdu_db_before_golive_$(date +%Y%m%d_%H%M%S).dump
--
-- 执行方式:
--   psql -h localhost -U postgres -d youdu_db -f clear_test_data.sql
--
-- 【保留】的表（配置/管理数据，不动）:
--   admin_user        管理后台账号
--   server_settings   服务端配置
--   oss_prefix_config OSS前缀域名配置
--   app_versions      App版本/升级配置
--
-- 【清空】的表（所有测试业务数据，ID序列重置为1）:
--   users                    用户
--   user_relations           好友关系/申请
--   groups / group_members   群组及成员
--   favorites / favorite_contacts / favorite_groups  收藏
--   file_assistant_messages  文件助手消息
--   device_registrations     设备注册记录
--   verification_codes       验证码
--   scheduled_messages       定时消息
--   invite_codes / invite_code_usages  邀请码（上线后在管理后台重新生成）
--
-- 【注意】聊天消息不在本库：已迁移到 Agora Chat 云端，
--   测试期的会话/消息/用户需在 Agora 控制台单独清理（见脚本末尾说明）。
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 清空前统计（留档核对）
-- ---------------------------------------------------------------------
SELECT 'users'                   AS table_name, COUNT(*) AS rows FROM users
UNION ALL SELECT 'user_relations',          COUNT(*) FROM user_relations
UNION ALL SELECT 'groups',                  COUNT(*) FROM groups
UNION ALL SELECT 'group_members',           COUNT(*) FROM group_members
UNION ALL SELECT 'favorites',               COUNT(*) FROM favorites
UNION ALL SELECT 'favorite_contacts',       COUNT(*) FROM favorite_contacts
UNION ALL SELECT 'favorite_groups',         COUNT(*) FROM favorite_groups
UNION ALL SELECT 'file_assistant_messages', COUNT(*) FROM file_assistant_messages
UNION ALL SELECT 'device_registrations',    COUNT(*) FROM device_registrations
UNION ALL SELECT 'verification_codes',      COUNT(*) FROM verification_codes
UNION ALL SELECT 'scheduled_messages',      COUNT(*) FROM scheduled_messages
UNION ALL SELECT 'invite_codes',            COUNT(*) FROM invite_codes
UNION ALL SELECT 'invite_code_usages',      COUNT(*) FROM invite_code_usages
ORDER BY table_name;

BEGIN;

-- ---------------------------------------------------------------------
-- 清空业务数据（RESTART IDENTITY: ID序列重置为1；CASCADE: 自动处理外键引用）
-- ---------------------------------------------------------------------
TRUNCATE TABLE
  users,
  user_relations,
  groups,
  group_members,
  favorites,
  favorite_contacts,
  favorite_groups,
  file_assistant_messages,
  device_registrations,
  verification_codes,
  scheduled_messages,
  invite_codes,
  invite_code_usages
RESTART IDENTITY CASCADE;

-- ---------------------------------------------------------------------
-- 旧版消息表：生产库已于 2026-06-28 DROP（消息迁移到 Agora Chat）。
-- 兼容其他环境（如本地/测试库还留着这些表）：存在才清空，不存在跳过。
-- ---------------------------------------------------------------------
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'messages',
    'group_messages',
    'group_message_reads',
    'private_message_synced'
  ] LOOP
    IF to_regclass('public.' || t) IS NOT NULL THEN
      EXECUTE format('TRUNCATE TABLE public.%I RESTART IDENTITY CASCADE', t);
      RAISE NOTICE '已清空旧消息表: %', t;
    END IF;
  END LOOP;
END $$;

COMMIT;

-- ---------------------------------------------------------------------
-- 清空后验证：业务表应全部为 0，配置表应保持原样
-- ---------------------------------------------------------------------
SELECT 'users'                   AS table_name, COUNT(*) AS rows FROM users
UNION ALL SELECT 'user_relations',          COUNT(*) FROM user_relations
UNION ALL SELECT 'groups',                  COUNT(*) FROM groups
UNION ALL SELECT 'group_members',           COUNT(*) FROM group_members
UNION ALL SELECT 'favorites',               COUNT(*) FROM favorites
UNION ALL SELECT 'favorite_contacts',       COUNT(*) FROM favorite_contacts
UNION ALL SELECT 'favorite_groups',         COUNT(*) FROM favorite_groups
UNION ALL SELECT 'file_assistant_messages', COUNT(*) FROM file_assistant_messages
UNION ALL SELECT 'device_registrations',    COUNT(*) FROM device_registrations
UNION ALL SELECT 'verification_codes',      COUNT(*) FROM verification_codes
UNION ALL SELECT 'scheduled_messages',      COUNT(*) FROM scheduled_messages
UNION ALL SELECT 'invite_codes',            COUNT(*) FROM invite_codes
UNION ALL SELECT 'invite_code_usages',      COUNT(*) FROM invite_code_usages
UNION ALL SELECT '[保留] admin_user',        COUNT(*) FROM admin_user
UNION ALL SELECT '[保留] server_settings',   COUNT(*) FROM server_settings
UNION ALL SELECT '[保留] oss_prefix_config', COUNT(*) FROM oss_prefix_config
UNION ALL SELECT '[保留] app_versions',      COUNT(*) FROM app_versions
ORDER BY table_name;

-- =====================================================================
-- 数据库之外还需要手动清理的测试数据（本脚本管不到）：
--
-- 1. Agora Chat 云端数据（聊天消息/会话/IM用户都在 Agora 那边）：
--    在 Agora 控制台（声网 Console → 即时通讯 IM → 用户管理）删除测试用户，
--    或调用 REST API 批量删除。更干净的做法是给生产环境换一个新的
--    Agora AppKey，测试数据留在旧 AppKey 里自然隔离。
--
-- 2. 上传的文件（头像/图片/视频/语音）：
--    存在服务器磁盘或 OSS bucket 里（如 xbdchat.com/avatars/、/images/），
--    按目录清空测试期上传的文件。
--
-- 3. 客户端本地缓存：测试手机上卸载重装 App（本地 SQLite 有测试消息）。
-- =====================================================================
