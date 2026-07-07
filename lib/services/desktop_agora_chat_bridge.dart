import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../utils/logger.dart';

/// 桌面端(macOS/Windows) Agora Chat 桥接。
///
/// 背景:agora_chat_sdk(Flutter 插件)只有 Android/iOS 原生实现,桌面端没有,
/// 导致迁移到 Agora Chat 后桌面客户端完全收发不了消息。
/// 方案:用 flutter_inappwebview 的 HeadlessInAppWebView 在后台常驻承载
/// Agora Chat **Web SDK**(assets/agora_chat_web/agora-chat.js),
/// 通过 JS 双向通道把登录/收发/历史/撤回等能力桥回 Dart。
///
/// 本类只做"传输层":方法调用 → JS,JS 事件 → 回调。
/// ChatMessage 合成、流分发等业务适配在 AgoraChatService 的桌面分支完成。
///
/// 通信协议(与 assets/agora_chat_web/index.html 对应):
/// - Dart→JS: evaluateJavascript `window.acbridge.<method>(<argJson字符串>, '<callId>')`,
///   JS 完成后经 callHandler('acResult', {callId, ok, data}) 回传;
/// - JS→Dart 事件: callHandler('acEvent', {type, payload})。
class DesktopAgoraChatBridge {
  DesktopAgoraChatBridge._internal();
  static final DesktopAgoraChatBridge _instance =
      DesktopAgoraChatBridge._internal();
  factory DesktopAgoraChatBridge() => _instance;

  HeadlessInAppWebView? _webView;
  InAppWebViewController? _controller;

  /// 页面加载 + glue 就绪(收到 glueReady 事件)
  Completer<void>? _glueReady;

  int _callSeq = 0;
  final Map<String, Completer<Map<String, dynamic>>> _pending = {};

  // ==================== 事件回调(由 AgoraChatService 桌面分支接线) ====================

  /// 收到普通消息(txt,含富媒体URL)。payload = JS normMsg map
  void Function(Map<String, dynamic> msg)? onMessage;

  /// 收到命令消息(正在输入/通话信令)
  void Function(Map<String, dynamic> msg)? onCmd;

  /// 消息被撤回
  void Function(Map<String, dynamic> msg)? onRecall;

  /// 单条已读回执
  void Function(Map<String, dynamic> msg)? onRead;

  /// 会话已读回执(对端读了整个会话),参数=对端会话ID
  void Function(String from)? onConvRead;

  /// 在线状态变更(原始 payload)
  void Function(Map<String, dynamic> presence)? onPresence;

  /// 连接状态: true=connected
  void Function(bool connected)? onConnectionChanged;

  /// token 即将过期/已过期(由上层触发续期)
  void Function()? onTokenWillExpire;
  void Function()? onTokenExpired;

  /// 🔴 WebView 的 WebContent 进程死亡(被系统终止/挂起后无法恢复)。
  /// JS 冻结时 Web SDK 连 onDisconnected 都发不出来,上层必须整体重建 WebView。
  void Function()? onProcessDied;

  bool get isRunning => _webView != null;

  // ==================== 生命周期 ====================

