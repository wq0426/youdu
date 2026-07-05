package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"telegram-server/config"
	"telegram-server/utils"
)

// AgoraChatGroupService 声网即时通讯（Agora Chat）群组 REST 服务
//
// 负责把本地群组同步到 Agora Chat（建群/加人/移人/解散），与 Tencent IM 同期同构，
// 用于消息体系迁移到 Agora Chat 后承载群聊会话。
//
// 关键差异：Agora Chat 的群组ID由服务端自动分配（不可自定义），因此建群后需把
// 返回的 groupid 回写到本地 groups 表的 agora_group_id 字段，作为群会话标识。
type AgoraChatGroupService struct {
	httpClient *http.Client
}

// NewAgoraChatGroupService 创建 Agora Chat 群组服务
func NewAgoraChatGroupService() *AgoraChatGroupService {
	return &AgoraChatGroupService{
		httpClient: &http.Client{Timeout: 10 * time.Second},
	}
}

// configured 是否已配置 Agora Chat REST（AppKey=orgName#appName + RestHost）
func (s *AgoraChatGroupService) configured() bool {
	return config.AppConfig.AgoraChatAppKey != "" &&
		config.AppConfig.AgoraChatRestHost != "" &&
		config.AppConfig.AgoraAppID != "" &&
		config.AppConfig.AgoraAppCertificate != ""
}

// baseURL 返回 REST 基础地址 https://{host}/{org}/{app}
func (s *AgoraChatGroupService) baseURL() (string, error) {
	parts := strings.SplitN(config.AppConfig.AgoraChatAppKey, "#", 2)
	if len(parts) != 2 {
		return "", fmt.Errorf("AGORA_CHAT_APP_KEY 格式应为 orgName#appName: %s", config.AppConfig.AgoraChatAppKey)
	}
	return fmt.Sprintf("https://%s/%s/%s", config.AppConfig.AgoraChatRestHost, parts[0], parts[1]), nil
}

// doRequest 执行带 app token 鉴权的 REST 请求，返回解析后的 JSON map。
func (s *AgoraChatGroupService) doRequest(method, path string, body interface{}) (map[string]interface{}, error) {
	base, err := s.baseURL()
	if err != nil {
		return nil, err
	}

	appToken, err := utils.GenerateChatAppToken(config.AppConfig.AgoraAppID, config.AppConfig.AgoraAppCertificate, 3600)
	if err != nil {
		return nil, fmt.Errorf("生成 app token 失败: %w", err)
	}

	var reader io.Reader
	if body != nil {
		jsonData, err := json.Marshal(body)
		if err != nil {
			return nil, fmt.Errorf("序列化请求失败: %w", err)
		}
		reader = bytes.NewReader(jsonData)
	}

	req, err := http.NewRequest(method, base+path, reader)
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	req.Header.Set("Authorization", "Bearer "+appToken)

	resp, err := s.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	respBody, _ := io.ReadAll(resp.Body)
	var parsed map[string]interface{}
	if len(respBody) > 0 {
		_ = json.Unmarshal(respBody, &parsed)
	}

	// 2xx 视为成功
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		return parsed, nil
	}
	return parsed, fmt.Errorf("REST %s %s 返回 %d: %s", method, path, resp.StatusCode, string(respBody))
}

