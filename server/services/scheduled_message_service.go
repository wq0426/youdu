package services

import (
	"fmt"
	"time"

	"telegram-server/db"
	"telegram-server/models"
	"telegram-server/utils"
	ws "telegram-server/websocket"
)

// ScheduledMessageService 定时消息服务
type ScheduledMessageService struct {
	hub      *ws.Hub
	repo     *models.ScheduledMessageRepository
	userRepo *models.UserRepository
	groupRepo *models.GroupRepository
}

// NewScheduledMessageService 创建定时消息服务
func NewScheduledMessageService(hub *ws.Hub) *ScheduledMessageService {
	return &ScheduledMessageService{
		hub:      hub,
		repo:     models.NewScheduledMessageRepository(db.DB),
		userRepo: models.NewUserRepository(db.DB),
		groupRepo: models.NewGroupRepository(db.DB),
	}
}

// StartScheduler 启动定时任务调度器
func (s *ScheduledMessageService) StartScheduler() {
	utils.LogInfo("✅ 定时消息调度器已启动")
	
	go func() {
		for {
			// 计算到下一分钟0秒的时间
			now := time.Now()
			nextMinute := now.Truncate(time.Minute).Add(time.Minute)
			sleepDuration := nextMinute.Sub(now)
			
			// 等待到下一分钟0秒
			time.Sleep(sleepDuration)
			
			// 执行定时任务
			s.executeScheduledMessages()
		}
	}()
}

// executeScheduledMessages 执行定时消息发送
func (s *ScheduledMessageService) executeScheduledMessages() {
	// 获取当前时间（HH:MM格式）和日期（YYYY-MM-DD格式）
	now := time.Now()
	currentTime := now.Format("15:04")
	currentDate := now.Format("2006-01-02")
	utils.LogDebug("⏰ [定时消息] 开始执行定时任务，当前时间: %s, 日期: %s", currentTime, currentDate)
	
	// 查询待发送的消息
	messages, err := s.repo.GetPendingMessages(currentTime, currentDate)
	if err != nil {
		utils.LogDebug("❌ [定时消息] 查询待发送消息失败: %v", err)
		return
	}
	
	if len(messages) == 0 {
		utils.LogDebug("📭 [定时消息] 当前时间没有待发送的消息")
		return
	}
	
	utils.LogDebug("📬 [定时消息] 找到 %d 条待发送消息", len(messages))
	
	// 同步顺序发送消息，避免并发问题
	for i, msg := range messages {
		utils.LogDebug("📤 [定时消息] 正在发送第 %d/%d 条消息", i+1, len(messages))
		s.sendMessage(msg)
	}
	
	utils.LogDebug("✅ [定时消息] 本轮定时任务执行完成")
}

// sendMessage 发送单条定时消息
func (s *ScheduledMessageService) sendMessage(msg *models.ScheduledMessage) {
	utils.LogDebug("📤 [定时消息] 开始发送消息 - ID: %d, 发送者: %d, 接收者: %d, 类型: %s", 
		msg.ID, msg.SenderID, msg.ReceiverID, msg.MessageType)
	
	var err error
	if msg.MessageType == models.ScheduledMessageTypePrivate {
		err = s.sendPrivateMessage(msg)
	} else {
		err = s.sendGroupMessage(msg)
	}
	
	if err != nil {
		utils.LogDebug("❌ [定时消息] 发送失败 - ID: %d, 错误: %v", msg.ID, err)
		return
	}
	
	// 如果是单次任务，标记为已发送
	if msg.SendType == models.ScheduledMessageSendTypeOnce {
		if err := s.repo.MarkAsSent(msg.ID); err != nil {
			utils.LogDebug("❌ [定时消息] 标记已发送失败 - ID: %d, 错误: %v", msg.ID, err)
		} else {
			utils.LogDebug("✅ [定时消息] 单次任务已标记为已发送 - ID: %d", msg.ID)
		}
	} else {
		utils.LogDebug("🔄 [定时消息] 每日任务保持待发送状态 - ID: %d", msg.ID)
	}
}

// sendPrivateMessage 发送私聊消息
//
// 迁移到 Agora Chat：不再写入 messages 表，改为以发送者身份通过 Agora Chat REST 代发文本消息。
// 代发的消息会持久化进 Agora 会话并支持离线投递，发送方与接收方的客户端均通过 onMessagesReceived 收到。
func (s *ScheduledMessageService) sendPrivateMessage(msg *models.ScheduledMessage) error {
	// 获取发送者信息
	sender, err := s.userRepo.FindByID(msg.SenderID)
	if err != nil {
		return err
	}

	// 获取接收者信息
	receiver, err := s.userRepo.FindByID(msg.ReceiverID)
	if err != nil {
		return err
	}

	senderName := sender.Username
	if sender.FullName != nil && *sender.FullName != "" {
		senderName = *sender.FullName
	}
	receiverName := receiver.Username
	if receiver.FullName != nil && *receiver.FullName != "" {
		receiverName = *receiver.FullName
	}

	// 透传业务字段，保证客户端按既有 ext 契约还原渲染
	ext := map[string]interface{}{
		"sender_name":     senderName,
		"sender_avatar":   sender.Avatar,
		"receiver_name":   receiverName,
		"receiver_avatar": receiver.Avatar,
		"message_type":    "text",
	}

	if err := AgoraChatGroup.SendUserText(msg.SenderID, msg.ReceiverID, msg.Content, ext); err != nil {
		return err
	}

	utils.LogDebug("✅ [定时消息] 私聊消息已代发(Agora) - 发送者: %s, 接收者: %s", senderName, receiverName)
	return nil
}

// sendGroupMessage 发送群聊消息
//
// 迁移到 Agora Chat：不再写入 group_messages 表，改为以发送者身份通过 Agora Chat REST 向群代发文本消息。
func (s *ScheduledMessageService) sendGroupMessage(msg *models.ScheduledMessage) error {
	// 获取发送者信息
	sender, err := s.userRepo.FindByID(msg.SenderID)
	if err != nil {
		return err
	}

	// 获取发送者在群组中的昵称（群昵称 > 全名 > 用户名）
	senderName := sender.Username
	if sender.FullName != nil && *sender.FullName != "" {
		senderName = *sender.FullName
	}
	nickname, fullName, _, _, err := s.groupRepo.GetGroupMemberInfo(msg.ReceiverID, msg.SenderID)
	if err == nil {
		if nickname != nil && *nickname != "" {
			senderName = *nickname
		} else if fullName != nil && *fullName != "" {
			senderName = *fullName
		}
	}

	// 解析本地群ID对应的 Agora 群会话ID
	agoraGroupID, err := s.groupRepo.GetAgoraGroupID(msg.ReceiverID)
	if err != nil || agoraGroupID == "" {
		utils.LogDebug("⚠️ [定时消息] 群 %d 未同步到 Agora（agora_group_id 为空），跳过群消息代发", msg.ReceiverID)
		return fmt.Errorf("群 %d 缺少 agora_group_id", msg.ReceiverID)
	}

	ext := map[string]interface{}{
		"sender_name":   senderName,
		"sender_avatar": sender.Avatar,
		"message_type":  "text",
	}

	if err := AgoraChatGroup.SendGroupText(msg.SenderID, agoraGroupID, msg.Content, ext); err != nil {
		return err
	}

	utils.LogDebug("✅ [定时消息] 群聊消息已代发(Agora) - GroupID: %d, Agora群: %s, 发送者: %s", msg.ReceiverID, agoraGroupID, senderName)
	return nil
}
