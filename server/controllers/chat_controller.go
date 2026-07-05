package controllers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"telegram-server/config"
	"telegram-server/utils"

	"github.com/gin-gonic/gin"
)

// ChatController Agora Chat（即时通讯）相关接口
// 负责下发 Chat 用户登录 token，并在首次取 token 时按需把用户注册到 Agora Chat。
type ChatController struct {
	httpClient *http.Client
}

// NewChatController 创建 ChatController
func NewChatController() *ChatController {
	return &ChatController{
		httpClient: &http.Client{Timeout: 10 * time.Second},
	}
}

// chatUsernameOf 本项目约定：Chat 用户名 = 用户整型ID的字符串（纯数字，满足 Agora 命名限制）
func chatUsernameOf(userID int) string {
	return strconv.Itoa(userID)
}

// GetChatToken GET /api/chat/token
// 返回当前登录用户的 Agora Chat 登录信息：appKey + username + token。
// 客户端用 ChatClient.init(appKey) 后 loginWithToken(username, token)。
func (cc *ChatController) GetChatToken(c *gin.Context) {
	userIDVal, exists := c.Get("user_id")
	if !exists {
		utils.Unauthorized(c, "未授权")
		return
	}
	userID := userIDVal.(int)
	username := chatUsernameOf(userID)

	appID := config.AppConfig.AgoraAppID
	appCert := config.AppConfig.AgoraAppCertificate
	if appID == "" || appCert == "" {
		utils.InternalServerError(c, "Agora 配置未设置，请联系管理员")
		return
	}

	// 首次取 token 时按需注册用户（幂等、尽力而为，失败不阻塞登录）
	if err := cc.ensureUserRegistered(username); err != nil {
		utils.LogDebug("⚠️ [Chat] 注册用户到 Agora 失败（忽略，可能已存在）: user=%s, err=%v", username, err)
	}

	// 24 小时有效期
	const expireSeconds uint32 = 24 * 3600
	token, err := utils.GenerateChatUserToken(appID, appCert, username, expireSeconds)
	if err != nil {
		utils.InternalServerError(c, "生成 Chat Token 失败: "+err.Error())
		return
	}

	utils.Success(c, gin.H{
		"app_key":           config.AppConfig.AgoraChatAppKey,
		"username":          username,
		"token":             token,
		"expire_in_seconds": expireSeconds,
	})
}

// ensureUserRegistered 调用 Agora Chat REST 注册用户（幂等）
// 需要配置 AGORA_CHAT_APP_KEY(orgName#appName) 与 AGORA_CHAT_REST_HOST。
// 未配置时跳过（适用于控制台开启了自动注册或用户已预先批量注册的场景）。
func (cc *ChatController) ensureUserRegistered(username string) error {
	appKey := config.AppConfig.AgoraChatAppKey
	restHost := config.AppConfig.AgoraChatRestHost
	if appKey == "" || restHost == "" {
		return nil // 未配置 REST，跳过注册
	}

	parts := strings.SplitN(appKey, "#", 2)
	if len(parts) != 2 {
		return fmt.Errorf("AGORA_CHAT_APP_KEY 格式应为 orgName#appName: %s", appKey)
	}
	orgName, appName := parts[0], parts[1]

	appToken, err := utils.GenerateChatAppToken(config.AppConfig.AgoraAppID, config.AppConfig.AgoraAppCertificate, 3600)
	if err != nil {
		return fmt.Errorf("生成 app token 失败: %w", err)
	}

	url := fmt.Sprintf("https://%s/%s/%s/users", restHost, orgName, appName)
	body, _ := json.Marshal(map[string]string{"username": username})
	req, err := http.NewRequest(http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	req.Header.Set("Authorization", "Bearer "+appToken)

	resp, err := cc.httpClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	// 200 创建成功；400 + "already exists" 视为成功（幂等）
	if resp.StatusCode == http.StatusOK {
		return nil
	}
	var respBody bytes.Buffer
	_, _ = respBody.ReadFrom(resp.Body)
	if resp.StatusCode == http.StatusBadRequest && strings.Contains(respBody.String(), "already exists") {
		return nil
	}
	return fmt.Errorf("注册返回 %d: %s", resp.StatusCode, respBody.String())
}
