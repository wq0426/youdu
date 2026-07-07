package websocket

import (
	"sync"
	"time"
	"telegram-server/utils"
)

// 消息处理队列配置
const (
	// 消息队列缓冲大小
	messageQueueSize = 9999
	// 消息处理worker数量
	messageWorkerCount = 64
)

// 设备类型：手机和PC各占一个连接位，同设备类型顶号、跨设备类型共存
// （PC扫码登录后手机和PC同时在线）
const (
	DeviceMobile  = "mobile"
	DeviceDesktop = "desktop"
)

// Client 表示一个WebSocket客户端连接
type Client struct {
	UserID      int
	Device      string // 设备类型：mobile / desktop，空值按 mobile 处理（兼容旧客户端）
	Conn        *Conn
	Send        chan []byte
	closed      bool       // 标记 Send channel 是否已关闭
	mu          sync.Mutex // 保护 closed 标志
	missedPings int        // 连续错过的ping消息次数
	pingMu      sync.Mutex // 保护 missedPings 计数器
	ConnectedAt time.Time  // 连接建立时间
}

// UserCallStatus 用户通话状态
type UserCallStatus struct {
	InCall       bool   // 是否在通话中
	CallType     string // 通话类型: voice/video
	TargetUserID int    // 一对一通话时的对方用户ID
	GroupID      int    // 群组通话时的群组ID
	StartTime    time.Time // 通话开始时间
}

// IncomingMessage 待处理的消息
type IncomingMessage struct {
	Client  *Client
	Message []byte
}

// Hub 维护活动的客户端连接和消息广播
//
// 🔴 高并发设计（支撑上万并发连接，注册/注销/发送互不阻塞）：
//   - 不再使用"单 goroutine + 无缓冲 channel"串行处理注册/注销/发送，
//     改为细粒度读写锁的直接方法调用（RegisterClient/UnregisterClient/SendToUser）
//   - 注册/注销只在写锁内做 map 操作（微秒级），踢旧连接等耗时操作放独立 goroutine，
//     因此大量用户同时建立连接不会阻塞已有连接的消息收发
//   - 消息发送只需读锁，多个发送方完全并行
//   - 所有对 Send channel 的写入必须走 SafeSend，禁止裸写
//     （向已关闭的 channel 写入会 panic，导致整个进程崩溃、所有连接断开）
//   - 发送缓冲满只丢弃该条消息，绝不关闭连接；连接的关闭只由三种情况触发：
//     心跳超时（CheckHeartbeat）、底层读写超时（ReadPump/WritePump）、同账号顶号
type Hub struct {
	// 已注册的客户端 (userID -> 设备类型 -> Client)
	// 🔴 同一用户手机和PC可同时在线，各设备类型只保留一个连接
	clients map[int]map[string]*Client

	// 用户通话状态 (userID -> UserCallStatus)
	callStatuses map[int]*UserCallStatus
	callStatusMu sync.RWMutex

	// 消息处理队列（带缓冲的channel，容量9999）
	MessageQueue chan *IncomingMessage

	// 消息处理回调函数
	handleMessage func(*Client, []byte)

	// 互斥锁保护clients map
	mu sync.RWMutex

	// 离线通知回调函数
	OnUserOffline func(userID int)
}

// NewHub 创建新的Hub
func NewHub() *Hub {
	return &Hub{
		clients:      make(map[int]map[string]*Client),
		callStatuses: make(map[int]*UserCallStatus),
		MessageQueue: make(chan *IncomingMessage, messageQueueSize),
	}
}

// SetMessageHandler 设置消息处理回调函数
func (h *Hub) SetMessageHandler(handler func(*Client, []byte)) {
	h.handleMessage = handler
}

// StartMessageWorkers 启动消息处理worker协程
func (h *Hub) StartMessageWorkers() {
	for i := 0; i < messageWorkerCount; i++ {
		go h.messageWorker(i)
	}
	utils.LogInfo("✅ 已启动 %d 个消息处理worker协程", messageWorkerCount)
}

