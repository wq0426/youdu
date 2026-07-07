package controllers

import (
	"crypto/rand"
	"database/sql"
	"encoding/hex"
	"sync"
	"time"

	"telegram-server/db"
	"telegram-server/models"
	"telegram-server/utils"
	ws "telegram-server/websocket"

	"github.com/gin-gonic/gin"
)

// PC端扫码登录流程（微信模式，手机与PC同时在线）：
//  1. PC 登录页调用 create 创建二维码会话，展示二维码（内容 youdu://qrlogin/{qr_id}）
//  2. PC 每 2 秒轮询 status
//  3. 手机扫一扫识别后调用 scan（带手机token），PC 显示"已扫描，请在手机上确认"
//  4. 手机点"确认登录"调用 confirm，服务端为该用户签发 desktop token
//  5. PC 轮询到 confirmed 拿到 token+user 完成登录；手机的 active_token 不受影响
const (
	qrStatusPending   = "pending"   // 等待扫描
	qrStatusScanned   = "scanned"   // 已扫描，等待手机确认
	qrStatusConfirmed = "confirmed" // 已确认，token已签发
	qrStatusCancelled = "cancelled" // 手机取消登录

	qrSessionTTL = 2 * time.Minute // 二维码有效期，过期后PC需刷新重新生成
)

// qrLoginSession 二维码登录会话（内存存储，无需落库）
type qrLoginSession struct {
	Status    string
	UserID    int          // 扫码用户ID（scanned 之后有值）
	User      *models.User // 确认后返回给PC的用户信息
	Token     string       // 确认后签发的 desktop token
	ExpiresAt time.Time
}

// QRLoginController PC端扫码登录控制器
type QRLoginController struct {
	userRepo *models.UserRepository
	hub      *ws.Hub

	mu       sync.Mutex
	sessions map[string]*qrLoginSession
}

// NewQRLoginController 创建扫码登录控制器
func NewQRLoginController(hub *ws.Hub) *QRLoginController {
	ctrl := &QRLoginController{
		userRepo: models.NewUserRepository(db.DB),
		hub:      hub,
		sessions: make(map[string]*qrLoginSession),
	}
	// 定期清理过期会话，防止内存泄漏
	go ctrl.cleanupLoop()
	return ctrl
}

func (ctrl *QRLoginController) cleanupLoop() {
	ticker := time.NewTicker(time.Minute)
	defer ticker.Stop()
	for range ticker.C {
		now := time.Now()
		ctrl.mu.Lock()
		for id, s := range ctrl.sessions {
			if now.After(s.ExpiresAt) {
				delete(ctrl.sessions, id)
			}
		}
		ctrl.mu.Unlock()
	}
}

// getSession 取会话；过期视为不存在
func (ctrl *QRLoginController) getSession(qrID string) *qrLoginSession {
	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	s, ok := ctrl.sessions[qrID]
	if !ok || time.Now().After(s.ExpiresAt) {
		return nil
	}
	return s
}

// Create 创建二维码登录会话（PC端匿名调用）
func (ctrl *QRLoginController) Create(c *gin.Context) {
	buf := make([]byte, 16)
	if _, err := rand.Read(buf); err != nil {
		utils.InternalServerError(c, "服务器错误")
		return
	}
	qrID := hex.EncodeToString(buf)

	ctrl.mu.Lock()
	ctrl.sessions[qrID] = &qrLoginSession{
		Status:    qrStatusPending,
		ExpiresAt: time.Now().Add(qrSessionTTL),
	}
	ctrl.mu.Unlock()

	utils.Success(c, gin.H{
		"qr_id":      qrID,
		"expires_in": int(qrSessionTTL.Seconds()),
	})
}

// Status 查询二维码会话状态（PC端匿名轮询）
func (ctrl *QRLoginController) Status(c *gin.Context) {
	qrID := c.Query("qr_id")
	if qrID == "" {
		utils.BadRequest(c, "缺少qr_id参数")
		return
	}

	s := ctrl.getSession(qrID)
	if s == nil {
		utils.Success(c, gin.H{"status": "expired"})
		return
	}

	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	switch s.Status {
	case qrStatusScanned:
		// 返回扫码用户的基础信息，供PC展示"xxx 已扫描"
		nickname := ""
		avatar := ""
		if s.User != nil {
			nickname = s.User.Username
			if s.User.FullName != nil && *s.User.FullName != "" {
				nickname = *s.User.FullName
			}
			avatar = s.User.Avatar
		}
		utils.Success(c, gin.H{
			"status": s.Status,
			"user": gin.H{
				"nickname": nickname,
				"avatar":   avatar,
			},
		})
	case qrStatusConfirmed:
		// token 只发放一次，发放后立即销毁会话
		delete(ctrl.sessions, qrID)
		utils.Success(c, gin.H{
			"status": s.Status,
			"token":  s.Token,
			"user":   s.User,
		})
	default:
		utils.Success(c, gin.H{"status": s.Status})
	}
}

