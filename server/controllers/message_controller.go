package controllers

import (
	"encoding/json"
	"net/http"
	"time"

	"telegram-server/db"
	"telegram-server/models"
	"telegram-server/utils"
	ws "telegram-server/websocket"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	HandshakeTimeout: 10 * time.Second, // 🔴 握手超时，防止慢速握手占用资源
	ReadBufferSize:   1024,
	WriteBufferSize:  1024,
	CheckOrigin: func(r *http.Request) bool {
		return true // 允许所有来源，生产环境应该限制
	},
}

// MessageController 消息控制器
type MessageController struct {
	Hub         *ws.Hub
	userRepo    *models.UserRepository
	contactRepo *models.ContactRepository
	groupRepo   *models.GroupRepository
	CallCtrl    *CallController // 🔴 新增：CallController 引用，用于清理群组通话状态
}

// NewMessageController 创建消息控制器
func NewMessageController(hub *ws.Hub) *MessageController {
	mc := &MessageController{
		Hub:         hub,
		userRepo:    models.NewUserRepository(db.DB),
		contactRepo: models.NewContactRepository(db.DB),
		groupRepo:   models.NewGroupRepository(db.DB),
	}

	// 设置离线通知回调
	hub.OnUserOffline = mc.sendOfflineNotification

	// 🔴 设置消息处理回调并启动worker协程
	hub.SetMessageHandler(mc.handleMessage)
	hub.StartMessageWorkers()

	return mc
}

// HandleWebSocket 处理WebSocket连接
func (mc *MessageController) HandleWebSocket(c *gin.Context) {
	// 从查询参数或header中获取token
	token := c.Query("token")
	if token == "" {
		token = c.GetHeader("Authorization")
	}

	if token == "" {
		utils.LogDebug("❌ [WebSocket] 未提供token")
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "未提供token"})
		return
	}

	var userID int

	// 🔴 服务器间通信：如果token为NO_SERVER_TOKEN，跳过token校验
	// 这是服务器B连接服务器A时使用的特殊token，用于消息同步服务
	if token == "NO_SERVER_TOKEN" {
		utils.LogDebug("✅ [WebSocket] 服务器间通信连接，跳过token校验")
		userID = 0 // 服务器连接使用特殊的userID=0
	} else {
		// 验证token
		claims, err := utils.ParseToken(token)
		if err != nil {
			utils.LogDebug("❌ [WebSocket] token验证失败: %v, token: %s", err, token[:20]+"...")
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "无效的token"})
			return
		}

		userID = claims.UserID

		// 🔴 单设备登录限制：验证token是否为当前活跃的token
		isValid, err := mc.userRepo.ValidateActiveToken(userID, token)
		if err != nil {
			utils.LogDebug("⚠️ [WebSocket] 验证active_token失败: %v", err)
			// 数据库错误时不阻止连接，继续处理
		} else if !isValid {
			utils.LogDebug("❌ [WebSocket] token不是当前活跃token，拒绝连接 - UserID: %d", userID)
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "您的账号已在其他设备登录，请重新登录"})
			return
		}

		utils.LogDebug("✅ [WebSocket] token验证成功 - UserID: %d", userID)
	}

	// 升级HTTP连接为WebSocket
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		utils.LogDebug("❌ [WebSocket] 升级失败: %v", err)
		return
	}
	utils.LogDebug("✅ [WebSocket] 连接升级成功 - UserID: %d", userID)

	// 创建客户端
	wsConn := ws.NewConn(conn)
	client := &ws.Client{
		UserID: userID,
		Conn:   wsConn,
		Send:   make(chan []byte, 256),
	}

	// 注册客户端（直接方法调用，只做微秒级 map 操作，不会被其他连接阻塞）
	mc.Hub.RegisterClient(client)

	// 🔴 服务器间通信（userID=0）不需要发送上线通知
	// 🔵 阶段6：离线消息已迁移到 Agora Chat（自带离线投递），不再从 messages/group_messages 补推。
	if userID > 0 {
		// 发送上线通知给联系人
		go mc.sendOnlineNotification(client)
	}

	// 启动读写协程
	go wsConn.WritePump(client, mc.Hub)
	go wsConn.ReadPump(client, mc.Hub, mc.handleMessage)
}