  /// 启动后台 WebView 并等待 glue 就绪(幂等)。
  Future<bool> ensureStarted() async {
    if (_glueReady != null) {
      // 已在启动中/已启动:等同一个就绪信号
      try {
        await _glueReady!.future.timeout(const Duration(seconds: 20));
        return true;
      } catch (_) {
        return false;
      }
    }
    _glueReady = Completer<void>();
    try {
      // 组装页面:index.html + 内联 Web SDK(占位替换,一次性加载)
      final html =
          await rootBundle.loadString('assets/agora_chat_web/index.html');
      final sdkJs =
          await rootBundle.loadString('assets/agora_chat_web/agora-chat.js');
      final fullHtml = html.replaceFirst(
        '<!-- __AGORA_CHAT_SDK__ -->',
        '<script>$sdkJs</script>',
      );

      _webView = HeadlessInAppWebView(
        initialData: InAppWebViewInitialData(
          data: fullHtml,
          // 非 null origin,减少 SDK XHR/WebSocket 在 about:blank 下的兼容问题
          baseUrl: WebUri('https://agora-chat-bridge.local/'),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          // 桥接页无媒体,关掉自动播放限制等无关项即可默认
        ),
        onWebViewCreated: (controller) {
          _controller = controller;
          controller.addJavaScriptHandler(
            handlerName: 'acEvent',
            callback: (args) => _handleEvent(args),
          );
          controller.addJavaScriptHandler(
            handlerName: 'acResult',
            callback: (args) => _handleResult(args),
          );
          controller.addJavaScriptHandler(
            handlerName: 'acLog',
            callback: (args) {
              try {
                final m = jsonDecode(args.first as String);
                logger.debug('💬 [ChatBridge/JS] ${m['msg']}');
              } catch (_) {}
            },
          );
        },
        onConsoleMessage: (controller, msg) {
          logger.debug('💬 [ChatBridge/console] ${msg.message}');
        },
        onLoadStop: (controller, url) async {
          logger.debug('💬 [ChatBridge] 页面加载完成: $url');
          // 🔴 glueReady 兜底：macOS 无头模式下 flutter_inappwebviewPlatformReady
          // 事件可能不触发/晚触发，导致 JS 排队的 glueReady 事件永远发不出来。
          // 页面加载完成后直接轮询 window.acbridge 是否就绪，就绪即视为 glueReady。
          for (var i = 0; i < 20; i++) {
            if (_glueReady == null || _glueReady!.isCompleted) return;
            try {
              final r = await controller.evaluateJavascript(
                  source: 'window.acbridge ? 1 : 0');
              logger.debug('💬 [ChatBridge] 轮询 acbridge: $r (第${i + 1}次)');
              if (r == 1 || r == '1') {
                if (_glueReady != null && !_glueReady!.isCompleted) {
                  logger.debug('💬 [ChatBridge] glueReady(轮询兜底)');
                  _glueReady!.complete();
                }
                return;
              }
            } catch (e) {
              logger.debug('💬 [ChatBridge] 轮询 acbridge 异常: $e');
            }
            await Future.delayed(const Duration(milliseconds: 500));
          }
        },
        onReceivedError: (controller, request, error) {
          logger.error('💬 [ChatBridge] 页面加载错误: ${error.description}');
        },
        // 🔴 macOS/iOS: WKWebView 的 JS 跑在独立的 WebContent 进程里,
        // 被系统杀掉时本进程无任何异常,Web SDK 也发不出 onDisconnected,
        // 只有这个回调能感知,必须通知上层重建
        onWebContentProcessDidTerminate: (controller) {
          logger.error('💬 [ChatBridge] WebContent 进程已终止,桥接失效');
          onProcessDied?.call();
        },
      );
      await _webView!.run();
      await _glueReady!.future.timeout(const Duration(seconds: 20));
      logger.debug('💬 [ChatBridge] 后台 WebView 就绪');
      return true;
    } catch (e) {
      logger.error('💬 [ChatBridge] 启动失败: $e');
      // 启动失败允许下次重试
      await dispose();
      return false;
    }
  }

  /// 关停 WebView(登出/重建时)。
  Future<void> dispose() async {
    try {
      await _webView?.dispose();
    } catch (_) {}
    _webView = null;
    _controller = null;
    _glueReady = null;
    // 未决调用全部失败返回
    for (final c in _pending.values) {
      if (!c.isCompleted) {
        c.complete({'ok': false, 'data': 'bridge disposed'});
      }
    }
    _pending.clear();
  }

  // ==================== JS 通道 ====================

