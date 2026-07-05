package controllers

import (
	"time"

	"telegram-server/db"
	"telegram-server/utils"

	"github.com/gin-gonic/gin"
)

// MessageSyncController 消息同步归档接口
// 消息体系迁移到 Agora Chat 后，服务器不再经手聊天消息；
// 由接收方客户端在收到消息后【异步】上报，归档到 synced_messages / synced_group_messages，
// 供管理后台展示与搜索。agora_msg_id 唯一约束保证群成员/多端重复上报幂等。
type MessageSyncController struct{}

// NewMessageSyncController 创建 MessageSyncController
func NewMessageSyncController() *MessageSyncController {
	return &MessageSyncController{}
}

// syncedMessageItem 客户端上报的单条消息
type syncedMessageItem struct {
	IsGroup              bool   `json:"is_group"`
	AgoraMsgID           string `json:"agora_msg_id"`
	SenderID             int    `json:"sender_id"`
	ReceiverID           int    `json:"receiver_id"` // 单聊：接收者用户ID
	GroupID              int    `json:"group_id"`    // 群聊：本地群ID
	SenderName           string `json:"sender_name"`
	ReceiverName         string `json:"receiver_name"`
	SenderNickname       string `json:"sender_nickname"`
	SenderFullName       string `json:"sender_full_name"`
	Content              string `json:"content"`
	MessageType          string `json:"message_type"`
	FileName             string `json:"file_name"`
	VoiceDuration        int    `json:"voice_duration"`
	QuotedMessageContent string `json:"quoted_message_content"`
	CreatedAtMs          int64  `json:"created_at_ms"` // 消息发送时间（毫秒时间戳）
}

type syncBatchRequest struct {
	Messages []syncedMessageItem `json:"messages" binding:"required"`
}

type syncRecallRequest struct {
	AgoraMsgIDs []string `json:"agora_msg_ids" binding:"required"`
}

// 单次上报数量上限（客户端按接收批次上报，正常远小于该值）
const maxSyncBatchSize = 200

// SyncBatch POST /api/message-sync/batch
// 批量归档消息。重复上报（群里多个成员、同账号多端）靠 ON CONFLICT DO NOTHING 幂等，
// 返回本次实际新入库的条数。
func (mc *MessageSyncController) SyncBatch(c *gin.Context) {
	var req syncBatchRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "参数错误: "+err.Error())
		return
	}
	if len(req.Messages) > maxSyncBatchSize {
		req.Messages = req.Messages[:maxSyncBatchSize]
	}

	saved := 0
	for _, m := range req.Messages {
		if m.AgoraMsgID == "" || m.SenderID <= 0 {
			continue
		}
		if m.MessageType == "" {
			m.MessageType = "text"
		}
		createdAt := time.Now().UTC()
		if m.CreatedAtMs > 0 {
			createdAt = time.UnixMilli(m.CreatedAtMs).UTC()
		}

		var (
			res interface{ RowsAffected() (int64, error) }
			err error
		)
		if m.IsGroup {
			if m.GroupID <= 0 {
				continue
			}
			res, err = db.DB.Exec(`
				INSERT INTO synced_group_messages
					(agora_msg_id, group_id, sender_id, sender_name, sender_nickname, sender_full_name,
					 content, message_type, file_name, voice_duration, quoted_message_content, created_at)
				VALUES ($1, $2, $3, $4, NULLIF($5, ''), NULLIF($6, ''),
					 $7, $8, NULLIF($9, ''), NULLIF($10, 0), NULLIF($11, ''), $12)
				ON CONFLICT (agora_msg_id) DO NOTHING`,
				m.AgoraMsgID, m.GroupID, m.SenderID, m.SenderName, m.SenderNickname, m.SenderFullName,
				m.Content, m.MessageType, m.FileName, m.VoiceDuration, m.QuotedMessageContent, createdAt)
		} else {
			if m.ReceiverID <= 0 {
				continue
			}
			res, err = db.DB.Exec(`
				INSERT INTO synced_messages
					(agora_msg_id, sender_id, sender_name, receiver_id, receiver_name,
					 content, message_type, file_name, voice_duration, quoted_message_content, created_at)
				VALUES ($1, $2, $3, $4, $5,
					 $6, $7, NULLIF($8, ''), NULLIF($9, 0), NULLIF($10, ''), $11)
				ON CONFLICT (agora_msg_id) DO NOTHING`,
				m.AgoraMsgID, m.SenderID, m.SenderName, m.ReceiverID, m.ReceiverName,
				m.Content, m.MessageType, m.FileName, m.VoiceDuration, m.QuotedMessageContent, createdAt)
		}
		if err != nil {
			utils.LogDebug("⚠️ [MessageSync] 归档失败 msgId=%s err=%v", m.AgoraMsgID, err)
			continue
		}
		if n, raErr := res.RowsAffected(); raErr == nil && n > 0 {
			saved++
		}
	}
	utils.Success(c, gin.H{"saved": saved, "received": len(req.Messages)})
}

// SyncRecall POST /api/message-sync/recall
// 消息被撤回时，把归档记录状态标记为 recalled（单聊/群聊两张表都尝试更新）。
func (mc *MessageSyncController) SyncRecall(c *gin.Context) {
	var req syncRecallRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "参数错误: "+err.Error())
		return
	}
	if len(req.AgoraMsgIDs) > maxSyncBatchSize {
		req.AgoraMsgIDs = req.AgoraMsgIDs[:maxSyncBatchSize]
	}

	updated := 0
	for _, id := range req.AgoraMsgIDs {
		if id == "" {
			continue
		}
		for _, table := range []string{"synced_messages", "synced_group_messages"} {
			res, err := db.DB.Exec(
				`UPDATE `+table+` SET status = 'recalled' WHERE agora_msg_id = $1 AND status <> 'recalled'`, id)
			if err != nil {
				utils.LogDebug("⚠️ [MessageSync] 撤回标记失败 msgId=%s err=%v", id, err)
				continue
			}
			if n, raErr := res.RowsAffected(); raErr == nil && n > 0 {
				updated++
			}
		}
	}
	utils.Success(c, gin.H{"updated": updated})
}