// handleMessage 处理接收到的消息
func (mc *MessageController) handleMessage(client *ws.Client, message []byte) {
	var wsMsg models.WSMessage
	if err := json.Unmarshal(message, &wsMsg); err != nil {
		utils.LogDebug("解析消息失败: %v", err)
		return
	}

	switch wsMsg.Type {
	// 🔵 阶段6：私聊/群聊消息发送已迁移到 Agora Chat，"message"/"group_message_send" 帧客户端不再发送，
	// 对应 handleSendMessage/handleSendGroupMessage 已删除。
	// 🔵 阶段6：已读回执已迁移到 Agora Chat（sendConversationReadAck / onMessagesRead），
	// "read_receipt" 帧客户端不再发送，对应 handleReadReceipt/markMessageAsRead 已删除。
	case "ping":
		// 处理心跳消息
		mc.handlePing(client)
	case "status_change":
		// 处理状态变更
		mc.handleStatusChange(client, wsMsg)
	case "typing_indicator":
		// 处理正在输入指示器
		mc.handleTypingIndicator(client, wsMsg)
	case "offer", "answer", "ice-candidate", "call-request", "call-accepted", "call-rejected", "call-ended", "call-cancel", "call-busy", "incoming_call", "incoming_group_call", "group_call_started", "group_call_member_accepted", "group_call_member_left", "group_call_ended":
		// 处理WebRTC信令（包括群组通话相关信令）
		mc.handleWebRTCSignal(client, wsMsg)
	// 🔵 阶段6：消息撤回已迁移到 Agora Chat（recallMessage），"message_recall" 帧客户端不再发送，
	// 对应 handleMessageRecall/handleGroupMessageRecall/handlePrivateMessageRecall 已删除。
	// "client_sync_message"（旧 Server B 同步推送）链路亦已下线。
	default:
		utils.LogDebug("未知消息类型: %s", wsMsg.Type)
	}
}

// handlePing 处理心跳消息
func (mc *MessageController) handlePing(client *ws.Client) {
	// 重置客户端的心跳计数器
	client.ResetPingCounter()

	// 回复pong消息
	pongMsg := models.WSMessage{
		Type: "pong",
		Data: gin.H{
			"timestamp": time.Now().Unix(),
		},
	}
	pongMsgBytes, _ := json.Marshal(pongMsg)
	client.SafeSend(pongMsgBytes)
}

// handleStatusChange 处理状态变更
func (mc *MessageController) handleStatusChange(client *ws.Client, wsMsg models.WSMessage) {
	// 解析状态数据
	dataMap, ok := wsMsg.Data.(map[string]interface{})
	if !ok {
		utils.LogDebug("状态变更数据格式错误")
		return
	}

	status, ok := dataMap["status"].(string)
	if !ok || status == "" {
		utils.LogDebug("状态值格式错误或为空")
		return
	}

	// 验证状态值是否有效
	validStatuses := map[string]bool{
		"online":  true,
		"busy":    true,
		"away":    true,
		"offline": true,
	}
	if !validStatuses[status] {
		utils.LogDebug("无效的状态值: %s", status)
		return
	}

	// 更新数据库中的用户状态
	err := mc.userRepo.UpdateStatus(client.UserID, status)
	if err != nil {
		utils.LogDebug("更新用户状态失败: %v", err)
		// 发送错误响应给客户端
		errorMsg := models.WSMessage{
			Type: "status_change_error",
			Data: gin.H{
				"error": "更新状态失败",
			},
		}
		errorMsgBytes, _ := json.Marshal(errorMsg)
		client.SafeSend(errorMsgBytes)
		return
	}

	utils.LogDebug("✅ 用户 %d 状态通过WebSocket更新为: %s", client.UserID, status)

	// 获取当前用户信息（用于发送通知）
	user, err := mc.userRepo.FindByID(client.UserID)
	if err != nil {
		utils.LogDebug("⚠️ 获取用户信息失败，无法发送状态变更通知: %v", err)
		return
	}

	// 获取用户的所有联系人
	contacts, err := mc.contactRepo.GetContactsByUserID(client.UserID)
	if err != nil {
		utils.LogDebug("⚠️ 获取联系人列表失败，无法发送状态变更通知: %v", err)
		return
	}

	// 构造状态变更消息
	statusChangeMsg := models.WSMessage{
		Type: "status_change",
		Data: gin.H{
			"user_id":   client.UserID,
			"username":  user.Username,
			"full_name": user.FullName,
			"status":    status,
		},
	}

	msgBytes, err := json.Marshal(statusChangeMsg)
	if err != nil {
		utils.LogDebug("⚠️ 序列化状态变更消息失败: %v", err)
		return
	}

	// 向所有联系人推送状态变更消息
	notifiedCount := 0
	for _, contact := range contacts {
		if mc.Hub.SendToUser(contact.FriendID, msgBytes) {
			notifiedCount++
		}
	}

	utils.LogDebug("📤 WebSocket状态变更通知已发送，共 %d/%d 个联系人在线", notifiedCount, len(contacts))

	// 发送成功确认给发送者
	confirmMsg := models.WSMessage{
		Type: "status_change_success",
		Data: gin.H{
			"status": status,
		},
	}
	confirmMsgBytes, _ := json.Marshal(confirmMsg)
	client.SafeSend(confirmMsgBytes)
}

