package utils

import (
	"crypto/tls"
	"fmt"
	"net/smtp"
	"strings"

	"telegram-server/config"
)

// SendEmailCode 发送邮箱验证码
func SendEmailCode(toEmail, code string) error {
	subject := "邮箱绑定验证码"
	body := fmt.Sprintf(`
		<html>
		<body style="font-family: Arial, sans-serif; padding: 20px;">
			<h2 style="color: #4A90E2;">邮箱绑定验证</h2>
			<p>您好，</p>
			<p>您正在绑定邮箱，验证码为：</p>
			<div style="background-color: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0;">
				<span style="font-size: 24px; font-weight: bold; color: #4A90E2; letter-spacing: 5px;">%s</span>
			</div>
			<p>验证码有效期为 %d 分钟，请尽快完成验证。</p>
			<p>如果这不是您的操作，请忽略此邮件。</p>
			<hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
			<p style="color: #999; font-size: 12px;">此邮件由系统自动发送，请勿回复。</p>
		</body>
		</html>
	`, code, config.AppConfig.VerifyCodeExpireMinutes)

	return SendEmail(toEmail, subject, body)
}

// SendResetPasswordEmail 发送重置密码验证码邮件
func SendResetPasswordEmail(toEmail, code string) error {
	subject := "重置密码验证码"
	body := fmt.Sprintf(`
		<html>
		<body style="font-family: Arial, sans-serif; padding: 20px;">
			<h2 style="color: #4A90E2;">重置密码验证</h2>
			<p>您好，</p>
			<p>您正在重置密码，验证码为：</p>
			<div style="background-color: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0;">
				<span style="font-size: 24px; font-weight: bold; color: #4A90E2; letter-spacing: 5px;">%s</span>
			</div>
			<p>验证码有效期为 %d 分钟，请尽快完成验证。</p>
			<p>如果这不是您的操作，请忽略此邮件并确保您的账号安全。</p>
			<hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
			<p style="color: #999; font-size: 12px;">此邮件由系统自动发送，请勿回复。</p>
		</body>
		</html>
	`, code, config.AppConfig.VerifyCodeExpireMinutes)

	return SendEmail(toEmail, subject, body)
}

// SendEmail 发送邮件
func SendEmail(to, subject, body string) error {
	cfg := config.AppConfig
	
	if cfg.SMTPHost == "" || cfg.SMTPUser == "" || cfg.SMTPPassword == "" {
		return fmt.Errorf("邮件服务未配置")
	}

	from := cfg.SMTPFrom
	if from == "" {
		from = cfg.SMTPUser
	}

	// 构建邮件内容
	headers := make(map[string]string)
	headers["From"] = from
	headers["To"] = to
	headers["Subject"] = subject
	headers["MIME-Version"] = "1.0"
	headers["Content-Type"] = "text/html; charset=UTF-8"

	var message strings.Builder
	for k, v := range headers {
		message.WriteString(fmt.Sprintf("%s: %s\r\n", k, v))
	}
	message.WriteString("\r\n")
	message.WriteString(body)

	// 使用SSL/TLS连接
	addr := fmt.Sprintf("%s:%d", cfg.SMTPHost, cfg.SMTPPort)
	
	LogDebug("📧 发送邮件: to=%s, subject=%s, smtp=%s", to, subject, addr)

	// 创建TLS配置
	tlsConfig := &tls.Config{
		ServerName: cfg.SMTPHost,
	}

	// 连接到SMTP服务器
	conn, err := tls.Dial("tcp", addr, tlsConfig)
	if err != nil {
		return fmt.Errorf("连接SMTP服务器失败: %v", err)
	}
	defer conn.Close()

	// 创建SMTP客户端
	client, err := smtp.NewClient(conn, cfg.SMTPHost)
	if err != nil {
		return fmt.Errorf("创建SMTP客户端失败: %v", err)
	}
	defer client.Close()

	// 认证
	auth := smtp.PlainAuth("", cfg.SMTPUser, cfg.SMTPPassword, cfg.SMTPHost)
	if err := client.Auth(auth); err != nil {
		return fmt.Errorf("SMTP认证失败: %v", err)
	}

	// 设置发件人
	if err := client.Mail(from); err != nil {
		return fmt.Errorf("设置发件人失败: %v", err)
	}

	// 设置收件人
	if err := client.Rcpt(to); err != nil {
		return fmt.Errorf("设置收件人失败: %v", err)
	}

	// 发送邮件内容
	w, err := client.Data()
	if err != nil {
		return fmt.Errorf("获取数据写入器失败: %v", err)
	}

	_, err = w.Write([]byte(message.String()))
	if err != nil {
		return fmt.Errorf("写入邮件内容失败: %v", err)
	}

	err = w.Close()
	if err != nil {
		return fmt.Errorf("关闭数据写入器失败: %v", err)
	}

	client.Quit()

	LogDebug("✅ 邮件发送成功: to=%s", to)
	return nil
}