// messageWorker 消息处理worker协程
func (h *Hub) messageWorker(workerID int) {
	for msg := range h.MessageQueue {
		if h.handleMessage != nil {
			h.handleMessage(msg.Client, msg.Message)
		}
	}
}

// EnqueueMessage 将消息放入处理队列
func (h *Hub) EnqueueMessage(client *Client, message []byte) {
	select {
	case h.MessageQueue <- &IncomingMessage{Client: client, Message: message}:
		// 消息成功入队
	default:
		// 队列已满，记录警告
		utils.LogDebug("⚠️ [Hub] 消息队列已满，丢弃消息 - UserID: %d", client.UserID)
	}
}

// closeSend 安全地关闭客户端的 Send channel
func (c *Client) closeSend() {
	c.mu.Lock()
	defer c.mu.Unlock()
	if !c.closed {
		close(c.Send)
		c.closed = true
	}
}

// SafeSend 安全地向客户端发送消息，如果channel已关闭则返回false
func (c *Client) SafeSend(message []byte) bool {
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.closed {
		return false
	}
	select {
	case c.Send <- message:
		return true
	default:
		return false
	}
}

// IsClosed 检查Send channel是否已关闭
func (c *Client) IsClosed() bool {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.closed
}

// ResetPingCounter 重置ping计数器（收到ping消息时调用）
func (c *Client) ResetPingCounter() {
	c.pingMu.Lock()
	defer c.pingMu.Unlock()
	c.missedPings = 0
}

// IncrementMissedPings 增加错过的ping次数
func (c *Client) IncrementMissedPings() int {
	c.pingMu.Lock()
	defer c.pingMu.Unlock()
	c.missedPings++
	return c.missedPings
}

// GetMissedPings 获取错过的ping次数
func (c *Client) GetMissedPings() int {
	c.pingMu.Lock()
	defer c.pingMu.Unlock()
	return c.missedPings
}

// RegisterClient 注册客户端连接
// 🔴 写锁内只做 map 替换（微秒级），不做任何耗时操作，
// 保证大量用户同时建立连接也不会互相阻塞、不会影响已有连接的消息收发
func (h *Hub) RegisterClient(client *Client) {
	client.ConnectedAt = time.Now()
	if client.Device == "" {
		client.Device = DeviceMobile
	}

	h.mu.Lock()
	devices := h.clients[client.UserID]
	if devices == nil {
		devices = make(map[string]*Client)
		h.clients[client.UserID] = devices
	}
	oldClient := devices[client.Device]
	devices[client.Device] = client
	totalOnline := len(h.clients)
	h.mu.Unlock()

	// 🔴 同账号同设备类型重复登录：踢旧连接的通知和延迟关闭放到独立 goroutine，
	// 不阻塞注册流程（旧实现在这里的 100ms Sleep 会卡住整个 Hub）
	// 注意：新连接已先替换进 map，forced_logout 只会发到旧连接；
	// 手机和PC属于不同设备类型，互不顶号
	if oldClient != nil {
		go func() {
			utils.LogDebug("🔄 [Hub] 用户 %d(%s) 重新连接，向旧设备发送踢下线通知", client.UserID, client.Device)
			forceLogoutMsg := []byte(`{"type":"forced_logout","data":{"reason":"您的账号已在其他设备登录"},"message":"您的账号已在其他设备登录"}`)
			if oldClient.SafeSend(forceLogoutMsg) {
				// 给旧设备一点时间处理通知
				time.Sleep(100 * time.Millisecond)
			}
			oldClient.closeSend()
			utils.LogDebug("✅ [Hub] 用户 %d(%s) 旧连接已关闭，新连接已接管", client.UserID, client.Device)
		}()
	}

	utils.LogDebug("✅ [Hub] 用户 %d(%s) 已注册 (当前在线: %d)", client.UserID, client.Device, totalOnline)
}