// handleTypingIndicator 处理正在输入指示器
func (mc *MessageController) handleTypingIndicator(client *ws.Client, wsMsg models.WSMessage) {
	// 解析正在输入数据
	dataMap, ok := wsMsg.Data.(map[string]interface{})
	if !ok {
		utils.LogDebug("正在输入指示器数据格式错误")
		return
	}

	// 获取接收者ID
	var receiverID int
	if receiverIDFloat, ok := dataMap["receiver_id"].(float64); ok {
		receiverID = int(receiverIDFloat)
	} else if receiverIDInt, ok := dataMap["receiver_id"].(int); ok {
		receiverID = receiverIDInt
	} else {
		utils.LogDebug("正在输入指示器缺少接收者ID")
		return
	}

	// 获取是否正在输入
	isTyping, ok := dataMap["is_typing"].(bool)
	if !ok {
		utils.LogDebug("正在输入指示器缺少is_typing字段")
		return
	}

	utils.LogDebug("⌨️ 收到正在输入指示器 - 发送者: %d, 接收者: %d, 正在输入: %v", client.UserID, receiverID, isTyping)

	// 构造转发给接收者的消息
	typingMsg := models.WSMessage{
		Type: "typing_indicator",
		Data: gin.H{
			"sender_id": client.UserID,
			"is_typing": isTyping,
		},
	}

	msgBytes, err := json.Marshal(typingMsg)
	if err != nil {
		utils.LogDebug("序列化正在输入指示器失败: %v", err)
		return
	}

	// 转发给接收者
	isOnline := mc.Hub.SendToUser(receiverID, msgBytes)
	if isOnline {
		utils.LogDebug("✅ 正在输入指示器已发送给用户 %d", receiverID)
	} else {
		utils.LogDebug("⚠️ 用户 %d 离线，无法接收正在输入指示器", receiverID)
	}
}