// CreateGroup 在 Agora Chat 创建群组，返回 Agora 分配的 groupid。
// ownerID 为群主用户ID；memberIDs 为初始成员（含或不含群主均可，内部会去重并排除群主）。
// 未配置时返回空字符串 + nil（跳过）。
func (s *AgoraChatGroupService) CreateGroup(groupName string, ownerID int, memberIDs []int) (string, error) {
	if !s.configured() {
		utils.LogDebug("⚠️ Agora Chat 未配置，跳过建群")
		return "", nil
	}

	ownerStr := strconv.Itoa(ownerID)
	members := make([]string, 0, len(memberIDs))
	seen := map[string]bool{ownerStr: true}
	for _, mid := range memberIDs {
		mstr := strconv.Itoa(mid)
		if !seen[mstr] {
			seen[mstr] = true
			members = append(members, mstr)
		}
	}

	body := map[string]interface{}{
		"groupname": groupName,
		"desc":      groupName,
		"public":    true,
		"maxusers":  2000,
		"approval":  false, // 公开群加入无需审批（审批逻辑仍由本地 group_members 管理）
		"owner":     ownerStr,
		"members":   members,
	}

	resp, err := s.doRequest(http.MethodPost, "/chatgroups", body)
	if err != nil {
		utils.LogDebug("❌ Agora Chat 建群失败: %v", err)
		return "", err
	}

	if data, ok := resp["data"].(map[string]interface{}); ok {
		if gid, ok := data["groupid"].(string); ok && gid != "" {
			utils.LogDebug("✅ Agora Chat 建群成功: agoraGroupID=%s, name=%s", gid, groupName)
			return gid, nil
		}
	}
	return "", fmt.Errorf("Agora Chat 建群响应缺少 groupid: %v", resp)
}

// AddGroupMembers 批量添加群成员（单次最多 60 人，超出自动分批）。
func (s *AgoraChatGroupService) AddGroupMembers(agoraGroupID string, memberIDs []int) error {
	if !s.configured() || agoraGroupID == "" || len(memberIDs) == 0 {
		return nil
	}

	const batchSize = 60
	usernames := make([]string, 0, len(memberIDs))
	for _, mid := range memberIDs {
		usernames = append(usernames, strconv.Itoa(mid))
	}

	for i := 0; i < len(usernames); i += batchSize {
		end := i + batchSize
		if end > len(usernames) {
			end = len(usernames)
		}
		body := map[string]interface{}{"usernames": usernames[i:end]}
		if _, err := s.doRequest(http.MethodPost, "/chatgroups/"+agoraGroupID+"/users", body); err != nil {
			utils.LogDebug("❌ Agora Chat 加群成员失败: %v", err)
			return err
		}
	}
	utils.LogDebug("✅ Agora Chat 加群成员成功: agoraGroupID=%s, count=%d", agoraGroupID, len(memberIDs))
	return nil
}

// RemoveGroupMember 移除单个群成员。
func (s *AgoraChatGroupService) RemoveGroupMember(agoraGroupID string, userID int) error {
	if !s.configured() || agoraGroupID == "" {
		return nil
	}
	username := strconv.Itoa(userID)
	if _, err := s.doRequest(http.MethodDelete, "/chatgroups/"+agoraGroupID+"/users/"+username, nil); err != nil {
		utils.LogDebug("❌ Agora Chat 移除群成员失败: %v", err)
		return err
	}
	utils.LogDebug("✅ Agora Chat 移除群成员成功: agoraGroupID=%s, user=%s", agoraGroupID, username)
	return nil
}

// DestroyGroup 解散群组。
func (s *AgoraChatGroupService) DestroyGroup(agoraGroupID string) error {
	if !s.configured() || agoraGroupID == "" {
		return nil
	}
	if _, err := s.doRequest(http.MethodDelete, "/chatgroups/"+agoraGroupID, nil); err != nil {
		utils.LogDebug("❌ Agora Chat 解散群失败: %v", err)
		return err
	}
	utils.LogDebug("✅ Agora Chat 解散群成功: agoraGroupID=%s", agoraGroupID)
	return nil
}