// UnregisterClient 注销客户端连接
// 只有当要断开的连接就是当前在线的连接时才删除，
// 避免误删同一账号已接管的新连接
func (h *Hub) UnregisterClient(client *Client) {
	h.mu.Lock()
	devices := h.clients[client.UserID]
	currentClient, ok := devices[client.Device]
	isCurrent := ok && currentClient == client
	userOffline := false
	if isCurrent {
		delete(devices, client.Device)
		if len(devices) == 0 {
			delete(h.clients, client.UserID)
			userOffline = true
		}
	}
	totalOnline := len(h.clients)
	h.mu.Unlock()

	// closeSend 幂等，确保该连接的 WritePump 退出
	client.closeSend()

	if isCurrent {
		utils.LogDebug("🔌 [Hub] 用户 %d(%s) 已断开连接 (总在线用户: %d)", client.UserID, client.Device, totalOnline)
		// 🔴 用户所有设备都下线后才触发离线回调（避免PC在线时手机断开被标记为离线）
		if userOffline && h.OnUserOffline != nil {
			go h.OnUserOffline(client.UserID)
		}
	} else {
		// 旧连接断开，但同一账号的新连接已注册（或已被其他路径移除），忽略
		utils.LogDebug("ℹ️ [Hub] 用户 %d 的旧连接断开，不影响当前连接", client.UserID)
	}
}

// IsUserOnline 检查用户是否在线
func (h *Hub) IsUserOnline(userID int) bool {
	h.mu.RLock()
	defer h.mu.RUnlock()
	// 空的设备map会在注销时一并删除，存在即在线
	return len(h.clients[userID]) > 0
}

// GetOnlineUserCount 获取在线用户数
func (h *Hub) GetOnlineUserCount() int {
	h.mu.RLock()
	defer h.mu.RUnlock()
	return len(h.clients)
}

// SendToUser 向指定用户发送消息，返回消息是否已投递到该用户的发送队列
// 🔴 只需读锁，多个发送方完全并行，不经过任何单点串行处理
// 🔴 发送缓冲满或连接正在关闭时只放弃本条消息，绝不因此关闭连接
//    （真正断开的连接会由心跳超时/底层读写超时自动清理）
func (h *Hub) SendToUser(userID int, message []byte) bool {
	h.mu.RLock()
	devices := h.clients[userID]
	clients := make([]*Client, 0, len(devices))
	for _, client := range devices {
		clients = append(clients, client)
	}
	h.mu.RUnlock()

	if len(clients) == 0 {
		utils.LogDebug("⚠️ [Hub] 用户 %d 不在线，无法发送消息", userID)
		return false
	}

	// 🔴 手机和PC可同时在线，消息投递到该用户的所有设备
	delivered := false
	for _, client := range clients {
		if client.SafeSend(message) {
			delivered = true
		} else {
			utils.LogDebug("⚠️ [Hub] 用户 %d(%s) 发送缓冲已满或连接已关闭，本条消息未投递", userID, client.Device)
		}
	}

	if delivered {
		utils.LogDebug("✅ [Hub] 消息已投递到用户 %d 的发送队列", userID)
	}
	return delivered
}

// BroadcastToChannel 向频道中的所有在线用户广播消息（排除指定用户）
func (h *Hub) BroadcastToChannel(channelName string, message []byte, excludeUserID int) {
	utils.LogDebug("📢 [Hub] 开始向频道 %s 广播消息，排除用户 %d", channelName, excludeUserID)

	// 从频道名称中解析出相关的用户ID
	// 频道名称格式: group_call_${callerId}_${timestamp}
	// 我们需要一个更好的方式来跟踪频道中的用户，这里先实现一个简化版本

	h.mu.RLock()
	var sentCount int
	for userID, devices := range h.clients {
		// 跳过排除的用户
		if userID == excludeUserID {
			continue
		}

		// 发送消息给所有其他在线用户的所有设备（简化实现）
		// 在实际应用中，应该维护频道-用户的映射关系
		// 🔴 必须走 SafeSend：裸写已关闭的 channel 会 panic 导致整个进程崩溃
		for _, client := range devices {
			if client.SafeSend(message) {
				sentCount++
				utils.LogDebug("✅ [Hub] 频道广播消息已发送给用户 %d(%s)", userID, client.Device)
			} else {
				utils.LogDebug("❌ [Hub] 向用户 %d(%s) 发送频道广播消息失败", userID, client.Device)
			}
		}
	}
	h.mu.RUnlock()

	utils.LogDebug("📢 [Hub] 频道 %s 广播完成，成功发送给 %d 个用户", channelName, sentCount)
}