  void _handleEvent(List<dynamic> args) {
    Map<String, dynamic> evt;
    try {
      evt = jsonDecode(args.first as String) as Map<String, dynamic>;
    } catch (e) {
      logger.error('💬 [ChatBridge] 事件解析失败: $e');
      return;
    }
    final type = evt['type']?.toString() ?? '';
    final payload = (evt['payload'] is Map)
        ? Map<String, dynamic>.from(evt['payload'] as Map)
        : <String, dynamic>{};
    switch (type) {
      case 'glueReady':
        if (_glueReady != null && !_glueReady!.isCompleted) {
          _glueReady!.complete();
        }
        break;
      case 'connected':
        onConnectionChanged?.call(true);
        break;
      case 'disconnected':
        onConnectionChanged?.call(false);
        break;
      case 'tokenWillExpire':
        onTokenWillExpire?.call();
        break;
      case 'tokenExpired':
        onTokenExpired?.call();
        break;
      case 'message':
        onMessage?.call(payload);
        break;
      case 'cmd':
        onCmd?.call(payload);
        break;
      case 'recall':
        onRecall?.call(payload);
        break;
      case 'read':
        onRead?.call(payload);
        break;
      case 'convRead':
        onConvRead?.call(payload['from']?.toString() ?? '');
        break;
      case 'presence':
        onPresence?.call(payload);
        break;
      default:
        logger.debug('💬 [ChatBridge] 未知事件: $type');
    }
  }

  void _handleResult(List<dynamic> args) {
    try {
      final res = jsonDecode(args.first as String) as Map<String, dynamic>;
      final callId = res['callId']?.toString() ?? '';
      final c = _pending.remove(callId);
      if (c != null && !c.isCompleted) {
        c.complete({'ok': res['ok'] == true, 'data': res['data']});
      }
    } catch (e) {
      logger.error('💬 [ChatBridge] 结果解析失败: $e');
    }
  }

  /// 调 JS 方法。返回 {'ok': bool, 'data': dynamic}。
  Future<Map<String, dynamic>> _call(
    String method,
    Map<String, dynamic> arg, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final controller = _controller;
    if (controller == null) {
      return {'ok': false, 'data': 'bridge not started'};
    }
    final callId = 'c${++_callSeq}';
    final completer = Completer<Map<String, dynamic>>();
    _pending[callId] = completer;
    // 双重 jsonEncode:外层把 JSON 文本转成 JS 字符串字面量(带引号+转义)
    final argLiteral = jsonEncode(jsonEncode(arg));
    try {
      await controller.evaluateJavascript(
        source: 'window.acbridge.$method($argLiteral, "$callId")',
      );
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      _pending.remove(callId);
      logger.error('💬 [ChatBridge] $method 调用超时');
      return {'ok': false, 'data': 'timeout'};
    } catch (e) {
      _pending.remove(callId);
      logger.error('💬 [ChatBridge] $method 调用异常: $e');
      return {'ok': false, 'data': '$e'};
    }
  }

  // ==================== 对上层暴露的操作 ====================

  /// 存活探测:同步 eval 一个常量表达式。
  /// WebContent 进程被挂起时 evaluateJavascript 永远不返回(靠 timeout 判死),
  /// 被终止时抛异常/返回 null —— 任一情况都视为桥接已死。
  Future<bool> ping({Duration timeout = const Duration(seconds: 8)}) async {
    final controller = _controller;
    if (controller == null) return false;
    try {
      final r = await controller
          .evaluateJavascript(source: 'window.acbridge ? 1 : 0')
          .timeout(timeout);
      return r == 1 || r == '1';
    } catch (_) {
      return false;
    }
  }

  /// 🧪 调试用：在桥接页面里执行任意 JS 并返回结果（仅诊断用途）
  Future<dynamic> debugEval(String source) async {
    try {
      return await _controller?.evaluateJavascript(source: source);
    } catch (e) {
      return 'eval error: $e';
    }
  }

