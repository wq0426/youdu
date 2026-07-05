-- 消息同步归档表
-- 背景：阶段6把消息体系整体迁移到 Agora Chat 云端后，本地 messages / group_messages 已删除，
--      服务器不再经手聊天消息。为了让管理后台能展示/搜索所有用户的聊天记录，
--      由【接收方客户端】在收到 Agora 消息后异步上报（POST /api/message-sync/batch），
--      归档到下面两张表。agora_msg_id 唯一约束保证群成员/多端重复上报幂等。
-- 说明：server 启动时会用 IF NOT EXISTS 自建这两张表（db/db.go 轻量自迁移），
--      本文件仅作为迁移记录，手工执行也是安全的。

-- 单聊消息归档
CREATE TABLE IF NOT EXISTS synced_messages (
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
);
CREATE INDEX IF NOT EXISTS idx_synced_messages_created_at ON synced_messages (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_synced_messages_sender ON synced_messages (sender_id);
CREATE INDEX IF NOT EXISTS idx_synced_messages_receiver ON synced_messages (receiver_id);

-- 群聊消息归档
CREATE TABLE IF NOT EXISTS synced_group_messages (
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
);
CREATE INDEX IF NOT EXISTS idx_synced_group_messages_created_at ON synced_group_messages (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_synced_group_messages_group ON synced_group_messages (group_id);
CREATE INDEX IF NOT EXISTS idx_synced_group_messages_sender ON synced_group_messages (sender_id);
