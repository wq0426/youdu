import 'package:flutter/material.dart';

import 'services/desktop_agora_chat_bridge.dart';
import 'utils/logger.dart';

/// 🧪 桌面 Agora Chat 桥接最小验证入口（不登录业务账号）：
/// flutter run -d macos -t lib/main_bridge_test.dart
/// 验证 HeadlessInAppWebView 启动、glueReady、Dart↔JS 双向通道是否可用。
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: Scaffold(body: Center(child: Text('Agora Chat Bridge Test'))),
  ));

  Future<void>(() async {
    logger.info('🧪 [BridgeTest] 开始启动桥接 WebView...');
    final sw = Stopwatch()..start();
    final ok = await DesktopAgoraChatBridge().ensureStarted();
    logger.info('🧪 [BridgeTest] ensureStarted => $ok (耗时 ${sw.elapsedMilliseconds}ms)');
    if (ok) {
      final b = DesktopAgoraChatBridge();
      // 诊断:SDK 是否注入/执行、全局导出、加载期 JS 错误
      logger.info('🧪 [诊断] scripts数=${await b.debugEval("document.scripts.length")}');
      logger.info('🧪 [诊断] SDK脚本长度=${await b.debugEval("(document.scripts[1]&&document.scripts[1].text||'').length")}');
      logger.info('🧪 [诊断] typeof websdk=${await b.debugEval("typeof window.websdk")}');
      logger.info('🧪 [诊断] typeof WebIM=${await b.debugEval("typeof window.WebIM")}');
      logger.info('🧪 [诊断] JS错误=${await b.debugEval("JSON.stringify(window.__jsErrors)")}');
      // 验证 Dart→JS→Dart round-trip（init 一个假 appKey，能收到 JS 回包即通道正常）
      final initOk =
          await DesktopAgoraChatBridge().init(appKey: 'test#roundtrip');
      logger.info('🧪 [BridgeTest] init(假appKey) 回包 => $initOk（收到回包=通道正常，true/false 都算通）');
    }
    logger.info('🧪 [BridgeTest] 完成');
  });
}
