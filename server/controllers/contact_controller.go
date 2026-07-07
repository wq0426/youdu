package controllers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"time"

	"telegram-server/db"
	"telegram-server/models"
	"telegram-server/services"
	"telegram-server/utils"
	ws "telegram-server/websocket"

	"github.com/gin-gonic/gin"
)

// ContactController 联系人控制器
type ContactController struct {
	contactRepo *models.ContactRepository
	userRepo    *models.UserRepository
	hub         *ws.Hub
}

// NewContactController 创建联系人控制器
func NewContactController(hub *ws.Hub) *ContactController {
	return &ContactController{
		contactRepo: models.NewContactRepository(db.DB),
		userRepo:    models.NewUserRepository(db.DB),
		hub:         hub,
	}
}

// AddContact 添加联系人
func (ctrl *ContactController) AddContact(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	var req models.AddContactRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "请求参数错误: "+err.Error())
		return
	}

	// 查找好友用户是否存在
	friend, err := ctrl.userRepo.FindByUsername(req.FriendUsername)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "该用户不存在")
			return
		}
		utils.LogDebug("查询好友用户失败: %v", err)
		utils.InternalServerError(c, "查询好友用户失败")
		return
	}

	// 检查是否添加自己为好友
	if friend.ID == userID.(int) {
		utils.BadRequest(c, "不能添加自己为联系人")
		return
	}

	// 新策略：添加联系人不再需要对方审核，直接建立联系人关系
	ctrl.directAddContact(c, userID.(int), friend)
}

// GetContacts 获取用户的所有联系人
func (ctrl *ContactController) GetContacts(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取联系人列表
	contacts, err := ctrl.contactRepo.GetContactsByUserID(userID.(int))
	if err != nil {
		utils.LogDebug("获取联系人列表失败: %v", err)
		utils.InternalServerError(c, "获取联系人列表失败")
		return
	}

	// 如果没有联系人，返回空数组而不是null
	if contacts == nil {
		contacts = []models.ContactInfo{}
	}

	utils.Success(c, gin.H{
		"contacts": contacts,
		"total":    len(contacts),
	})
}

// GetPendingContactRequests 获取待审核的联系人申请
func (ctrl *ContactController) GetPendingContactRequests(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取待审核的联系人申请列表
	requests, err := ctrl.contactRepo.GetPendingContactRequests(userID.(int))
	if err != nil {
		utils.LogDebug("获取联系人申请列表失败: %v", err)
		utils.InternalServerError(c, "获取联系人申请列表失败")
		return
	}

	// 如果没有申请，返回空数组而不是null
	if requests == nil {
		requests = []models.ContactInfo{}
	}

	utils.Success(c, gin.H{
		"requests": requests,
		"total":    len(requests),
	})
}

// DeleteContact 删除联系人
func (ctrl *ContactController) DeleteContact(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取要删除的好友用户名
	friendUsername := c.Param("username")
	if friendUsername == "" {
		utils.BadRequest(c, "好友用户名不能为空")
		return
	}

	// 查找好友用户
	friend, err := ctrl.userRepo.FindByUsername(friendUsername)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "该用户不存在")
			return
		}
		utils.LogDebug("查询好友用户失败: %v", err)
		utils.InternalServerError(c, "查询好友用户失败")
		return
	}

	// 删除联系人关系
	err = ctrl.contactRepo.DeleteContact(userID.(int), friend.ID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "该联系人不存在")
			return
		}
		utils.LogDebug("删除联系人失败: %v", err)
		utils.InternalServerError(c, "删除联系人失败")
		return
	}

	utils.SuccessWithMessage(c, "删除联系人成功", nil)
}

// SearchContacts 根据关键字搜索联系人
func (ctrl *ContactController) SearchContacts(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取搜索关键字
	keyword := c.Query("keyword")
	if keyword == "" {
		utils.BadRequest(c, "搜索关键字不能为空")
		return
	}

	// 搜索联系人
	results, err := ctrl.contactRepo.SearchContacts(userID.(int), keyword)
	if err != nil {
		utils.LogDebug("搜索联系人失败: %v", err)
		utils.InternalServerError(c, "搜索联系人失败")
		return
	}

	// 如果没有结果，返回空数组而不是null
	if results == nil {
		results = []models.SearchContactResult{}
	}

	utils.Success(c, gin.H{
		"contacts": results,
		"total":    len(results),
	})
}