// BroadcastToUsers 向指定的用户列表广播消息（排除指定用户）
func (h *Hub) BroadcastToUsers(userIDs []int, message []byte, excludeUserID int) {
	utils.LogDebug("📢 [Hub] 开始向用户列表广播消息，目标用户: %v，排除用户: %d", userIDs, excludeUserID)

	h.mu.RLock()
	var sentCount int
	for _, userID := range userIDs {
		// 跳过排除的用户
		if userID == excludeUserID {
			continue
		}

		// 检查用户是否在线（向该用户的所有设备发送）
		if devices, ok := h.clients[userID]; ok && len(devices) > 0 {
			for _, client := range devices {
				// 🔴 必须走 SafeSend：裸写已关闭的 channel 会 panic 导致整个进程崩溃
				if client.SafeSend(message) {
					sentCount++
					utils.LogDebug("✅ [Hub] 广播消息已发送给用户 %d(%s)", userID, client.Device)
				} else {
					utils.LogDebug("❌ [Hub] 向用户 %d(%s) 发送广播消息失败", userID, client.Device)
				}
			}
		} else {
			utils.LogDebug("⚠️ [Hub] 用户 %d 不在线，跳过发送", userID)
		}
	}
	h.mu.RUnlock()

	utils.LogDebug("📢 [Hub] 用户列表广播完成，成功发送给 %d 个用户", sentCount)
}

// BroadcastGroupDisbanded 广播群组解散通知（占位方法）
// 实际的通知逻辑在控制器中处理
func (h *Hub) BroadcastGroupDisbanded(groupID int) {
	utils.LogDebug("📢 [Hub] 群组 %d 已被解散", groupID)
}

// ForceLogoutUser 强制用户所有设备下线（管理员禁用等场景）
func (h *Hub) ForceLogoutUser(userID int, reason string) bool {
	kickedMobile := h.ForceLogoutDevice(userID, DeviceMobile, reason)
	kickedDesktop := h.ForceLogoutDevice(userID, DeviceDesktop, reason)
	return kickedMobile || kickedDesktop
}

// ForceLogoutDevice 强制用户指定设备类型的连接下线
// 手机端重新登录只踢旧手机、PC扫码登录只踢旧PC，另一端不受影响
func (h *Hub) ForceLogoutDevice(userID int, device string, reason string) bool {
	h.mu.RLock()
	client, ok := h.clients[userID][device]
	h.mu.RUnlock()
	if !ok {
		utils.LogDebug("⚠️ [Hub] 用户 %d(%s) 不在线，无需踢下线", userID, device)
		return false
	}

	// 构造强制下线消息
	forceLogoutMsg := []byte(`{"type":"forced_logout","data":{"reason":"` + reason + `"},"message":"` + reason + `"}`)

	// 发送踢下线通知
	if client.SafeSend(forceLogoutMsg) {
		utils.LogDebug("✅ [Hub] 已向用户 %d(%s) 发送强制下线通知: %s", userID, device, reason)
		// 给客户端一点时间处理通知
		time.Sleep(100 * time.Millisecond)
	}

	// 关闭连接（指针比对，避免误删期间新建立的连接）
	userOffline := false
	h.mu.Lock()
	if devices, exists := h.clients[userID]; exists {
		if currentClient, ok := devices[device]; ok && currentClient == client {
			delete(devices, device)
			client.closeSend()
			if len(devices) == 0 {
				delete(h.clients, userID)
				userOffline = true
			}
			utils.LogDebug("✅ [Hub] 用户 %d(%s) 已被强制下线", userID, device)
		}
	}
	h.mu.Unlock()

	// 用户所有设备都下线后才触发离线回调
	if userOffline && h.OnUserOffline != nil {
		go h.OnUserOffline(userID)
	}

	return true
}