// handleWebRTCSignal 处理WebRTC信令
func (mc *MessageController) handleWebRTCSignal(client *ws.Client, wsMsg models.WSMessage) {
	// 解析信令数据
	dataMap, ok := wsMsg.Data.(map[string]interface{})
	if !ok {
		utils.LogDebug("WebRTC信令数据格式错误")
		return
	}

	// 获取目标用户ID（支持 targetUserId 和 to_user_id 两种字段名）
	var targetUserID int
	if targetUserIDFloat, ok := dataMap["targetUserId"].(float64); ok {
		targetUserID = int(targetUserIDFloat)
	} else if targetUserIDInt, ok := dataMap["targetUserId"].(int); ok {
		targetUserID = targetUserIDInt
	} else if toUserIDFloat, ok := dataMap["to_user_id"].(float64); ok {
		// 🔴 支持 to_user_id 字段（移动端 TUICallKit 使用）
		targetUserID = int(toUserIDFloat)
	} else if toUserIDInt, ok := dataMap["to_user_id"].(int); ok {
		targetUserID = toUserIDInt
	} else {
		utils.LogDebug("WebRTC信令缺少目标用户ID (targetUserId 或 to_user_id)")
		return
	}

	utils.LogDebug("📞 收到WebRTC信令: %s，发送者: %d，接收者: %d", wsMsg.Type, client.UserID, targetUserID)

	// 🔴 特殊处理：incoming_group_call 消息需要发送"加入通话"按钮到群组
	// 这是移动端 TUICallKit 发起群组通话时发送的消息
	if wsMsg.Type == "incoming_group_call" {
		mc.handleIncomingGroupCallSignal(client, dataMap)
	}

	// 🔴 特殊处理：group_call_ended 消息需要更新"加入通话"按钮为普通系统消息
	// 这是移动端 TUICallKit 群组通话结束时发送的消息
	if wsMsg.Type == "group_call_ended" {
		mc.handleGroupCallEndedSignal(client, dataMap)
	}

	// 构造转发消息
	forwardMsg := models.WSMessage{
		Type: wsMsg.Type,
		Data: dataMap,
	}

	// 添加发送者信息
	if dataMapCopy, ok := forwardMsg.Data.(map[string]interface{}); ok {
		dataMapCopy["fromUserId"] = client.UserID
		forwardMsg.Data = dataMapCopy
	}

	msgBytes, err := json.Marshal(forwardMsg)
	if err != nil {
		utils.LogDebug("序列化WebRTC信令失败: %v", err)
		return
	}

	// 转发给目标用户
	isOnline := mc.Hub.SendToUser(targetUserID, msgBytes)
	if isOnline {
		utils.LogDebug("📞 WebRTC信令已转发给用户 %d", targetUserID)
	} else {
		utils.LogDebug("📞 用户 %d 离线，无法转发WebRTC信令", targetUserID)

		// 如果是通话请求且对方离线，通知发起者
		if wsMsg.Type == "call-request" {
			offlineMsg := models.WSMessage{
				Type: "call-failed",
				Data: gin.H{
					"reason": "用户离线",
				},
			}
			offlineMsgBytes, _ := json.Marshal(offlineMsg)
			client.SafeSend(offlineMsgBytes)
		}
	}
}

// handleIncomingGroupCallSignal 处理移动端 TUICallKit 发起的群组通话信令
// 🔴 注意：不再在这里发送"加入通话"按钮消息
// 因为 call_controller.go 的 InitiateGroupCall HTTP API 已经处理了发送逻辑
// 这里只做日志记录，避免消息重复发送
func (mc *MessageController) handleIncomingGroupCallSignal(client *ws.Client, dataMap map[string]interface{}) {
	// 获取群组ID
	var groupID int
	if groupIDFloat, ok := dataMap["group_id"].(float64); ok {
		groupID = int(groupIDFloat)
	} else if groupIDInt, ok := dataMap["group_id"].(int); ok {
		groupID = groupIDInt
	}

	// 获取通话类型
	callType := "voice"
	if ct, ok := dataMap["call_type"].(string); ok {
		callType = ct
	}

	// 获取房间ID
	var roomID int
	if roomIDFloat, ok := dataMap["room_id"].(float64); ok {
		roomID = int(roomIDFloat)
	} else if roomIDInt, ok := dataMap["room_id"].(int); ok {
		roomID = roomIDInt
	}

	utils.LogDebug("📞 [incoming_group_call] 收到群组通话信令: groupID=%d, callType=%s, roomID=%d", groupID, callType, roomID)
	utils.LogDebug("📞 [incoming_group_call] 跳过发送加入通话按钮（由 InitiateGroupCall API 统一发送）")
}