// GetContactsByUserIDParam 根据user_id参数获取指定用户的联系人列表
func (ctrl *ContactController) GetContactsByUserIDParam(c *gin.Context) {
	// 获取URL参数中的用户ID
	userIDParam := c.Param("user_id")
	if userIDParam == "" {
		utils.BadRequest(c, "用户ID不能为空")
		return
	}

	// 将字符串ID转换为整数
	var userID int
	if _, err := fmt.Sscanf(userIDParam, "%d", &userID); err != nil {
		utils.BadRequest(c, "无效的用户ID")
		return
	}

	// 验证用户是否存在
	_, err := ctrl.userRepo.FindByID(userID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "用户不存在")
			return
		}
		utils.LogDebug("查询用户失败: %v", err)
		utils.InternalServerError(c, "查询用户失败")
		return
	}

	// 获取该用户的联系人列表
	contacts, err := ctrl.contactRepo.GetContactsByUserID(userID)
	if err != nil {
		utils.LogDebug("获取联系人列表失败: %v", err)
		utils.InternalServerError(c, "获取联系人列表失败")
		return
	}

	// 如果没有联系人，返回空数组而不是null
	if contacts == nil {
		contacts = []models.ContactInfo{}
	}

	utils.Success(c, gin.H{
		"user_id":  userID,
		"contacts": contacts,
		"total":    len(contacts),
	})
}