// CheckHeartbeat 检查所有客户端的心跳状态
// 增加所有客户端的missedPings计数，如果达到2次则断开连接
// 🔴 先在读锁下递增计数并收集超时客户端（不阻塞注册和消息发送），
// 再用一次短暂写锁删除，删除时做指针比对避免误删同一账号刚建立的新连接
func (h *Hub) CheckHeartbeat() {
	h.mu.RLock()
	var disconnectedClients []*Client
	for _, devices := range h.clients {
		for _, client := range devices {
			if client.IncrementMissedPings() >= 2 {
				disconnectedClients = append(disconnectedClients, client)
			}
		}
	}
	h.mu.RUnlock()

	if len(disconnectedClients) == 0 {
		return
	}

	var offlineUserIDs []int
	h.mu.Lock()
	for _, client := range disconnectedClients {
		// 指针比对：期间该用户可能已用新连接顶替，不能误删新连接
		devices := h.clients[client.UserID]
		if current, ok := devices[client.Device]; ok && current == client {
			delete(devices, client.Device)
			// 该用户所有设备都断开时才算离线
			if len(devices) == 0 {
				delete(h.clients, client.UserID)
				offlineUserIDs = append(offlineUserIDs, client.UserID)
			}
		}
	}
	h.mu.Unlock()

	// 在锁外关闭连接并触发离线回调
	for _, client := range disconnectedClients {
		client.closeSend()
	}
	if h.OnUserOffline != nil {
		for _, userID := range offlineUserIDs {
			go h.OnUserOffline(userID)
		}
	}
}

// ========== 通话状态管理 ==========

// SetUserCallStatus 设置用户通话状态
func (h *Hub) SetUserCallStatus(userID int, inCall bool, callType string, targetUserID int, groupID int) {
	h.callStatusMu.Lock()
	defer h.callStatusMu.Unlock()

	if inCall {
		h.callStatuses[userID] = &UserCallStatus{
			InCall:       true,
			CallType:     callType,
			TargetUserID: targetUserID,
			GroupID:      groupID,
			StartTime:    time.Now(),
		}
		utils.LogDebug("📞 [Hub] 用户 %d 进入通话状态: callType=%s, targetUserID=%d, groupID=%d",
			userID, callType, targetUserID, groupID)
	} else {
		delete(h.callStatuses, userID)
		utils.LogDebug("📞 [Hub] 用户 %d 退出通话状态", userID)
	}
}

// IsUserInCall 检查用户是否在通话中
func (h *Hub) IsUserInCall(userID int) bool {
	h.callStatusMu.RLock()
	defer h.callStatusMu.RUnlock()

	status, ok := h.callStatuses[userID]
	return ok && status.InCall
}

// GetUserCallStatus 获取用户通话状态
func (h *Hub) GetUserCallStatus(userID int) *UserCallStatus {
	h.callStatusMu.RLock()
	defer h.callStatusMu.RUnlock()

	if status, ok := h.callStatuses[userID]; ok {
		// 返回副本，避免并发问题
		return &UserCallStatus{
			InCall:       status.InCall,
			CallType:     status.CallType,
			TargetUserID: status.TargetUserID,
			GroupID:      status.GroupID,
			StartTime:    status.StartTime,
		}
	}
	return nil
}

// ClearUserCallStatus 清除用户通话状态（用户离线时调用）
func (h *Hub) ClearUserCallStatus(userID int) {
	h.callStatusMu.Lock()
	defer h.callStatusMu.Unlock()

	if _, ok := h.callStatuses[userID]; ok {
		delete(h.callStatuses, userID)
		utils.LogDebug("📞 [Hub] 用户 %d 离线，已清除通话状态", userID)
	}
}