  /// 初始化 Web SDK 连接对象。
  Future<bool> init({required String appKey}) async {
    final r = await _call('init', {'appKey': appKey});
    if (r['ok'] != true) {
      logger.error('💬 [ChatBridge] init 失败: ${r['data']}');
    }
    return r['ok'] == true;
  }

  /// 登录。[user]=纯数字用户名,[token]=后端下发的 Agora Chat 用户 token。
  Future<bool> login({required String user, required String token}) async {
    final r = await _call('login', {'user': user, 'token': token},
        timeout: const Duration(seconds: 20));
    if (r['ok'] != true) {
      logger.error('💬 [ChatBridge] login 失败: ${r['data']}');
    }
    return r['ok'] == true;
  }

  Future<void> logout() async {
    await _call('logout', {});
  }

  Future<bool> renewToken(String token) async {
    final r = await _call('renewToken', {'token': token});
    return r['ok'] == true;
  }

  /// 发送文本/富媒体(URL as content)。成功返回服务端 msgId,失败 null。
  /// [chatType] 'singleChat' | 'groupChat'
  Future<String?> sendText({
    required String to,
    required String content,
    required String chatType,
    Map<String, dynamic>? ext,
  }) async {
    final r = await _call('sendText', {
      'to': to,
      'content': content,
      'chatType': chatType,
      'ext': ext ?? {},
    });
    if (r['ok'] == true) {
      final data = r['data'];
      if (data is Map) return data['msgId']?.toString();
      return '';
    }
    logger.error('💬 [ChatBridge] sendText 失败: ${r['data']}');
    return null;
  }

  /// 发送命令消息(typing/通话信令)。
  Future<bool> sendCmd({
    required String to,
    required String chatType,
    required String action,
    Map<String, dynamic>? ext,
    bool deliverOnlineOnly = false,
  }) async {
    final r = await _call('sendCmd', {
      'to': to,
      'chatType': chatType,
      'action': action,
      'ext': ext ?? {},
      'deliverOnlineOnly': deliverOnlineOnly,
    });
    return r['ok'] == true;
  }

  /// 拉历史。返回 {'messages': List<Map>, 'cursor': String, 'isLast': bool};失败 null。
  Future<Map<String, dynamic>?> getHistory({
    required String targetId,
    required String chatType,
    int pageSize = 20,
    String cursor = '',
  }) async {
    final r = await _call('getHistory', {
      'targetId': targetId,
      'chatType': chatType,
      'pageSize': pageSize,
      'cursor': cursor,
    });
    if (r['ok'] == true && r['data'] is Map) {
      return Map<String, dynamic>.from(r['data'] as Map);
    }
    logger.error('💬 [ChatBridge] getHistory 失败: ${r['data']}');
    return null;
  }

  /// 撤回。失败时返回错误信息(JSON 字符串,含 code/msg),成功返回 null。
  Future<String?> recall({
    required String mid,
    required String to,
    required String chatType,
  }) async {
    final r = await _call('recall', {'mid': mid, 'to': to, 'chatType': chatType});
    if (r['ok'] == true) return null;
    return r['data']?.toString() ?? 'unknown error';
  }

  /// 会话已读回执(同时清服务端未读)。
  Future<void> readAck({required String to, required String chatType}) async {
    await _call('readAck', {'to': to, 'chatType': chatType});
  }

  /// 拉一页服务端会话列表。返回 {'conversations': List<Map>, 'cursor': String};失败 null。
  Future<Map<String, dynamic>?> getConversations({
    int pageSize = 50,
    String cursor = '',
  }) async {
    final r = await _call('getConversations', {
      'pageSize': pageSize,
      'cursor': cursor,
    });
    if (r['ok'] == true && r['data'] is Map) {
      return Map<String, dynamic>.from(r['data'] as Map);
    }
    logger.error('💬 [ChatBridge] getConversations 失败: ${r['data']}');
    return null;
  }

  Future<void> publishPresence(String description) async {
    await _call('publishPresence', {'description': description});
  }
}