// UpdateContactApprovalStatus 更新联系人审核状态
func (ctrl *ContactController) UpdateContactApprovalStatus(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	currentUserID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取关系ID
	relationIDParam := c.Param("relation_id")
	if relationIDParam == "" {
		utils.BadRequest(c, "关系ID不能为空")
		return
	}

	// 将字符串ID转换为整数
	var relationID int
	if _, err := fmt.Sscanf(relationIDParam, "%d", &relationID); err != nil {
		utils.BadRequest(c, "无效的关系ID")
		return
	}

	// 获取请求体中的审核状态
	var req struct {
		ApprovalStatus string `json:"approval_status" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "请求参数错误: "+err.Error())
		return
	}

	// 验证审核状态的合法性
	if req.ApprovalStatus != "approved" && req.ApprovalStatus != "rejected" {
		utils.BadRequest(c, "无效的审核状态，只能是 approved 或 rejected")
		return
	}

	// 获取关系信息
	relation, err := ctrl.contactRepo.GetRelationByID(relationID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "联系人关系不存在")
			return
		}
		utils.LogDebug("获取关系信息失败: %v", err)
		utils.InternalServerError(c, "获取关系信息失败")
		return
	}

	// 更新审核状态
	err = ctrl.contactRepo.UpdateApprovalStatus(relationID, req.ApprovalStatus)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "联系人关系不存在")
			return
		}
		utils.LogDebug("更新审核状态失败: %v", err)
		utils.InternalServerError(c, "更新审核状态失败")
		return
	}

	message := "已通过审核"
	if req.ApprovalStatus == "rejected" {
		message = "已拒绝申请"
	}

	// 获取当前用户（接收方/审核人）的信息
	currentUser, err := ctrl.userRepo.FindByID(currentUserID.(int))
	if err != nil {
		utils.LogDebug("❌ 获取当前用户信息失败: %v", err)
	} else {
		utils.LogDebug("当前用户信息: ID=%d, Username=%s", currentUser.ID, currentUser.Username)
	}

	// 获取发起人信息
	initiator, err := ctrl.userRepo.FindByID(relation.UserID)
	if err != nil {
		utils.LogDebug("❌ 获取发起人信息失败: %v", err)
		utils.InternalServerError(c, "获取发起人信息失败")
		return
	}

	utils.LogDebug("🔍 [联系人审核] 详细信息:")
	utils.LogDebug("  - 关系ID: %d", relationID)
	utils.LogDebug("  - 发起人ID: %d (relation.UserID)", relation.UserID)
	utils.LogDebug("  - 接收人ID: %d (relation.FriendID)", relation.FriendID)
	utils.LogDebug("  - 当前审核人ID: %d (currentUserID)", currentUserID.(int))
	utils.LogDebug("  - 发起人信息: ID=%d, Username=%s", initiator.ID, initiator.Username)
	utils.LogDebug("  - 审核人信息: ID=%d, Username=%s", currentUser.ID, currentUser.Username)
	utils.LogDebug("  - 审核状态: %s", req.ApprovalStatus)

	// 根据审核状态发送不同的消息
	if req.ApprovalStatus == "approved" {
		utils.LogDebug("审核通过，准备发送通知消息")
		utils.LogDebug("关系信息: relationID=%d, userID=%d, friendID=%d", relationID, relation.UserID, relation.FriendID)
		utils.LogDebug("当前用户ID（审核人）: %d", currentUserID.(int))
		utils.LogDebug("当前用户信息: ID=%d, Username=%s", currentUser.ID, currentUser.Username)

		// 🔵 顺序很重要：先以「发起人」身份代发「发起添加好友申请」，再以「审核人」身份回「请求添加好友【已通过】」。
		// 两条消息在同一会话里按时间戳排序，先发的时间戳更早；这样双方会话显示顺序才符合逻辑：
		// 「发起添加好友申请」在前、「请求添加好友【已通过】」在后。
		// （此条同时确保审核人的会话列表中也能显示新好友，并代表发起人当初的"申请"动作）
		ctrl.sendApprovalMessageToSelf(currentUserID.(int), currentUser, initiator, "approved")

		// 向发起人发送【已通过】消息
		ctrl.sendApprovalMessage(relation.UserID, currentUser, initiator, "approved")

		// 向双方发送联系人状态变更通知，触发APP端更新通讯录缓存
		ctrl.sendContactStatusChangeNotification(relation.UserID, currentUserID.(int), "approved", initiator, currentUser, false)
	} else if req.ApprovalStatus == "rejected" {
		utils.LogDebug("审核拒绝，准备发送拒绝消息")
		utils.LogDebug("关系信息: relationID=%d, userID=%d, friendID=%d", relationID, relation.UserID, relation.FriendID)
		utils.LogDebug("当前用户ID（审核人）: %d", currentUserID.(int))

		// 向发起人发送【已拒绝】消息
		ctrl.sendApprovalMessage(relation.UserID, currentUser, initiator, "rejected")

		// 向双方发送联系人状态变更通知，触发APP端更新通讯录缓存
		ctrl.sendContactStatusChangeNotification(relation.UserID, currentUserID.(int), "rejected", initiator, currentUser, false)
	}

	utils.SuccessWithMessage(c, message, nil)
}

// sendApprovalMessage 向发起人发送审核消息（通过或驳回）
func (ctrl *ContactController) sendApprovalMessage(initiatorID int, approver *models.User, initiator *models.User, approvalStatus string) {
	// 根据审核状态构造系统消息
	var systemMessage string
	if approvalStatus == "approved" {
		systemMessage = "请求添加好友【已通过】"
	} else if approvalStatus == "rejected" {
		systemMessage = "请求添加好友【已驳回】"
	} else {
		utils.LogDebug("❌ 未知的审核状态: %s", approvalStatus)
		return
	}

	utils.LogDebug("准备向发起人发送审核消息: 发起人ID=%d, 审核人=%s, 状态=%s", initiatorID, approver.Username, approvalStatus)

	// 迁移到 Agora Chat：不再写入 messages 表，改为以审核人身份通过 Agora Chat REST 向发起人代发文本消息。
	// 代发的消息持久化进 Agora 会话并支持离线投递，双方客户端均通过 onMessagesReceived 收到并刷新会话列表。
	// 优先使用 full_name，如果为空则使用 username
	approverName := approver.Username
	if approver.FullName != nil && *approver.FullName != "" {
		approverName = *approver.FullName
	}

	initiatorName := initiator.Username
	if initiator.FullName != nil && *initiator.FullName != "" {
		initiatorName = *initiator.FullName
	}

	ext := map[string]interface{}{
		"sender_name":     approverName,
		"sender_avatar":   approver.Avatar,
		"receiver_name":   initiatorName,
		"receiver_avatar": initiator.Avatar,
		"message_type":    "text",
	}

	if err := services.AgoraChatGroup.SendUserText(approver.ID, initiatorID, systemMessage, ext); err != nil {
		utils.LogDebug("❌ 代发审核消息(Agora)失败: %v", err)
		return
	}
	utils.LogDebug("✅ 已向发起人 %d 代发审核消息(Agora): %s", initiatorID, systemMessage)
}

// sendApprovalMessageToSelf 向审核人自己发送审核消息（显示在自己的最近联系人列表中）
func (ctrl *ContactController) sendApprovalMessageToSelf(approverID int, approver *models.User, initiator *models.User, approvalStatus string) {
	// 根据审核状态构造系统消息
	// 注意：本条消息以「发起人」身份代发给审核人，代表发起人当初的申请动作，
	// 因此文案为「发起添加好友申请」；审核人收到/通过后由 sendApprovalMessage
	// 以审核人身份回复「请求添加好友【已通过】」。两条文案需区分，避免双方都显示「已通过」。
	var systemMessage string
	if approvalStatus == "approved" {
		systemMessage = "发起添加好友申请"
	} else {
		utils.LogDebug("❌ 仅通过状态才向审核人自己发送消息")
		return
	}

	utils.LogDebug("准备向审核人自己发送审核消息: 审核人ID=%d, 发起人=%s", approverID, initiator.Username)

	// 迁移到 Agora Chat：不再写入 messages 表，改为以发起人身份通过 Agora Chat REST 向审核人代发文本消息，
	// 使审核人的会话列表也能出现与新好友（发起人）的会话。
	// 优先使用 full_name，如果为空则使用 username
	initiatorName := initiator.Username
	if initiator.FullName != nil && *initiator.FullName != "" {
		initiatorName = *initiator.FullName
	}

	approverName := approver.Username
	if approver.FullName != nil && *approver.FullName != "" {
		approverName = *approver.FullName
	}

	ext := map[string]interface{}{
		"sender_name":     initiatorName,
		"sender_avatar":   initiator.Avatar,
		"receiver_name":   approverName,
		"receiver_avatar": approver.Avatar,
		"message_type":    "text",
	}

	if err := services.AgoraChatGroup.SendUserText(initiator.ID, approverID, systemMessage, ext); err != nil {
		utils.LogDebug("❌ 代发审核人自己的消息(Agora)失败: %v", err)
		return
	}
	utils.LogDebug("✅ 已向审核人自己 %d 代发审核消息(Agora): %s", approverID, systemMessage)
}

// sendContactRequestNotification 向接收方发送联系人请求通知
func (ctrl *ContactController) sendContactRequestNotification(receiver *models.User, initiator *models.User, relationID int) {
	// 🔴 使用 UTC 时间，因为数据库字段是 timestamp without time zone
	currentTime := time.Now().UTC()

	// 优先使用 full_name，如果为空则使用 username
	senderName := initiator.Username
	if initiator.FullName != nil && *initiator.FullName != "" {
		senderName = *initiator.FullName
	}

	// 注释掉：不再将"待审核"消息保存到messages表，避免在最近联系人列表中显示
	// 只通过 contact_request 类型的通知来提醒用户，不在聊天记录中留痕

	// 构造联系人请求通知（用于刷新待审核角标、弹出提醒等）
	notification := models.WSMessage{
		Type:       "contact_request",
		ReceiverID: receiver.ID,
		Data: gin.H{
			"relation_id":   relationID,
			"sender_id":     initiator.ID,
			"sender_name":   senderName,
			"sender_avatar": initiator.Avatar,
			"full_name":     initiator.FullName,
			"created_at":    currentTime.Format(time.RFC3339),
		},
	}

	notificationJSON, err := json.Marshal(notification)
	if err != nil {
		utils.LogDebug("序列化联系人请求通知失败: %v", err)
		return
	}

	if ctrl.hub != nil {
		utils.LogDebug("🔍 [联系人请求] 准备发送通知给用户 %d", receiver.ID)
		utils.LogDebug("🔍 [联系人请求] 通知内容: %s", string(notificationJSON))

		success := ctrl.hub.SendToUser(receiver.ID, notificationJSON)
		if success {
			utils.LogDebug("✅ [联系人请求] 已成功向接收方 %d 发送联系人请求通知", receiver.ID)
		} else {
			utils.LogDebug("❌ [联系人请求] 接收方 %d 离线或连接异常，通知发送失败", receiver.ID)
		}
	} else {
		utils.LogDebug("❌ [联系人请求] WebSocket Hub未初始化，无法发送通知")
	}
}

// BlockContact 拉黑联系人
func (ctrl *ContactController) BlockContact(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取要拉黑的好友ID
	friendIDParam := c.Param("friend_id")
	if friendIDParam == "" {
		utils.BadRequest(c, "好友ID不能为空")
		return
	}

	// 将字符串ID转换为整数
	var friendID int
	if _, err := fmt.Sscanf(friendIDParam, "%d", &friendID); err != nil {
		utils.BadRequest(c, "无效的好友ID")
		return
	}

	// 检查是否拉黑自己
	if friendID == userID.(int) {
		utils.BadRequest(c, "不能拉黑自己")
		return
	}

	// 检查联系人关系是否存在
	exists, err := ctrl.contactRepo.CheckRelationExists(userID.(int), friendID)
	if err != nil {
		utils.LogDebug("检查联系人关系失败: %v", err)
		utils.InternalServerError(c, "检查联系人关系失败")
		return
	}

	if !exists {
		utils.NotFound(c, "该联系人不存在")
		return
	}

	// 拉黑联系人
	err = ctrl.contactRepo.BlockContact(userID.(int), friendID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "该联系人不存在")
			return
		}
		utils.LogDebug("拉黑联系人失败: %v", err)
		utils.InternalServerError(c, "拉黑联系人失败")
		return
	}

	// 获取操作者和被操作者的用户信息
	operator, err := ctrl.userRepo.FindByID(userID.(int))
	if err != nil {
		utils.LogDebug("获取操作者信息失败: %v", err)
	}

	blockedUser, err := ctrl.userRepo.FindByID(friendID)
	if err != nil {
		utils.LogDebug("获取被拉黑用户信息失败: %v", err)
	}

	// 向被拉黑的用户推送通知
	if operator != nil && blockedUser != nil {
		ctrl.sendContactBlockNotification(friendID, operator, "blocked")
	}

	utils.SuccessWithMessage(c, "拉黑联系人成功", nil)
}

// UnblockContact 恢复联系人（取消拉黑）
func (ctrl *ContactController) UnblockContact(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取要恢复的好友ID
	friendIDParam := c.Param("friend_id")
	if friendIDParam == "" {
		utils.BadRequest(c, "好友ID不能为空")
		return
	}

	// 将字符串ID转换为整数
	var friendID int
	if _, err := fmt.Sscanf(friendIDParam, "%d", &friendID); err != nil {
		utils.BadRequest(c, "无效的好友ID")
		return
	}

	// 检查联系人关系是否存在
	exists, err := ctrl.contactRepo.CheckRelationExists(userID.(int), friendID)
	if err != nil {
		utils.LogDebug("检查联系人关系失败: %v", err)
		utils.InternalServerError(c, "检查联系人关系失败")
		return
	}

	if !exists {
		utils.NotFound(c, "该联系人不存在")
		return
	}

	// 恢复联系人
	err = ctrl.contactRepo.UnblockContact(userID.(int), friendID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "该联系人不存在")
			return
		}
		utils.LogDebug("恢复联系人失败: %v", err)
		utils.InternalServerError(c, "恢复联系人失败")
		return
	}

	// 🔔 获取操作者信息，用于发送通知
	operator, err := ctrl.userRepo.FindByID(userID.(int))
	if err != nil {
		utils.LogDebug("⚠️ 获取操作者信息失败: %v，跳过通知发送", err)
	} else {
		// 向被恢复的用户发送WebSocket通知
		ctrl.sendContactBlockNotification(friendID, operator, "unblocked")
	}

	utils.SuccessWithMessage(c, "恢复联系人成功", nil)
}

// DeleteContactById 删除联系人（硬删除双向记录）
func (ctrl *ContactController) DeleteContactById(c *gin.Context) {
	// 从上下文中获取用户ID（需要认证中间件）
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	// 获取要删除的好友ID
	friendIDParam := c.Param("friend_id")
	if friendIDParam == "" {
		utils.BadRequest(c, "好友ID不能为空")
		return
	}

	// 将字符串ID转换为整数
	var friendID int
	if _, err := fmt.Sscanf(friendIDParam, "%d", &friendID); err != nil {
		utils.BadRequest(c, "无效的好友ID")
		return
	}

	// 检查是否删除自己
	if friendID == userID.(int) {
		utils.BadRequest(c, "不能删除自己")
		return
	}

	// 检查联系人关系是否存在
	exists, err := ctrl.contactRepo.CheckRelationExists(userID.(int), friendID)
	if err != nil {
		utils.LogDebug("检查联系人关系失败: %v", err)
		utils.InternalServerError(c, "检查联系人关系失败")
		return
	}

	if !exists {
		utils.NotFound(c, "该联系人不存在")
		return
	}

	// 获取操作者和被操作者的用户信息（在删除前获取）
	operator, err := ctrl.userRepo.FindByID(userID.(int))
	if err != nil {
		utils.LogDebug("获取操作者信息失败: %v", err)
	}

	deletedUser, err := ctrl.userRepo.FindByID(friendID)
	if err != nil {
		utils.LogDebug("获取被删除用户信息失败: %v", err)
	}

	// 硬删除联系人（删除双向的user_relations记录）
	utils.LogDebug("🗑️ 硬删除联系人关系: user_id=%d <-> friend_id=%d", userID.(int), friendID)
	err = ctrl.contactRepo.DeleteContactById(userID.(int), friendID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "该联系人不存在")
			return
		}
		utils.LogDebug("删除联系人失败: %v", err)
		utils.InternalServerError(c, "删除联系人失败")
		return
	}

	// 向被删除的用户推送通知
	if operator != nil && deletedUser != nil {
		ctrl.sendContactBlockNotification(friendID, operator, "deleted")
	}

	utils.LogDebug("✅ 成功硬删除联系人关系: user_id=%d <-> friend_id=%d", userID.(int), friendID)
	utils.SuccessWithMessage(c, "删除联系人成功", nil)
}

// sendContactStatusChangeNotification 向双方发送联系人状态变更通知（触发APP端更新通讯录缓存）
func (ctrl *ContactController) sendContactStatusChangeNotification(initiatorID int, approverID int, status string, initiator *models.User, approver *models.User, direct bool) {
	utils.LogDebug("🔔 准备发送联系人状态变更通知 - 发起人ID: %d, 审核人ID: %d, 状态: %s", initiatorID, approverID, status)

	// 获取发起人和审核人的显示名称
	var initiatorName string
	if initiator.FullName != nil && *initiator.FullName != "" {
		initiatorName = *initiator.FullName
	} else {
		initiatorName = initiator.Username
	}

	var approverName string
	if approver.FullName != nil && *approver.FullName != "" {
		approverName = *approver.FullName
	} else {
		approverName = approver.Username
	}

	// 构造状态变更通知
	notification := models.WSMessage{
		Type:       "contact_status_changed",
		ReceiverID: 0, // 会分别发送给两个用户
		Data: gin.H{
			"initiator_id":   initiatorID,
			"approver_id":    approverID,
			"initiator_name": initiatorName,
			"approver_name":  approverName,
			"status":         status,
			"direct":         direct, // true=免审批直加（全平台搜索一键添加），客户端据此展示不同文案
			"timestamp":      time.Now().Unix(),
		},
	}

	notificationJSON, err := json.Marshal(notification)
	if err != nil {
		utils.LogDebug("❌ 序列化联系人状态变更通知失败: %v", err)
		return
	}

	if ctrl.hub != nil {
		// 向发起人发送通知
		ctrl.hub.SendToUser(initiatorID, notificationJSON)
		utils.LogDebug("✅ 已向发起人 %d 发送联系人状态变更通知", initiatorID)

		// 向审核人发送通知
		ctrl.hub.SendToUser(approverID, notificationJSON)
		utils.LogDebug("✅ 已向审核人 %d 发送联系人状态变更通知", approverID)
	} else {
		utils.LogDebug("❌ WebSocket Hub未初始化，无法发送通知")
	}
}

// sendContactBlockNotification 向被拉黑/删除的用户发送通知
func (ctrl *ContactController) sendContactBlockNotification(targetUserID int, operator *models.User, action string) {
	utils.LogDebug("🚫 准备发送联系人操作通知 - 目标用户ID: %d, 操作者: %s, 操作: %s", targetUserID, operator.Username, action)

	// 获取操作者的显示名称
	var operatorName string
	if operator.FullName != nil && *operator.FullName != "" {
		operatorName = *operator.FullName
	} else {
		operatorName = operator.Username
	}

	// 根据操作类型构造不同的消息
	var messageType string
	var messageContent string
	switch action {
	case "blocked":
		messageType = "contact_blocked"
		messageContent = fmt.Sprintf("您已被 %s 拉黑", operatorName)
	case "deleted":
		messageType = "contact_deleted"
		messageContent = fmt.Sprintf("您已被 %s 删除", operatorName)
	case "unblocked":
		messageType = "contact_unblocked"
		messageContent = fmt.Sprintf("%s 已恢复您为联系人", operatorName)
	default:
		utils.LogDebug("❌ 未知的操作类型: %s", action)
		return
	}

	// 构造通知消息
	notification := models.WSMessage{
		Type:       messageType,
		ReceiverID: targetUserID,
		Data: gin.H{
			"operator_id":   operator.ID,
			"operator_name": operatorName,
			"action":        action,
			"message":       messageContent,
			"timestamp":     time.Now().Unix(),
		},
	}

	notificationJSON, err := json.Marshal(notification)
	if err != nil {
		utils.LogDebug("❌ 序列化联系人操作通知失败: %v", err)
		return
	}

	if ctrl.hub != nil {
		success := ctrl.hub.SendToUser(targetUserID, notificationJSON)
		if success {
			utils.LogDebug("✅ 已向用户 %d 发送联系人操作通知: %s", targetUserID, messageContent)
		} else {
			utils.LogDebug("❌ 用户 %d 离线或连接异常，通知发送失败", targetUserID)
		}
	} else {
		utils.LogDebug("❌ WebSocket Hub未初始化，无法发送通知")
	}
}

// AddContactDirectRequest 直接添加联系人请求（免审批）
type AddContactDirectRequest struct {
	FriendID int `json:"friend_id" binding:"required"`
}

// AddContactDirect 直接添加联系人（免审批）
// POST /api/contacts/direct
// 用于"全平台搜索用户后直接聊天/一键添加联系人"场景：不走 pending 审批流，
// 直接建立（或恢复/升级为）approved 的双向好友关系，并通过 WebSocket 通知双方刷新通讯录。
func (ctrl *ContactController) AddContactDirect(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	var req AddContactDirectRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "请求参数错误: "+err.Error())
		return
	}

	if req.FriendID == userID.(int) {
		utils.BadRequest(c, "不能添加自己为联系人")
		return
	}

	// 查找对方用户是否存在
	friend, err := ctrl.userRepo.FindByID(req.FriendID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.NotFound(c, "该用户不存在")
			return
		}
		utils.LogDebug("查询用户失败: %v", err)
		utils.InternalServerError(c, "查询用户失败")
		return
	}

	ctrl.directAddContact(c, userID.(int), friend)
}

// directAddContact 免审批直接建立联系人关系（新策略：所有添加入口都不需要对方审核）
// 处理已有关系的各种状态，最终置为 approved，并通过 WebSocket 通知双方刷新通讯录
func (ctrl *ContactController) directAddContact(c *gin.Context, userID int, friend *models.User) {
	// 获取现有关系
	existingRelation, err := ctrl.contactRepo.GetRelationByUsers(userID, friend.ID)
	if err != nil {
		utils.LogDebug("检查联系人关系失败: %v", err)
		utils.InternalServerError(c, "检查联系人关系失败")
		return
	}

	var relation *models.UserRelation

	if existingRelation != nil {
		// 单向可见:关系对"我"可见 = 我是发起方,或我是被加方且已回加(friend_added)
		iAmInitiator := existingRelation.UserID == userID
		visibleToMe := !existingRelation.IsDeleted &&
			existingRelation.ApprovalStatus == "approved" &&
			(iAmInitiator || existingRelation.FriendAdded)
		if visibleToMe {
			c.JSON(200, gin.H{
				"code":    3,
				"message": "该用户已在您的联系人列表中",
				"data":    nil,
			})
			return
		}

		if existingRelation.IsDeleted {
			// 恢复已删除的关系并直接置为 approved
			err = ctrl.contactRepo.RestoreRelationApproved(existingRelation.ID)
		} else if existingRelation.ApprovalStatus != "approved" {
			// pending / rejected 的旧关系直接升级为 approved
			err = ctrl.contactRepo.UpdateRelationStatus(existingRelation.ID, "approved")
		}
		if err != nil {
			utils.LogDebug("更新联系人关系失败: %v", err)
			utils.InternalServerError(c, "添加联系人失败")
			return
		}
		// 我是被加方在"回加":置 friend_added,此后关系对双方可见
		if !iAmInitiator && !existingRelation.FriendAdded {
			if err = ctrl.contactRepo.SetFriendAdded(existingRelation.ID); err != nil {
				utils.LogDebug("标记回加(friend_added)失败: %v", err)
				utils.InternalServerError(c, "添加联系人失败")
				return
			}
			existingRelation.FriendAdded = true
		}
		relation = existingRelation
		relation.ApprovalStatus = "approved"
		relation.IsDeleted = false
	} else {
		relation, err = ctrl.contactRepo.AddContactApproved(userID, friend.ID)
		if err != nil {
			utils.LogDebug("直接添加联系人失败: %v", err)
			utils.InternalServerError(c, "添加联系人失败")
			return
		}
	}

	utils.LogDebug("✅ 直接添加联系人成功（免审批）: %d -> %d, relation_id=%d", userID, friend.ID, relation.ID)

	// 向双方发送联系人状态变更通知，触发客户端刷新通讯录
	initiator, err := ctrl.userRepo.FindByID(userID)
	if err != nil {
		utils.LogDebug("获取发起人信息失败: %v", err)
	} else {
		ctrl.sendContactStatusChangeNotification(userID, friend.ID, "approved", initiator, friend, true)
	}

	c.JSON(200, gin.H{
		"code":    0,
		"message": "已添加为联系人",
		"data": gin.H{
			"relation": relation,
			"friend": gin.H{
				"id":             friend.ID,
				"username":       friend.Username,
				"full_name":      friend.FullName,
				"avatar":         friend.Avatar,
				"work_signature": friend.WorkSignature,
				"status":         friend.Status,
			},
		},
	})
}

// GetContactRelation 查询当前用户与指定用户的联系人关系状态
// GET /api/contacts/relation/:friend_id
// 返回 is_friend / approval_status，用于聊天页判断是否显示"添加为联系人"入口
func (ctrl *ContactController) GetContactRelation(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}

	friendIDParam := c.Param("friend_id")
	var friendID int
	if _, err := fmt.Sscanf(friendIDParam, "%d", &friendID); err != nil {
		utils.BadRequest(c, "无效的用户ID")
		return
	}

	relation, err := ctrl.contactRepo.GetRelationByUsers(userID.(int), friendID)
	if err != nil {
		utils.LogDebug("查询联系人关系失败: %v", err)
		utils.InternalServerError(c, "查询联系人关系失败")
		return
	}

	if relation == nil || relation.IsDeleted {
		utils.Success(c, gin.H{
			"is_friend":       false,
			"approval_status": "",
		})
		return
	}

	// 单向可见:对方加了我但我未回加时,对我而言不算联系人
	// （聊天页据此继续显示"添加为联系人"入口，让我可以回加）
	isFriend := relation.ApprovalStatus == "approved" &&
		(relation.UserID == userID.(int) || relation.FriendAdded)
	utils.Success(c, gin.H{
		"is_friend":       isFriend,
		"approval_status": relation.ApprovalStatus,
	})
}
