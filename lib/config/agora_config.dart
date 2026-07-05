/// 声网 Agora 配置
///
/// 客户端只需要 App ID;通话 Token 全部由服务端 REST 接口（/api/call/*）下发，
/// 因此这里不需要也不应该放 App Certificate / Secret。
///
/// 获取方式：
/// 1. 登录 https://console.agora.io
/// 2. 创建/选择一个项目
/// 3. 复制项目的 App ID
///
/// 填充方式（二选一）：
/// - 直接修改下面的 defaultValue（留空表示未配置）
/// - 或在编译/运行时通过 --dart-define=AGORA_APP_ID=你的AppID 注入
class AgoraConfig {
  /// 声网 App ID —— ⚠️ 留空，由使用者填充
  static const String appId =
      String.fromEnvironment('AGORA_APP_ID', defaultValue: '89258deb35084e97866517baf118ceb4');

  /// 是否已配置 App ID
  static bool get isConfigured => appId.isNotEmpty;

  /// 声网 Agora Chat（即时通讯）AppKey，格式 orgName#appName
  /// ⚠️ 需在 Agora 控制台为项目开通「即时通讯」后获取并填充。
  /// 注意：这是 Chat 专用 AppKey，区别于上面 RTC 用的 App ID。
  /// 兜底也会从后端 /api/chat/token 返回的 app_key 动态获取（见 AgoraChatService）。
  static const String chatAppKey =
      String.fromEnvironment('AGORA_CHAT_APP_KEY', defaultValue: '41200041982#200059092');

  /// 是否已配置 Chat AppKey
  static bool get isChatConfigured => chatAppKey.isNotEmpty;
}