// handleGroupCallEndedSignal 处理群组通话结束信令
// 当收到 group_call_ended 消息时，将"加入通话"按钮消息转换为普通系统消息
func (mc *MessageController) handleGroupCallEndedSignal(client *ws.Client, dataMap map[string]interface{}) {
	utils.LogDebug("📞 [group_call_ended] ========== 开始处理 ==========")
	utils.LogDebug("📞 [group_call_ended] 收到的数据: %+v", dataMap)

	// 获取群组ID
	var groupID int
	if groupIDFloat, ok := dataMap["group_id"].(float64); ok {
		groupID = int(groupIDFloat)
		utils.LogDebug("📞 [group_call_ended] 从 float64 解析 groupID: %d", groupID)
	} else if groupIDInt, ok := dataMap["group_id"].(int); ok {
		groupID = groupIDInt
		utils.LogDebug("📞 [group_call_ended] 从 int 解析 groupID: %d", groupID)
	} else {
		utils.LogDebug("📞 [group_call_ended] 无法解析 groupID，类型: %T, 值: %v", dataMap["group_id"], dataMap["group_id"])
	}

	// 如果没有群组ID，不处理
	if groupID <= 0 {
		utils.LogDebug("📞 [group_call_ended] 没有群组ID，跳过更新按钮消息")
		return
	}

	// 获取 channel_name（如果有的话）
	channelName := ""
	if cn, ok := dataMap["channel_name"].(string); ok {
		channelName = cn
	}

	utils.LogDebug("📞 [group_call_ended] 准备更新按钮消息: groupID=%d, channelName=%s", groupID, channelName)

	// 🔴 清理 CallController 中的群组通话状态 + 删除"加入通话"按钮消息
	// 🔵 阶段6：按钮消息已不再持久化到 group_messages（改由 CallController 内存合成ID维护），
	// 故不再 UPDATE group_messages，转为走内存路径广播 delete_message。
	if mc.CallCtrl != nil {
		mc.CallCtrl.ClearGroupCallStateByGroupID(groupID)
		utils.LogDebug("✅ [group_call_ended] 已清理群组 %d 的通话状态", groupID)

		if channelName != "" {
			go mc.CallCtrl.removeJoinCallButtonMessage(groupID, channelName)
		}
	}
}

// sendOnlineNotification 发送上线通知给所有联系人
func (mc *MessageController) sendOnlineNotification(client *ws.Client) {
	// 获取当前用户信息
	user, err := mc.userRepo.FindByID(client.UserID)
	if err != nil {
		utils.LogDebug("⚠️ 获取用户信息失败，无法发送上线通知: %v", err)
		return
	}

	// 获取用户的所有联系人
	contacts, err := mc.contactRepo.GetContactsByUserID(client.UserID)
	if err != nil {
		utils.LogDebug("⚠️ 获取联系人列表失败，无法发送上线通知: %v", err)
		return
	}

	// 构造上线通知消息
	onlineNotificationMsg := models.WSMessage{
		Type: "online_notification",
		Data: gin.H{
			"user_id":     client.UserID,
			"username":    user.Username,
			"full_name":   user.FullName,
			"avatar":      user.Avatar,
			"online_time": time.Now().Unix(),
		},
	}

	msgBytes, err := json.Marshal(onlineNotificationMsg)
	if err != nil {
		utils.LogDebug("⚠️ 序列化上线通知消息失败: %v", err)
		return
	}

	// 向所有联系人推送上线通知消息
	notifiedCount := 0
	for _, contact := range contacts {
		if mc.Hub.SendToUser(contact.FriendID, msgBytes) {
			notifiedCount++
		}
	}

	utils.LogDebug("📢 用户 %d (%s) 上线通知已发送，共 %d/%d 个联系人在线",
		client.UserID, user.Username, notifiedCount, len(contacts))
}

// sendOfflineNotification 发送离线通知给所有联系人
func (mc *MessageController) sendOfflineNotification(userID int) {
	// 🔴 服务器间通信（userID=0）不需要发送离线通知
	if userID == 0 {
		utils.LogDebug("ℹ️ [离线通知] 服务器间通信连接断开，跳过离线通知")
		return
	}

	// 更新数据库中的用户状态为离线
	err := mc.userRepo.UpdateStatus(userID, "offline")
	if err != nil {
		utils.LogDebug("⚠️ 更新用户 %d 离线状态失败: %v", userID, err)
		// 即使更新失败，仍然继续发送离线通知
	}

	// 清除用户的通话状态（用户离线时自动清除）
	mc.Hub.ClearUserCallStatus(userID)

	// 获取用户信息
	user, err := mc.userRepo.FindByID(userID)
	if err != nil {
		utils.LogDebug("⚠️ 获取用户信息失败，无法发送离线通知: %v", err)
		return
	}

	// 获取用户的所有联系人
	contacts, err := mc.contactRepo.GetContactsByUserID(userID)
	if err != nil {
		utils.LogDebug("⚠️ 获取联系人列表失败，无法发送离线通知: %v", err)
		return
	}

	// 构造离线通知消息
	offlineNotificationMsg := models.WSMessage{
		Type: "offline_notification",
		Data: gin.H{
			"user_id":      userID,
			"username":     user.Username,
			"full_name":    user.FullName,
			"avatar":       user.Avatar,
			"offline_time": time.Now().Unix(),
		},
	}

	msgBytes, err := json.Marshal(offlineNotificationMsg)
	if err != nil {
		utils.LogDebug("⚠️ 序列化离线通知消息失败: %v", err)
		return
	}

	// 向所有联系人推送离线通知消息
	notifiedCount := 0
	for _, contact := range contacts {
		if mc.Hub.SendToUser(contact.FriendID, msgBytes) {
			notifiedCount++
		}
	}

	utils.LogDebug("📤 用户 %d (%s) 离线通知已发送，共 %d/%d 个联系人在线",
		userID, user.Username, notifiedCount, len(contacts))
}

