package utils

import (
	"fmt"

	chatTokenBuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/chatTokenBuilder"
)

// GenerateChatUserToken 生成 Agora Chat 用户级 Token（AccessToken2 + ServiceChat）
// 客户端用此 token 调用 ChatClient.loginWithToken(username, token)。
//
// appID / appCertificate: 与 RTC 同一个 Agora 项目（项目需开通即时通讯 Chat）。
// username: Chat 登录账号，本项目约定为「用户整型ID的字符串」（如 "1024"）。
//
//	注意 Agora 限制 username 仅允许小写字母/数字/_-.，纯数字ID天然满足。
// expireSeconds: 有效期（秒），0 表示默认 24 小时；Agora 上限 24 小时。
func GenerateChatUserToken(appID, appCertificate, username string, expireSeconds uint32) (string, error) {
	if appID == "" || appCertificate == "" {
		return "", fmt.Errorf("appID or appCertificate is empty")
	}
	if username == "" {
		return "", fmt.Errorf("username is empty")
	}
	if expireSeconds == 0 {
		expireSeconds = 86400 // 默认 24 小时
	}
	return chatTokenBuilder.BuildChatUserToken(appID, appCertificate, username, expireSeconds)
}

// GenerateChatAppToken 生成 Agora Chat App 级 Token（AccessToken2 + ServiceChat App 权限）
// 仅服务端使用：调用 Chat REST API（如注册用户）时作为 Authorization Bearer。
func GenerateChatAppToken(appID, appCertificate string, expireSeconds uint32) (string, error) {
	if appID == "" || appCertificate == "" {
		return "", fmt.Errorf("appID or appCertificate is empty")
	}
	if expireSeconds == 0 {
		expireSeconds = 86400 // 默认 24 小时
	}
	return chatTokenBuilder.BuildChatAppToken(appID, appCertificate, expireSeconds)
}