// SendUserText 以 fromUserID 身份向 toUserID 发送一条文本消息（服务端代发）。
// ext 透传业务字段（sender_name/sender_avatar/message_type 等），保证客户端按既有 ext 契约还原渲染。
// 未配置时静默跳过（返回 nil）。代发的消息会持久化进 Agora 会话并支持离线投递。
func (s *AgoraChatGroupService) SendUserText(fromUserID, toUserID int, content string, ext map[string]interface{}) error {
	if !s.configured() {
		utils.LogDebug("⚠️ Agora Chat 未配置，跳过用户消息代发")
		return nil
	}
	body := map[string]interface{}{
		"from": strconv.Itoa(fromUserID),
		"to":   []string{strconv.Itoa(toUserID)},
		"type": "txt",
		"body": map[string]interface{}{"msg": content},
	}
	if len(ext) > 0 {
		body["ext"] = ext
	}
	if _, err := s.doRequest(http.MethodPost, "/messages/users", body); err != nil {
		utils.LogDebug("❌ Agora Chat 用户消息代发失败 from=%d to=%d: %v", fromUserID, toUserID, err)
		return err
	}
	utils.LogDebug("✅ Agora Chat 用户消息代发成功 from=%d to=%d", fromUserID, toUserID)
	return nil
}

// SendCmd 通过 Agora Chat REST 给单个用户发送命令(CMD)消息，用于通话信令等控制类消息。
// action 固定用 "call_signal"，具体信令类型放 ext["signal"](incoming_call/call_rejected/...)。
// 与普通文本消息不同：CMD 不进会话历史，适合承载信令。ext 里的字段值需可 JSON 序列化。
func (s *AgoraChatGroupService) SendCmd(fromUserID, toUserID int, action string, ext map[string]interface{}) error {
	if !s.configured() {
		utils.LogDebug("⚠️ Agora Chat 未配置，跳过 CMD 代发")
		return nil
	}
	body := map[string]interface{}{
		"from": strconv.Itoa(fromUserID),
		"to":   []string{strconv.Itoa(toUserID)},
		"type": "cmd",
		"body": map[string]interface{}{"action": action},
	}
	if len(ext) > 0 {
		body["ext"] = ext
	}
	if _, err := s.doRequest(http.MethodPost, "/messages/users", body); err != nil {
		utils.LogDebug("❌ Agora Chat CMD 代发失败 from=%d to=%d action=%s: %v", fromUserID, toUserID, action, err)
		return err
	}
	utils.LogDebug("✅ Agora Chat CMD 代发成功 from=%d to=%d action=%s", fromUserID, toUserID, action)
	return nil
}

// SendGroupText 以 fromUserID 身份向 Agora 群 agoraGroupID 发送一条文本消息（服务端代发）。
// 未配置或 agoraGroupID 为空时静默跳过（返回 nil）。
func (s *AgoraChatGroupService) SendGroupText(fromUserID int, agoraGroupID string, content string, ext map[string]interface{}) error {
	if !s.configured() {
		utils.LogDebug("⚠️ Agora Chat 未配置，跳过群消息代发")
		return nil
	}
	if agoraGroupID == "" {
		utils.LogDebug("⚠️ Agora 群ID为空，跳过群消息代发 from=%d", fromUserID)
		return nil
	}
	body := map[string]interface{}{
		"from": strconv.Itoa(fromUserID),
		"to":   []string{agoraGroupID},
		"type": "txt",
		"body": map[string]interface{}{"msg": content},
	}
	if len(ext) > 0 {
		body["ext"] = ext
	}
	if _, err := s.doRequest(http.MethodPost, "/messages/chatgroups", body); err != nil {
		utils.LogDebug("❌ Agora Chat 群消息代发失败 from=%d group=%s: %v", fromUserID, agoraGroupID, err)
		return err
	}
	utils.LogDebug("✅ Agora Chat 群消息代发成功 from=%d group=%s", fromUserID, agoraGroupID)
	return nil
}

// 全局实例
var AgoraChatGroup *AgoraChatGroupService

// InitAgoraChatGroup 初始化 Agora Chat 群组服务
func InitAgoraChatGroup() {
	AgoraChatGroup = NewAgoraChatGroupService()
	if AgoraChatGroup.configured() {
		utils.LogDebug("✅ Agora Chat 群组服务已初始化")
	} else {
		utils.LogDebug("⚠️ Agora Chat 群组服务未配置（AGORA_CHAT_APP_KEY/REST_HOST），相关同步将被跳过")
	}
}