// GetMessagesByIdsRequest 根据消息ID列表获取消息的请求
type GetMessagesByIdsRequest struct {
	MessageIDs []int `json:"message_ids" binding:"required"`
}

// formatMessageTime 格式化消息时间（只显示月-日）
func formatMessageTime(t time.Time) string {
	now := time.Now()

	// 判断是否是今天
	if t.Year() == now.Year() && t.YearDay() == now.YearDay() {
		return "今天"
	}

	// 判断是否是昨天
	yesterday := now.AddDate(0, 0, -1)
	if t.Year() == yesterday.Year() && t.YearDay() == yesterday.YearDay() {
		return "昨天"
	}

	// 其他日期，返回月-日格式
	return t.Format("01-02")
}

// formatFullMessageTime 格式化消息时间（完整的年月日和时间）
func formatFullMessageTime(t time.Time) string {
	now := time.Now()

	// 判断是否是今天
	if t.Year() == now.Year() && t.YearDay() == now.YearDay() {
		return "今天 " + t.Format("15:04:05")
	}

	// 判断是否是昨天
	yesterday := now.AddDate(0, 0, -1)
	if t.Year() == yesterday.Year() && t.YearDay() == yesterday.YearDay() {
		return "昨天 " + t.Format("15:04:05")
	}

	// 其他日期，返回完整的年月日和时间
	return t.Format("2006-01-02 15:04:05")
}

// RecentContact 最近联系人结构
type RecentContact struct {
	Type            string  `json:"type"`                 // 类型：user 或 group
	UserID          int     `json:"user_id"`              // 用户ID或群组ID
	Username        string  `json:"username"`             // 用户名
	FullName        string  `json:"full_name"`            // 全名或群组名
	Avatar          string  `json:"avatar,omitempty"`     // 用户头像URL
	LastMessageTime string  `json:"last_message_time"`    // 最后消息时间
	LastMessage     string  `json:"last_message"`         // 最后消息内容
	UnreadCount     int     `json:"unread_count"`         // 未读消息数量
	Status          string  `json:"status"`               // 用户状态：online, busy, away, offline（群组固定为online）
	GroupID         int     `json:"group_id,omitempty"`   // 群组ID（仅群组类型）
	GroupName       string  `json:"group_name,omitempty"` // 群组名称（仅群组类型）
	Remark          *string `json:"remark,omitempty"`     // 用户对群组的备注（仅群组类型）
	DoNotDisturb    bool    `json:"do_not_disturb"`       // 消息免打扰（仅群组类型）
}

// ConversationMessage 对话消息结构
type ConversationMessage struct {
	SentTime     string `json:"sent_time"`
	Content      string `json:"content"`
	SenderName   string `json:"sender_name"`
	ReceiverName string `json:"receiver_name"`
}

// sendRecallError 发送撤回错误消息
func (mc *MessageController) sendRecallError(client *ws.Client, errorMsg string) {
	response := models.WSMessage{
		Type: "recall_error",
		Data: gin.H{
			"error": errorMsg,
		},
	}
	responseBytes, _ := json.Marshal(response)
	client.SafeSend(responseBytes)
}

// sendRecallSuccess 发送撤回成功消息
func (mc *MessageController) sendRecallSuccess(client *ws.Client, messageID int) {
	response := models.WSMessage{
		Type: "recall_success",
		Data: gin.H{
			"message_id": messageID,
			"message":    "消息已撤回",
		},
	}
	responseBytes, _ := json.Marshal(response)
	client.SafeSend(responseBytes)
}
