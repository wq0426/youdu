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
}