type qrActionRequest struct {
	QRID string `json:"qr_id" binding:"required"`
}

// Scan 手机端扫描二维码（需登录）
func (ctrl *QRLoginController) Scan(c *gin.Context) {
	var req qrActionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "请求参数错误: "+err.Error())
		return
	}

	userID := c.GetInt("user_id")
	user, err := ctrl.userRepo.FindByID(userID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.BadRequest(c, "用户不存在")
			return
		}
		utils.LogDebug("查询用户失败: %v", err)
		utils.InternalServerError(c, "服务器错误")
		return
	}

	s := ctrl.getSession(req.QRID)
	if s == nil {
		utils.BadRequest(c, "二维码已过期，请刷新后重新扫描")
		return
	}

	ctrl.mu.Lock()
	defer ctrl.mu.Unlock()
	if s.Status != qrStatusPending {
		utils.BadRequest(c, "二维码已被使用，请刷新后重新扫描")
		return
	}
	s.Status = qrStatusScanned
	s.UserID = userID
	s.User = user

	utils.LogDebug("✅ [扫码登录] 用户 %d 已扫描二维码 %s", userID, req.QRID)
	utils.Success(c, nil)
}

// Confirm 手机端确认登录（需登录）
func (ctrl *QRLoginController) Confirm(c *gin.Context) {
	var req qrActionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "请求参数错误: "+err.Error())
		return
	}

	userID := c.GetInt("user_id")
	username := c.GetString("username")

	s := ctrl.getSession(req.QRID)
	if s == nil {
		utils.BadRequest(c, "二维码已过期，请在PC端刷新后重新扫描")
		return
	}

	ctrl.mu.Lock()
	if s.Status != qrStatusScanned || s.UserID != userID {
		ctrl.mu.Unlock()
		utils.BadRequest(c, "二维码状态异常，请重新扫描")
		return
	}
	ctrl.mu.Unlock()

	// 为PC端签发独立token（不影响手机的 active_token）
	token, err := utils.GenerateToken(userID, username)
	if err != nil {
		utils.LogDebug("生成token失败: %v", err)
		utils.InternalServerError(c, "服务器错误")
		return
	}

	// 🔴 踢掉旧的PC端会话（同一用户PC端只允许一个在线）
	if ctrl.hub != nil {
		ctrl.hub.ForceLogoutDevice(userID, ws.DeviceDesktop, "您的账号已在其他PC端登录")
	}
	if err := ctrl.userRepo.UpdateDesktopActiveToken(userID, token); err != nil {
		utils.LogDebug("更新desktop_active_token失败: %v", err)
		utils.InternalServerError(c, "服务器错误")
		return
	}

	ctrl.mu.Lock()
	s.Status = qrStatusConfirmed
	s.Token = token
	// 确认后给PC端多留一点取结果的时间
	s.ExpiresAt = time.Now().Add(time.Minute)
	ctrl.mu.Unlock()

	utils.LogDebug("✅ [扫码登录] 用户 %d 已确认PC端登录", userID)
	utils.Success(c, nil)
}

// Cancel 手机端取消登录（需登录）
func (ctrl *QRLoginController) Cancel(c *gin.Context) {
	var req qrActionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.BadRequest(c, "请求参数错误: "+err.Error())
		return
	}

	userID := c.GetInt("user_id")

	s := ctrl.getSession(req.QRID)
	if s == nil {
		// 已过期，无需处理
		utils.Success(c, nil)
		return
	}

	ctrl.mu.Lock()
	if s.Status == qrStatusScanned && s.UserID == userID {
		s.Status = qrStatusCancelled
	}
	ctrl.mu.Unlock()

	utils.LogDebug("ℹ️ [扫码登录] 用户 %d 取消了PC端登录", userID)
	utils.Success(c, nil)
}
