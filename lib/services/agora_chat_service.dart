import 'dart:async';
import 'dart:io' show Platform;

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../config/agora_config.dart';
import '../models/message_model.dart';
import '../utils/logger.dart';
import 'api_service.dart';
import 'desktop_agora_chat_bridge.dart';

/// 声网 Agora Chat（即时通讯）服务
///
/// 封装 agora_chat_sdk，统一负责 IM 的初始化、登录/登出、token 续期，
/// 以及消息接收事件的分发。逐步替代自建后端消息体系（WebSocket + 本地库 + REST）。
///
/// 阶段0：打通初始化 + 登录 + 连接事件 + 收消息事件骨架。
/// 后续阶段在此基础上扩展发送/历史/撤回/已读/在线状态等能力。
class AgoraChatService {
  AgoraChatService._internal();
  static final AgoraChatService _instance = AgoraChatService._internal();
  factory AgoraChatService() => _instance;

  /// 事件监听标识（连接监听与消息监听共用一个命名空间）
  static const String _handlerId = 'telegram_agora_chat';

  bool _initialized = false;
  bool _loggedIn = false;
  String? _appKey;
  String? _currentUsername;

  /// 业务后端登录 token，用于 chat token 续期时再次向后端换取新的 chat token
  String? _authToken;

  /// 连接状态流：true=已连接 chat 服务器，false=断开
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  /// 收到的新消息流（原始 ChatMessage 列表，由上层适配为业务 MessageModel）
  final StreamController<List<ChatMessage>> _messageController =
      StreamController<List<ChatMessage>>.broadcast();

  /// 收到撤回的消息流
  final StreamController<List<ChatMessage>> _recallController =
      StreamController<List<ChatMessage>>.broadcast();

  /// 阶段4：已读回执流（我发出的消息被对方读了，单条 sendMessageReadAck 触发）
  final StreamController<List<ChatMessage>> _readController =
      StreamController<List<ChatMessage>>.broadcast();

  /// 阶段4：会话已读回执流（对端进入会话读了我发给TA的全部消息，
  /// 由对端 sendConversationReadAck 触发；参数=对端会话ID字符串）
  final StreamController<String> _conversationReadController =
      StreamController<String>.broadcast();

  /// 阶段4：命令消息流（正在输入等，body 为 ChatCmdMessageBody）
  final StreamController<List<ChatMessage>> _cmdController =
      StreamController<List<ChatMessage>>.broadcast();

  /// 阶段4：在线状态变更流
  final StreamController<List<ChatPresence>> _presenceController =
      StreamController<List<ChatPresence>>.broadcast();

  /// 通话信令流（已从 CMD 命令消息解析为与旧 WS 一致的 data map）。
  /// 由 [callSignalAction] 的 CMD 消息触发；map 含 'type'(=signal) + 'from' + 透传字段。
  /// 供 AgoraService 订阅，替代原 WebSocket 的 onWebRTCSignal。
  final StreamController<Map<String, dynamic>> _callSignalController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<List<ChatMessage>> get messageStream => _messageController.stream;
  Stream<List<ChatMessage>> get recallStream => _recallController.stream;
  Stream<List<ChatMessage>> get readStream => _readController.stream;
  Stream<String> get conversationReadStream =>
      _conversationReadController.stream;
  Stream<List<ChatMessage>> get cmdStream => _cmdController.stream;
  Stream<List<ChatPresence>> get presenceStream => _presenceController.stream;

  /// 通话信令流（CMD → data map），见 [_callSignalController]。
  Stream<Map<String, dynamic>> get callSignalStream =>
      _callSignalController.stream;

  /// 正在输入命令消息的 action 标识
  static const String typingAction = 'telegram_typing';

  /// 通话信令命令消息的 action 标识（迁移自服务器 WS 推送）
  /// 具体信令类型放在 attributes['signal']（incoming_call / call_rejected / call_ended ...）
  static const String callSignalAction = 'call_signal';
  static const String extCallSignal = 'signal'; // attributes 里标识具体信令的 key

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  String? get currentUsername => _currentUsername;

  // ==================== 桌面端桥接(macOS/Windows/Linux) ====================
  // agora_chat_sdk 只有 Android/iOS 原生实现;桌面端经 DesktopAgoraChatBridge
  // (HeadlessInAppWebView + Agora Chat Web SDK)承载同等能力。
  // 对外 API 与事件流完全一致,页面层无感知。

  /// 是否走 Web SDK 桥接(桌面端)
  static bool get _useWebBridge =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  final DesktopAgoraChatBridge _bridge = DesktopAgoraChatBridge();
  bool _bridgeWired = false;

  /// 桌面端:msgId 到 (接收方, chatType) 元数据,撤回时需要(Web SDK recall 要 to+chatType)
  final Map<String, (String, String)> _desktopMsgMeta = {};

  /// 桌面端:会话最后一条消息缓存(latestMessageFor 数据源)。
  /// key: 单聊 'u:<对端用户ID>';群聊 'g:<Agora群ID>'
  final Map<String, MessageModel> _desktopLastMsg = {};

  /// 初始化 SDK（幂等）。优先使用传入的 appKey，其次用 AgoraConfig.chatAppKey。
  Future<bool> init({String? appKey}) async {
    final key =
        (appKey != null && appKey.isNotEmpty) ? appKey : AgoraConfig.chatAppKey;
    if (key.isEmpty) {
      logger.error('💬 [AgoraChat] AppKey 未配置，无法初始化（请在 Agora 控制台开通即时通讯后填入 AgoraConfig.chatAppKey 或由后端 /api/chat/token 下发）');
      return false;
    }
    if (_initialized && _appKey == key) return true;

    // 桌面端:启动后台 WebView 桥接并初始化 Web SDK 连接
    if (_useWebBridge) {
      _appKey = key;
      final started = await _bridge.ensureStarted();
      if (!started) {
        logger.error('💬 [AgoraChat] 桌面桥接 WebView 启动失败');
        return false;
      }
      _wireBridge();
      final ok = await _bridge.init(appKey: key);
      if (ok) {
        _initialized = true;
        logger.debug('💬 [AgoraChat] 桌面桥接初始化完成 appKey=$key');
      }
      return ok;
    }

    try {
      _appKey = key;
      final options = ChatOptions(
        appKey: key,
        autoLogin: false, // 由业务登录流程显式调用 login
        debugMode: false,
      );
      await ChatClient.getInstance.init(options);
      _registerHandlers();
      _initialized = true;
      logger.debug('💬 [AgoraChat] 初始化完成 appKey=$key');
      return true;
    } catch (e) {
      logger.error('💬 [AgoraChat] 初始化失败: $e');
      return false;
    }
  }

  void _registerHandlers() {
    // 连接事件
    ChatClient.getInstance.addConnectionEventHandler(
      _handlerId,
      ConnectionEventHandler(
        onConnected: () {
          _loggedIn = true;
          _connectionController.add(true);
          logger.debug('💬 [AgoraChat] onConnected');
        },
        onDisconnected: () {
          _connectionController.add(false);
          logger.debug('💬 [AgoraChat] onDisconnected');
        },
        onTokenWillExpire: () {
          logger.debug('💬 [AgoraChat] token 即将过期，尝试续期');
          _renewToken();
        },
        onTokenDidExpire: () {
          logger.debug('💬 [AgoraChat] token 已过期，尝试续期');
          _renewToken();
        },
        onUserDidLoginFromOtherDevice: (deviceName) {
          logger.debug('💬 [AgoraChat] 账号在其他设备登录: $deviceName');
        },
      ),
    );

    // 消息接收事件
    ChatClient.getInstance.chatManager.addEventHandler(
      _handlerId,
      ChatEventHandler(
        onMessagesReceived: (messages) {
          logger.debug('💬 [AgoraChat] 收到 ${messages.length} 条消息');
          _messageController.add(messages);
          // 🔵 服务器端消息同步：接收方收到消息后异步上报归档（后台聊天记录展示用）。
          // 不 await —— 与本地 sqlite 入库/页面渲染并行，失败只记日志不影响前端。
          unawaited(_syncMessagesToServer(messages));
        },
        onMessagesRecalled: (messages) {
          logger.debug('💬 [AgoraChat] ${messages.length} 条消息被撤回');
          _recallController.add(messages);
          // 🔵 撤回同步：把服务器归档记录标记为 recalled（异步，失败不影响前端）
          unawaited(_syncRecallToServer(messages));
        },
        // 阶段4：已读回执（对方已读了我发出的消息 —— 单条 sendMessageReadAck）
        onMessagesRead: (messages) {
          logger.debug('💬 [AgoraChat] ${messages.length} 条消息已读回执');
          _readController.add(messages);
        },
        // 阶段4：会话已读回执（对端进入会话，读了我发给TA的全部消息 ——
        // 对端调用 sendConversationReadAck 触发，from=对端会话ID）
        onConversationRead: (from, to) {
          logger.debug('💬 [AgoraChat] 收到会话已读回执 from=$from to=$to');
          _conversationReadController.add(from);
        },
        // 阶段4：命令消息（正在输入等）
        onCmdMessagesReceived: (messages) {
          _cmdController.add(messages);
          _extractCallSignals(messages);
        },
      ),
    );

    // 阶段4：在线状态（Presence）订阅变更事件
    ChatClient.getInstance.presenceManager.addEventHandler(
      _handlerId,
      ChatPresenceEventHandler(
        onPresenceStatusChanged: (list) {
          _presenceController.add(list);
        },
      ),
    );
  }

  /// 用业务后端登录态换取 Agora Chat 登录信息并登录。
  /// [userId] 当前用户ID；[authToken] 业务后端登录 token。
  Future<bool> loginFromBackend({
    required int userId,
    required String authToken,
  }) async {
    _authToken = authToken;
    try {
      final resp = await ApiService.getChatToken(token: authToken);
      if (resp['code'] != 0 || resp['data'] == null) {
        logger.error('💬 [AgoraChat] 获取 chat token 失败: ${resp['message']}');
        return false;
      }
      final data = resp['data'] as Map<String, dynamic>;
      final key = data['app_key'] as String?;
      final username = (data['username'] ?? userId).toString();
      final chatToken = data['token'] as String?;
      if (chatToken == null || chatToken.isEmpty) {
        logger.error('💬 [AgoraChat] 后端返回的 chat token 为空');
        return false;
      }

      final ok = await init(appKey: key);
      if (!ok) return false;

      return await _login(username, chatToken);
    } catch (e) {
      logger.error('💬 [AgoraChat] 登录流程异常: $e');
      return false;
    }
  }

  Future<bool> _login(String username, String token) async {
    // 桌面端:经桥接登录 Web SDK
    if (_useWebBridge) {
      // 切换账号时先登出旧会话,避免以旧账号身份收发
      if (_currentUsername != null && _currentUsername != username) {
        logger.debug('💬 [AgoraChat/桥接] 切换账号 $_currentUsername → $username,先登出');
        await _bridge.logout();
        _loggedIn = false;
      }
      final ok = await _bridge.login(user: username, token: token);
      if (ok) {
        _currentUsername = username;
        _loggedIn = true;
        logger.debug('💬 [AgoraChat/桥接] 登录成功 username=$username');
      } else {
        logger.error('💬 [AgoraChat/桥接] 登录失败 username=$username');
      }
      return ok;
    }

    try {
      final alreadyConnected = await ChatClient.getInstance.isConnected();
      if (_currentUsername == username && alreadyConnected) {
        _loggedIn = true;
        return true;
      }
      // 🔴 若 SDK 已以其它账号登录（如切换/添加账号未登出旧会话），必须先登出。
      // 否则 loginWithToken 会抛 code=200(已登录)，底层连接仍是旧账号，
      // 导致新账号发出的消息以旧账号身份投递（接收方看到错误的发送者）。
      if (alreadyConnected || _currentUsername != null) {
        logger.debug('💬 [AgoraChat] 检测到已登录(username=$_currentUsername)，切换到 $username 前先登出旧会话');
        await logout();
      }
      // loginWithToken 接收 Agora AccessToken2（由后端 chatTokenBuilder 生成）
      // 超时保护：避免原生登录迟迟不回调导致初始化链路一直 await
      await ChatClient.getInstance
          .loginWithToken(username, token)
          .timeout(const Duration(seconds: 12));
      _currentUsername = username;
      _loggedIn = true;
      logger.debug('💬 [AgoraChat] 登录成功 username=$username');
      return true;
    } on ChatError catch (e) {
      // 200: 已登录
      if (e.code == 200) {
        _currentUsername = username;
        _loggedIn = true;
        logger.debug('💬 [AgoraChat] 已处于登录态 username=$username');
        return true;
      }
      logger.error('💬 [AgoraChat] 登录失败 code=${e.code} desc=${e.description}');
      return false;
    } on TimeoutException catch (_) {
      logger.error('💬 [AgoraChat] 登录超时（loginWithToken 12s 未返回）');
      return false;
    }
  }

  /// token 续期：向后端换取新的 chat token 并 renew。
  Future<void> _renewToken() async {
    final auth = _authToken;
    if (auth == null) return;
    try {
      final resp = await ApiService.getChatToken(token: auth);
      if (resp['code'] == 0 && resp['data'] != null) {
        final token = (resp['data'] as Map<String, dynamic>)['token'] as String?;
        if (token != null && token.isNotEmpty) {
          if (_useWebBridge) {
            await _bridge.renewToken(token);
          } else {
            await ChatClient.getInstance.renewAgoraToken(token);
          }
          logger.debug('💬 [AgoraChat] token 已续期');
        }
      }
    } catch (e) {
      logger.error('💬 [AgoraChat] token 续期失败: $e');
    }
  }

  // ==================== 阶段1：1对1 文本消息 ====================

  /// 业务自定义字段统一通过 ChatMessage.attributes(ext) 透传的 key
  static const String extSenderName = 'sender_name';
  static const String extSenderAvatar = 'sender_avatar';
  static const String extReceiverName = 'receiver_name';
  static const String extReceiverAvatar = 'receiver_avatar';
  static const String extMessageType = 'message_type';
  static const String extQuotedContent = 'quoted_message_content';
  static const String extFileName = 'file_name';
  static const String extVoiceDuration = 'voice_duration';
  static const String extSenderNickname = 'sender_nickname'; // 群昵称（群聊）
  static const String extSenderFullName = 'sender_full_name'; // 发送者全名
  static const String extMentionedUserIds = 'mentioned_user_ids'; // 被@用户ID（群聊）
  static const String extMentions = 'mentions'; // @文本（群聊）

  /// 发送 1对1 文本消息。
  /// [toUserId] 接收方用户ID；[ext] 透传的业务字段（发送者昵称/头像、引用内容等）。
  /// 返回发送中的 ChatMessage（已带 msgId，用于乐观更新本地消息）；失败返回 null。
  Future<ChatMessage?> sendText({
    required int toUserId,
    required String content,
    Map<String, dynamic>? ext,
  }) async {
    if (!_initialized) {
      logger.error('💬 [AgoraChat] 未初始化，无法发送消息');
      return null;
    }
    if (_useWebBridge) {
      return _bridgeSendText(
        to: toUserId.toString(),
        content: content,
        chatType: 'singleChat',
        ext: ext,
      );
    }
    try {
      final msg = ChatMessage.createTxtSendMessage(
        targetId: toUserId.toString(),
        content: content,
      );
      if (ext != null && ext.isNotEmpty) {
        msg.attributes = ext.map((k, v) => MapEntry(k, v));
      }
      final sent = await ChatClient.getInstance.chatManager.sendMessage(msg);
      logger.debug('💬 [AgoraChat] 已发送文本消息 msgId=${sent.msgId} -> $toUserId');
      return sent;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 发送文本失败 code=${e.code} desc=${e.description}');
      return null;
    } catch (e) {
      logger.error('💬 [AgoraChat] 发送文本异常: $e');
      return null;
    }
  }

  /// 发送 1对1 富媒体消息（图片/文件/视频/语音）。
  /// 媒体先经现有 OSS 上传得到 [url]，这里把 URL 作为消息体、类型等信息走 ext 透传，
  /// 与文本统一走 Agora 文本消息通道（接收端按 message_type 还原渲染）。
  Future<ChatMessage?> sendMedia({
    required int toUserId,
    required String url,
    required String messageType, // image / file / video / voice
    String? senderName,
    String? senderAvatar,
    String? fileName,
    int? voiceDuration,
  }) {
    return sendText(
      toUserId: toUserId,
      content: url,
      ext: {
        extMessageType: messageType,
        if (senderName != null) extSenderName: senderName,
        if (senderAvatar != null) extSenderAvatar: senderAvatar,
        if (fileName != null) extFileName: fileName,
        if (voiceDuration != null) extVoiceDuration: voiceDuration,
      },
    );
  }

  /// 拉取与某用户的 1对1 历史消息（从服务端，按时间从新到旧的一页）。
  /// 返回按时间升序（旧→新）排列的 ChatMessage 列表，便于直接喂给 UI。
  Future<List<ChatMessage>> fetchHistory1v1({
    required int peerUserId,
    int pageSize = 20,
    String cursor = '', // 分页游标，首页传空
  }) async {
    if (!_initialized) return [];
    if (_useWebBridge) {
      final page = await _bridgeHistoryPage(
        targetId: peerUserId.toString(),
        isGroup: false,
        pageSize: pageSize,
        cursor: cursor,
      );
      return page.messages;
    }
    try {
      final result =
          await ChatClient.getInstance.chatManager.fetchHistoryMessagesByOption(
        peerUserId.toString(),
        ChatConversationType.Chat,
        cursor: cursor,
        pageSize: pageSize,
        options: FetchMessageOptions(
          direction: ChatSearchDirection.Up,
          needSave: true, // 顺便落入 SDK 本地库，便于后续本地加载
        ),
      );
      // fetchHistoryMessages 默认 direction=Up，返回从新到旧；统一翻转为旧→新
      final list = List<ChatMessage>.from(result.data);
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      logger.debug('💬 [AgoraChat] 拉取历史 ${list.length} 条 (peer=$peerUserId)');
      return list;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 拉取历史失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  /// 从 SDK 本地数据库加载与某用户的 1对1 历史（持久化本地缓存，跨 App 重启有效）。
  /// 收发的消息 SDK 会自动落本地库，`fetchHistory1v1` 也设了 needSave:true。
  /// 返回按时间升序（旧→新）排列；本地无该会话或无消息时返回空列表（不触网）。
  Future<List<ChatMessage>> loadLocalHistory1v1({
    required int peerUserId,
    int pageSize = 20,
  }) async {
    if (!_initialized) return [];
    // 桌面端桥接无 SDK 本地库:返回空,上层自动回退服务端拉取
    if (_useWebBridge) return [];
    try {
      final conv = await ChatClient.getInstance.chatManager.getConversation(
        peerUserId.toString(),
        type: ChatConversationType.Chat,
        createIfNeed: false,
      );
      if (conv == null) return [];
      // startMsgId 传空 + Up：取本地最新的 pageSize 条
      final list = await conv.loadMessages(
        loadCount: pageSize,
        direction: ChatSearchDirection.Up,
      );
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      logger.debug('💬 [AgoraChat] 本地库命中 ${list.length} 条 (peer=$peerUserId)');
      return list;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 读取本地库失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  /// 本地优先加载 1对1 历史：先读 SDK 本地库（L2 持久化缓存），
  /// 为空再回退到服务端拉取（拉取后 SDK 自动落库，下次即走本地）。
  Future<List<ChatMessage>> loadHistory1v1({
    required int peerUserId,
    int pageSize = 20,
  }) async {
    final local =
        await loadLocalHistory1v1(peerUserId: peerUserId, pageSize: pageSize);
    if (local.isNotEmpty) return local;
    logger.debug('💬 [AgoraChat] 本地库为空，回退服务端拉取 (peer=$peerUserId)');
    return fetchHistory1v1(peerUserId: peerUserId, pageSize: pageSize);
  }

  /// 从 SDK 本地库加载比 [startMsgId] **更旧**的 1对1 历史（旧→新），仅本地不触网。
  /// 用于上滑加载更多：先吃本地缓存，本地无更旧再请求服务端。无更旧返回空。
  Future<List<ChatMessage>> loadLocalOlder1v1({
    required int peerUserId,
    required String startMsgId,
    int pageSize = 30,
  }) async {
    if (!_initialized || startMsgId.isEmpty) return [];
    // 桌面端桥接无 SDK 本地库:返回空,上层转服务端分页
    if (_useWebBridge) return [];
    try {
      final conv = await ChatClient.getInstance.chatManager.getConversation(
        peerUserId.toString(),
        type: ChatConversationType.Chat,
        createIfNeed: false,
      );
      if (conv == null) return [];
      final list = await conv.loadMessages(
        startMsgId: startMsgId,
        loadCount: pageSize,
        direction: ChatSearchDirection.Up, // Up = 比 startMsgId 更旧
      );
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      logger.debug('💬 [AgoraChat] 本地更旧命中 ${list.length} 条 (peer=$peerUserId)');
      return list;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 读取本地更旧失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  /// 服务端分页拉取 1对1 历史（用于本地缓存耗尽后请求更旧记录）。
  /// 传上一页返回的 [cursor]（首次传空）；返回该页消息(旧→新) + 下一页游标。
  /// 下一页游标为空表示服务端已无更旧记录。
  Future<AgoraMsgPage> fetchHistory1v1Page({
    required int peerUserId,
    int pageSize = 30,
    String cursor = '',
  }) async {
    if (!_initialized) return const AgoraMsgPage([], '');
    if (_useWebBridge) {
      return _bridgeHistoryPage(
        targetId: peerUserId.toString(),
        isGroup: false,
        pageSize: pageSize,
        cursor: cursor,
      );
    }
    try {
      final result =
          await ChatClient.getInstance.chatManager.fetchHistoryMessagesByOption(
        peerUserId.toString(),
        ChatConversationType.Chat,
        cursor: cursor,
        pageSize: pageSize,
        options: FetchMessageOptions(
          direction: ChatSearchDirection.Up,
          needSave: true,
        ),
      );
      final list = List<ChatMessage>.from(result.data);
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      return AgoraMsgPage(list, result.cursor ?? '');
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 服务端分页拉取失败 code=${e.code} desc=${e.description}');
      return const AgoraMsgPage([], '');
    }
  }

  /// 获取该用户的**全部**会话列表（不设条数上限，游标分页直到取尽）。
  /// [preferLocal]=true 时优先读 SDK 本地库（热路径秒出，不联网），本地为空再回退服务端；
  /// 默认 false 时优先服务端游标分页拉取（首登/换机时本地库尚空也能拿到），失败回退本地库。
  Future<List<ChatConversation>> fetchAllConversations({
    int pageSize = 50,
    bool preferLocal = false,
  }) async {
    if (!_initialized) return [];
    // 桌面端不产生原生 ChatConversation 对象;会话列表走 buildConversationSummaries
    if (_useWebBridge) return [];
    // 本地优先：进会话列表的热路径直接读 SDK 本地库，秒出且不联网。
    // 本地为空（首登/换机）才回退服务端全量拉取。
    if (preferLocal) {
      try {
        final local =
            await ChatClient.getInstance.chatManager.loadAllConversations();
        if (local.isNotEmpty) {
          logger.debug('💬 [AgoraChat] 本地会话列表（优先）${local.length} 个');
          return local;
        }
        logger.debug('💬 [AgoraChat] 本地会话为空，回退服务端全量拉取');
      } catch (e) {
        logger.debug('💬 [AgoraChat] 读取本地会话失败，回退服务端: $e');
      }
    }
    final all = <ChatConversation>[];
    try {
      String? cursor;
      // 循环到服务端返回空游标 / 空页为止，确保会话全量取出
      while (true) {
        final res = await ChatClient.getInstance.chatManager.fetchConversation(
          cursor: cursor,
          pageSize: pageSize,
        );
        all.addAll(res.data);
        final nextCursor = res.cursor;
        // 终止条件：无下一页游标、游标未推进、或本页为空（防死循环）
        if (nextCursor == null ||
            nextCursor.isEmpty ||
            nextCursor == cursor ||
            res.data.isEmpty) {
          break;
        }
        cursor = nextCursor;
      }
      logger.debug('💬 [AgoraChat] 服务端会话列表（全量）${all.length} 个');
      return all;
    } on ChatError catch (e) {
      logger.error(
          '💬 [AgoraChat] 服务端拉会话失败 code=${e.code} desc=${e.description}，回退本地库');
      try {
        final local =
            await ChatClient.getInstance.chatManager.loadAllConversations();
        logger.debug('💬 [AgoraChat] 本地会话列表 ${local.length} 个');
        return local;
      } catch (_) {
        return all;
      }
    }
  }

  // ==================== 阶段3：群聊 ====================

  /// 本地群ID ↔ Agora 群会话ID 双向映射。
  /// 群消息收发/历史都以 Agora 群ID 为会话标识，但 UI/MessageModel 用本地群ID，
  /// 故需在登录预热与打开群聊时登记映射，便于收到群消息时还原为本地群ID路由。
  final Map<int, String> _localToAgoraGroup = {};
  final Map<String, int> _agoraToLocalGroup = {};

  /// 登记一条群ID映射（agoraGroupId 为空则忽略）。
  void registerGroupMapping(int localGroupId, String? agoraGroupId) {
    if (agoraGroupId == null || agoraGroupId.isEmpty) return;
    _localToAgoraGroup[localGroupId] = agoraGroupId;
    _agoraToLocalGroup[agoraGroupId] = localGroupId;
  }

  /// 由本地群ID取 Agora 群会话ID（未登记返回 null）。
  String? agoraGroupIdFor(int localGroupId) => _localToAgoraGroup[localGroupId];

  /// 由 Agora 群会话ID取本地群ID（未登记返回 null）。
  int? localGroupIdFor(String agoraGroupId) => _agoraToLocalGroup[agoraGroupId];

  /// 发送群聊文本消息。[agoraGroupId] 为 Agora 分配的群会话ID。
  Future<ChatMessage?> sendGroupText({
    required String agoraGroupId,
    required String content,
    Map<String, dynamic>? ext,
  }) async {
    if (!_initialized) {
      logger.error('💬 [AgoraChat] 未初始化，无法发送群消息');
      return null;
    }
    if (_useWebBridge) {
      return _bridgeSendText(
        to: agoraGroupId,
        content: content,
        chatType: 'groupChat',
        ext: ext,
      );
    }
    try {
      final msg = ChatMessage.createTxtSendMessage(
        targetId: agoraGroupId,
        content: content,
      );
      msg.chatType = ChatType.GroupChat;
      if (ext != null && ext.isNotEmpty) {
        msg.attributes = ext.map((k, v) => MapEntry(k, v));
      }
      final sent = await ChatClient.getInstance.chatManager.sendMessage(msg);
      logger.debug('💬 [AgoraChat] 已发送群消息 msgId=${sent.msgId} -> group:$agoraGroupId');
      return sent;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 发送群消息失败 code=${e.code} desc=${e.description}');
      return null;
    } catch (e) {
      logger.error('💬 [AgoraChat] 发送群消息异常: $e');
      return null;
    }
  }

  /// 发送群聊富媒体消息（图片/文件/视频/语音）。URL 走消息体，类型等走 ext。
  Future<ChatMessage?> sendGroupMedia({
    required String agoraGroupId,
    required String url,
    required String messageType,
    String? senderName,
    String? senderAvatar,
    String? senderFullName,
    String? fileName,
    int? voiceDuration,
  }) {
    return sendGroupText(
      agoraGroupId: agoraGroupId,
      content: url,
      ext: {
        extMessageType: messageType,
        if (senderName != null) extSenderName: senderName,
        if (senderAvatar != null) extSenderAvatar: senderAvatar,
        if (senderFullName != null) extSenderFullName: senderFullName,
        if (fileName != null) extFileName: fileName,
        if (voiceDuration != null) extVoiceDuration: voiceDuration,
      },
    );
  }

  /// 通话系统消息类型集合：实时展示走服务器 WS 广播帧，
  /// Agora 副本只承担持久化/漫游，实时到达时各会话页监听器应跳过（避免重复上屏）。
  static const Set<String> callSystemMessageTypes = {
    'group_call_initiated',
    'group_video_call_initiated',
  };

  /// 群通话结束消息类型（"通话时长 XX:XX"/"发起人已取消"）：
  /// 与上面同理，实时展示走服务器 WS 广播帧，Agora 副本只承担持久化/漫游。
  /// 🔴 只能在【群聊】监听器里跳过——单聊的 call_ended 由对端经 Agora 发送，
  /// 是接收方唯一的展示路径，不能跳过。
  static const Set<String> groupCallEndedMessageTypes = {
    'call_ended',
    'call_ended_video',
  };

  /// 持久化"XX发起了语音/视频通话"群系统消息。
  /// 服务器经 WS 广播的通话系统消息不落库（旧消息表已下线），退出会话重进即丢失；
  /// 发起方调用本方法补发一条带 message_type 的 Agora 群消息承担持久化/漫游。
  Future<ChatMessage?> sendGroupCallInitiatedMessage({
    required int localGroupId,
    required bool isVideo,
    required String senderName,
  }) async {
    final agoraGid = agoraGroupIdFor(localGroupId);
    if (agoraGid == null || agoraGid.isEmpty) {
      logger.error('💬 [AgoraChat] 群 $localGroupId 未登记 Agora 映射，无法持久化通话发起消息');
      return null;
    }
    final typeText = isVideo ? '视频通话' : '语音通话';
    return sendGroupText(
      agoraGroupId: agoraGid,
      content: '$senderName发起了$typeText',
      ext: {
        extMessageType:
            isVideo ? 'group_video_call_initiated' : 'group_call_initiated',
        extSenderName: senderName,
        extSenderFullName: senderName,
        'call_type': isVideo ? 'video' : 'voice',
      },
    );
  }

  /// 持久化群通话结束消息（"通话时长 XX:XX"/"发起人已取消"）。
  /// 与 [sendGroupCallInitiatedMessage] 同一方案：服务器 WS 广播帧不落库，
  /// 由最后离开的成员（LeaveGroupCall 响应 is_call_ended=true）补发 Agora 群消息。
  Future<ChatMessage?> sendGroupCallEndedMessage({
    required int localGroupId,
    required String content,
    required bool isVideo,
    String? senderName,
  }) async {
    final agoraGid = agoraGroupIdFor(localGroupId);
    if (agoraGid == null || agoraGid.isEmpty) {
      logger.error('💬 [AgoraChat] 群 $localGroupId 未登记 Agora 映射，无法持久化通话结束消息');
      return null;
    }
    return sendGroupText(
      agoraGroupId: agoraGid,
      content: content,
      ext: {
        extMessageType: isVideo ? 'call_ended_video' : 'call_ended',
        if (senderName != null && senderName.isNotEmpty) ...{
          extSenderName: senderName,
          extSenderFullName: senderName,
        },
        'call_type': isVideo ? 'video' : 'voice',
      },
    );
  }

  /// 拉取群聊历史（服务端，按时间升序返回一页）。
  Future<List<ChatMessage>> fetchGroupHistory({
    required String agoraGroupId,
    int pageSize = 20,
    String cursor = '',
  }) async {
    if (!_initialized) return [];
    if (_useWebBridge) {
      final page = await _bridgeHistoryPage(
        targetId: agoraGroupId,
        isGroup: true,
        pageSize: pageSize,
        cursor: cursor,
      );
      return page.messages;
    }
    try {
      final result =
          await ChatClient.getInstance.chatManager.fetchHistoryMessagesByOption(
        agoraGroupId,
        ChatConversationType.GroupChat,
        cursor: cursor,
        pageSize: pageSize,
        options: FetchMessageOptions(
          direction: ChatSearchDirection.Up,
          needSave: true,
        ),
      );
      final list = List<ChatMessage>.from(result.data);
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      logger.debug('💬 [AgoraChat] 拉取群历史 ${list.length} 条 (group=$agoraGroupId)');
      return list;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 拉取群历史失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  /// 从 SDK 本地库加载群聊历史（不触网；本地无则返回空）。
  Future<List<ChatMessage>> loadLocalGroupHistory({
    required String agoraGroupId,
    int pageSize = 20,
  }) async {
    if (!_initialized) return [];
    // 桌面端桥接无 SDK 本地库:返回空,上层自动回退服务端拉取
    if (_useWebBridge) return [];
    try {
      final conv = await ChatClient.getInstance.chatManager.getConversation(
        agoraGroupId,
        type: ChatConversationType.GroupChat,
        createIfNeed: false,
      );
      if (conv == null) return [];
      final list = await conv.loadMessages(
        loadCount: pageSize,
        direction: ChatSearchDirection.Up,
      );
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      logger.debug('💬 [AgoraChat] 群本地库命中 ${list.length} 条 (group=$agoraGroupId)');
      return list;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 读取群本地库失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  /// 本地优先加载群聊历史：先本地库，为空回退服务端。
  Future<List<ChatMessage>> loadGroupHistory({
    required String agoraGroupId,
    int pageSize = 20,
  }) async {
    final local =
        await loadLocalGroupHistory(agoraGroupId: agoraGroupId, pageSize: pageSize);
    if (local.isNotEmpty) return local;
    return fetchGroupHistory(agoraGroupId: agoraGroupId, pageSize: pageSize);
  }

  /// 从 SDK 本地库加载比 [startMsgId] **更旧**的群聊历史（旧→新），仅本地不触网。
  Future<List<ChatMessage>> loadLocalOlderGroup({
    required String agoraGroupId,
    required String startMsgId,
    int pageSize = 30,
  }) async {
    if (!_initialized || startMsgId.isEmpty) return [];
    // 桌面端桥接无 SDK 本地库:返回空,上层转服务端分页
    if (_useWebBridge) return [];
    try {
      final conv = await ChatClient.getInstance.chatManager.getConversation(
        agoraGroupId,
        type: ChatConversationType.GroupChat,
        createIfNeed: false,
      );
      if (conv == null) return [];
      final list = await conv.loadMessages(
        startMsgId: startMsgId,
        loadCount: pageSize,
        direction: ChatSearchDirection.Up,
      );
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      logger.debug('💬 [AgoraChat] 群本地更旧命中 ${list.length} 条 (group=$agoraGroupId)');
      return list;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 读取群本地更旧失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  /// 服务端分页拉取群聊历史（本地耗尽后请求更旧）。游标语义同 [fetchHistory1v1Page]。
  Future<AgoraMsgPage> fetchGroupHistoryPage({
    required String agoraGroupId,
    int pageSize = 30,
    String cursor = '',
  }) async {
    if (!_initialized) return const AgoraMsgPage([], '');
    if (_useWebBridge) {
      return _bridgeHistoryPage(
        targetId: agoraGroupId,
        isGroup: true,
        pageSize: pageSize,
        cursor: cursor,
      );
    }
    try {
      final result =
          await ChatClient.getInstance.chatManager.fetchHistoryMessagesByOption(
        agoraGroupId,
        ChatConversationType.GroupChat,
        cursor: cursor,
        pageSize: pageSize,
        options: FetchMessageOptions(
          direction: ChatSearchDirection.Up,
          needSave: true,
        ),
      );
      final list = List<ChatMessage>.from(result.data);
      list.sort((a, b) {
        final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
        final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
        return ta.compareTo(tb);
      });
      return AgoraMsgPage(list, result.cursor ?? '');
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 群服务端分页拉取失败 code=${e.code} desc=${e.description}');
      return const AgoraMsgPage([], '');
    }
  }

  // ==================== 阶段5：会话列表 / 未读 ====================

  /// 基于 Agora 会话构建"最近会话"摘要（最后一条消息 + 未读数 + 排序时间）。
  /// 注意：Agora 会话只含 id/最后消息/未读数，**不含**对端昵称头像——
  /// 上层需用本地联系人/群组缓存补全展示信息。按最后消息时间倒序返回。
  Future<List<AgoraConversationSummary>> buildConversationSummaries({
    bool preferLocal = false,
  }) async {
    if (!_initialized) return [];
    // 桌面端:直接由 Web SDK 服务端会话列表构建摘要
    if (_useWebBridge) return _bridgeConversationSummaries();
    final convs = await fetchAllConversations(preferLocal: preferLocal);
    // 并行获取每个会话的最后一条消息 + 未读数，避免会话多时串行 await 逐个等待。
    final futures = convs.map<Future<AgoraConversationSummary?>>((c) async {
      try {
        final isGroup = c.type == ChatConversationType.GroupChat;
        final int peerId = isGroup
            ? (localGroupIdFor(c.id) ?? int.tryParse(c.id) ?? 0)
            : (int.tryParse(c.id) ?? 0);
        if (peerId == 0) return null;
        final results = await Future.wait([c.latestMessage(), c.unreadCount()]);
        final last = results[0] as ChatMessage?;
        final unread = results[1] as int;
        final model = last != null ? chatMessageToModel(last) : null;
        final t = last != null
            ? (last.serverTime != 0 ? last.serverTime : last.localTime)
            : 0;
        return AgoraConversationSummary(
          isGroup: isGroup,
          peerId: peerId,
          agoraId: c.id,
          lastMessage: model,
          unreadCount: unread,
          sortTime: t,
        );
      } catch (e) {
        logger.debug('💬 [会话摘要] 跳过会话 ${c.id}: $e');
        return null;
      }
    }).toList();
    final settled = await Future.wait(futures);
    final out = settled.whereType<AgoraConversationSummary>().toList();
    out.sort((a, b) => b.sortTime.compareTo(a.sortTime));
    return out;
  }

  /// 取某会话在 Agora 中的最新一条消息（适配为 MessageModel）。本地无该会话/无消息时返回 null。
  /// 群聊传本地群ID（内部映射为 Agora 群ID）。退出聊天页刷新会话列表"最后一条消息"时使用——
  /// 会话列表数据源已是 Agora 会话，本地 SQLite 不再写入，故须以 Agora 为准。
  Future<MessageModel?> latestMessageFor({
    required int peerId,
    required bool isGroup,
  }) async {
    if (!_initialized) return null;
    // 桌面端:读会话最后消息缓存(收/发消息与会话列表拉取时维护)
    if (_useWebBridge) {
      final key = isGroup
          ? 'g:${agoraGroupIdFor(peerId) ?? peerId.toString()}'
          : 'u:$peerId';
      return _desktopLastMsg[key];
    }
    try {
      final convId = isGroup
          ? (agoraGroupIdFor(peerId) ?? peerId.toString())
          : peerId.toString();
      final conv = await ChatClient.getInstance.chatManager.getConversation(
        convId,
        type: isGroup
            ? ChatConversationType.GroupChat
            : ChatConversationType.Chat,
        createIfNeed: false,
      );
      if (conv == null) return null;
      final last = await conv.latestMessage();
      return last != null ? chatMessageToModel(last) : null;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 取会话最新消息失败 code=${e.code} desc=${e.description}');
      return null;
    }
  }

  /// 按本地ID清零某会话未读（删除会话时调用）。群ID未登记映射时静默跳过。
  /// 重置 SDK 本地未读数，使后续 [buildConversationSummaries] 不再恢复旧未读数。
  Future<void> resetConversationUnread({
    required int peerId,
    required bool isGroup,
  }) async {
    final convId = isGroup ? agoraGroupIdFor(peerId) : peerId.toString();
    if (convId == null || convId.isEmpty) return;
    await markConversationAllRead(conversationId: convId, isGroup: isGroup);
  }

  /// 清零某会话未读（进入会话页时调用，配合 sendConversationReadAck）。
  Future<void> markConversationAllRead({
    required String conversationId,
    bool isGroup = false,
  }) async {
    if (!_initialized) return;
    // 桌面端:经桥接发会话已读回执(同时清服务端未读数)
    if (_useWebBridge) {
      await _bridge.readAck(
        to: conversationId,
        chatType: isGroup ? 'groupChat' : 'singleChat',
      );
      return;
    }
    try {
      final conv = await ChatClient.getInstance.chatManager.getConversation(
        conversationId,
        type: isGroup ? ChatConversationType.GroupChat : ChatConversationType.Chat,
        createIfNeed: false,
      );
      await conv?.markAllMessagesAsRead();
    } on ChatError catch (_) {}
  }

  /// 由 Agora 消息ID派生稳定的正整数（用作 UI 列表 key / 去重）
  static int stableIdFromMsgId(String msgId) => msgId.hashCode & 0x7fffffff;

  /// 将 Agora ChatMessage 适配为业务 MessageModel（阶段1：文本）。
  /// 非文本类型暂以占位内容呈现，留待阶段2扩展。
  static MessageModel chatMessageToModel(ChatMessage msg) {
    final ext = msg.attributes ?? <String, dynamic>{};
    final body = msg.body;
    // 文本与富媒体统一走文本消息体：文本=正文，富媒体=URL。message_type 由 ext 决定。
    String content = '';
    if (body is ChatTextMessageBody) {
      content = body.content;
    }
    final messageType = ext[extMessageType]?.toString() ?? 'text';

    final isGroup = msg.chatType == ChatType.GroupChat;
    final fromId = int.tryParse(msg.from ?? '') ?? 0;
    final ts = msg.serverTime != 0 ? msg.serverTime : msg.localTime;

    // 已读判定按方向区分：
    // - 自己发出的消息：看对端已读回执 hasReadAck（对端发会话/消息已读回执后 SDK 会持久化该标志），
    //   true 才算"已读"，并填 readAt 让气泡显示蓝色"已读"；
    // - 收到的消息：看本地是否已读 hasRead。
    // 之前统一用 msg.hasRead 且不填 readAt，导致退出重进后自己发的消息永远是灰色"未读"。
    final me = AgoraChatService().currentUsername;
    final isOutgoing = me != null && me.isNotEmpty && msg.from == me;
    final readByPeer = msg.hasReadAck;
    final isReadVal = isOutgoing ? readByPeer : msg.hasRead;

    // receiverId：群聊存本地群ID（由 Agora 群ID映射还原），单聊存对端用户ID
    int receiverId;
    if (isGroup) {
      final agoraGid = msg.conversationId ?? msg.to ?? '';
      receiverId = AgoraChatService().localGroupIdFor(agoraGid) ??
          (int.tryParse(agoraGid) ?? 0);
    } else {
      receiverId = int.tryParse(msg.to ?? '') ?? 0;
    }

    // 语音时长可能以 int 或字符串透传
    int? voiceDuration;
    final vd = ext[extVoiceDuration];
    if (vd is int) {
      voiceDuration = vd;
    } else if (vd != null) {
      voiceDuration = int.tryParse(vd.toString());
    }

    // 被@用户ID列表（int 列表或逗号分隔字符串）
    List<int>? mentionedUserIds;
    final mu = ext[extMentionedUserIds];
    if (mu is List) {
      mentionedUserIds = mu
          .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
          .where((e) => e != 0)
          .toList();
    } else if (mu is String && mu.isNotEmpty) {
      mentionedUserIds = mu
          .split(',')
          .map((s) => int.tryParse(s.trim()) ?? 0)
          .where((e) => e != 0)
          .toList();
    }

    logger.debug(
        '💬 [AgoraChat] 收到消息 group=$isGroup type=$messageType from=$fromId senderName="${ext[extSenderName]}" contentLen=${content.length}');

    return MessageModel(
      id: stableIdFromMsgId(msg.msgId),
      agoraMsgId: msg.msgId,
      senderId: fromId,
      receiverId: receiverId,
      senderName: ext[extSenderName]?.toString() ?? '',
      receiverName: ext[extReceiverName]?.toString() ?? '',
      senderAvatar: ext[extSenderAvatar]?.toString(),
      receiverAvatar: ext[extReceiverAvatar]?.toString(),
      senderNickname: ext[extSenderNickname]?.toString(),
      senderFullName: ext[extSenderFullName]?.toString(),
      content: content,
      messageType: messageType,
      fileName: ext[extFileName]?.toString(),
      voiceDuration: voiceDuration,
      quotedMessageContent: ext[extQuotedContent]?.toString(),
      mentionedUserIds: mentionedUserIds,
      mentions: ext[extMentions]?.toString(),
      status: 'sent',
      isRead: isReadVal,
      readAt: (isOutgoing && readByPeer)
          ? DateTime.fromMillisecondsSinceEpoch(ts)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(ts),
    );
  }

  // ==================== 服务器端消息同步（后台聊天记录归档） ====================

  /// 把收到的消息异步上报服务器归档（管理后台展示/搜索所有用户聊天记录用）。
  /// 调用方不 await：与本地 sqlite 入库、页面渲染完全并行，任何失败只记日志。
  /// 服务器按 agora_msg_id 幂等去重，群里多个成员/多端重复上报不会产生重复记录。
  Future<void> _syncMessagesToServer(List<ChatMessage> messages) async {
    final token = _authToken;
    if (token == null || token.isEmpty) return;
    try {
      final payload = <Map<String, dynamic>>[];
      for (final msg in messages) {
        final model = chatMessageToModel(msg);
        if (model.senderId == 0) continue;
        final isGroup = msg.chatType == ChatType.GroupChat;
        int groupId = 0;
        if (isGroup) {
          // 严格用 Agora群ID→本地群ID 映射，映射缺失时跳过，避免把 Agora 群ID 当本地群ID 入库
          final agoraGid = msg.conversationId ?? msg.to ?? '';
          groupId = localGroupIdFor(agoraGid) ?? 0;
          if (groupId == 0) {
            logger.debug('💬 [消息同步] 群消息缺少本地群ID映射，跳过: ${msg.msgId}');
            continue;
          }
        } else if (model.receiverId == 0) {
          continue;
        }
        payload.add({
          'is_group': isGroup,
          'agora_msg_id': msg.msgId,
          'sender_id': model.senderId,
          'receiver_id': isGroup ? 0 : model.receiverId,
          'group_id': groupId,
          'sender_name': model.senderName,
          'receiver_name': model.receiverName,
          'sender_nickname': model.senderNickname ?? '',
          'sender_full_name': model.senderFullName ?? '',
          'content': model.content,
          'message_type': model.messageType,
          'file_name': model.fileName ?? '',
          'voice_duration': model.voiceDuration ?? 0,
          'quoted_message_content': model.quotedMessageContent ?? '',
          'created_at_ms': model.createdAt.millisecondsSinceEpoch,
        });
      }
      if (payload.isEmpty) return;
      await ApiService.syncChatMessages(messages: payload, token: token);
    } catch (e) {
      logger.debug('💬 [消息同步] 上报服务器失败(忽略，不影响前端): $e');
    }
  }

  /// 消息被撤回时异步上报，把服务器归档记录标记为 recalled。
  Future<void> _syncRecallToServer(List<ChatMessage> messages) async {
    final token = _authToken;
    if (token == null || token.isEmpty) return;
    try {
      final ids = messages.map((m) => m.msgId).where((id) => id.isNotEmpty).toList();
      if (ids.isEmpty) return;
      await ApiService.syncChatRecall(agoraMsgIds: ids, token: token);
    } catch (e) {
      logger.debug('💬 [消息同步] 撤回上报失败(忽略，不影响前端): $e');
    }
  }

  // ==================== 阶段4：撤回 / 已读 / 在线状态 / 正在输入 ====================

  /// 撤回一条消息（以 Agora 消息ID 为准）。成功 true。
  /// 失败时抛出异常，附带 Agora 的错误码与描述，便于上层区分原因
  /// （如撤回超时、Agora 控制台未开启撤回功能等）。
  Future<bool> recallMessage(String agoraMsgId) async {
    if (!_initialized) {
      throw Exception('聊天服务未初始化，无法撤回');
    }
    // 桌面端:Web SDK 撤回需要 to+chatType,从本端消息元数据表查
    if (_useWebBridge) {
      final meta = _desktopMsgMeta[agoraMsgId];
      if (meta == null) {
        throw Exception('撤回失败: 本端无该消息记录(可能是重启后发送的旧消息)');
      }
      final err = await _bridge.recall(
        mid: agoraMsgId,
        to: meta.$1,
        chatType: meta.$2,
      );
      if (err != null) {
        throw Exception('撤回失败: $err');
      }
      logger.debug('💬 [AgoraChat/桥接] 已撤回消息 msgId=$agoraMsgId');
      return true;
    }
    try {
      await ChatClient.getInstance.chatManager.recallMessage(agoraMsgId);
      logger.debug('💬 [AgoraChat] 已撤回消息 msgId=$agoraMsgId');
      return true;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 撤回失败 code=${e.code} desc=${e.description}');
      // 透传真实错误码/描述，避免上层只显示笼统的"撤回失败"
      throw Exception('撤回失败(code=${e.code}): ${e.description}');
    }
  }

  /// 进入会话时发送会话已读回执（把该会话未读清零，并通知对端）。
  /// [conversationId] 单聊=对端用户ID字符串；群聊=Agora 群ID。
  Future<void> sendConversationReadAck(String conversationId) async {
    if (!_initialized) return;
    // 桌面端:经桥接发 channel ack;群会话按已登记映射判定
    if (_useWebBridge) {
      final isGroup = _agoraToLocalGroup.containsKey(conversationId);
      await _bridge.readAck(
        to: conversationId,
        chatType: isGroup ? 'groupChat' : 'singleChat',
      );
      return;
    }
    try {
      await ChatClient.getInstance.chatManager
          .sendConversationReadAck(conversationId);
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 发送会话已读回执失败 code=${e.code} desc=${e.description}');
    }
  }

  /// 单条消息已读回执（单聊）。
  Future<void> sendMessageReadAck(ChatMessage message) async {
    if (!_initialized) return;
    // 桌面端:单条回执省略(会话级 readAck 已覆盖已读同步)
    if (_useWebBridge) return;
    try {
      await ChatClient.getInstance.chatManager.sendMessageReadAck(message);
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 发送消息已读回执失败 code=${e.code} desc=${e.description}');
    }
  }

  /// 发送"正在输入"命令消息（不入会话，只在线投递）。
  /// 单聊传 [toUserId]；群聊传 [agoraGroupId]。
  Future<void> sendTyping({int? toUserId, String? agoraGroupId}) async {
    if (!_initialized) return;
    final isGroup = agoraGroupId != null;
    final target = isGroup ? agoraGroupId : toUserId?.toString();
    if (target == null || target.isEmpty) return;
    if (_useWebBridge) {
      await _bridge.sendCmd(
        to: target,
        chatType: isGroup ? 'groupChat' : 'singleChat',
        action: typingAction,
        deliverOnlineOnly: true,
      );
      return;
    }
    try {
      final msg = ChatMessage.createCmdSendMessage(
        targetId: target,
        action: typingAction,
        deliverOnlineOnly: true, // 仅在线投递，避免离线堆积
        chatType: isGroup ? ChatType.GroupChat : ChatType.Chat,
      );
      await ChatClient.getInstance.chatManager.sendMessage(msg);
    } on ChatError catch (e) {
      logger.debug('💬 [AgoraChat] 发送输入状态忽略 code=${e.code}');
    }
  }

  /// 发送通话信令（CMD 命令消息），替代原服务器 WebSocket 推送。
  /// [toUserId] 对端用户ID（= Agora 用户名，纯数字字符串）；
  /// [signal] 具体信令：incoming_call / incoming_group_call / call_rejected /
  ///          call_ended / group_call_member_accepted / group_call_member_left /
  ///          group_call_ended；
  /// [extra] 随信令携带的字段（channel_name / call_type / caller_id 等，值需为字符串）。
  /// 注意：来电类信令要能唤醒离线端 → deliverOnlineOnly=false；离线唤起仍靠 JPush/CallKit。
  Future<bool> sendCallSignal({
    required String toUserId,
    required String signal,
    Map<String, String>? extra,
  }) async {
    if (!_initialized) {
      logger.error('💬 [AgoraChat] 未初始化，无法发送通话信令 $signal');
      return false;
    }
    if (toUserId.isEmpty) return false;
    if (_useWebBridge) {
      final ok = await _bridge.sendCmd(
        to: toUserId,
        chatType: 'singleChat',
        action: callSignalAction,
        ext: <String, dynamic>{
          extCallSignal: signal,
          if (extra != null) ...extra,
        },
        deliverOnlineOnly: false, // 来电需能投递到离线端
      );
      if (ok) {
        logger.debug('💬 [AgoraChat/桥接] 已发送通话信令 $signal -> $toUserId');
      }
      return ok;
    }
    try {
      final msg = ChatMessage.createCmdSendMessage(
        targetId: toUserId,
        action: callSignalAction,
        deliverOnlineOnly: false, // 来电需能投递到离线端
        chatType: ChatType.Chat,
      );
      msg.attributes = <String, dynamic>{
        extCallSignal: signal,
        if (extra != null) ...extra,
      };
      await ChatClient.getInstance.chatManager.sendMessage(msg);
      logger.debug('💬 [AgoraChat] 已发送通话信令 $signal -> $toUserId');
      return true;
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 发送通话信令失败 code=${e.code} desc=${e.description}');
      return false;
    } catch (e) {
      logger.error('💬 [AgoraChat] 发送通话信令异常: $e');
      return false;
    }
  }

  /// 从收到的 CMD 消息里挑出通话信令（action==[callSignalAction]），
  /// 还原成与旧 WS 一致的 data map 后推入 [callSignalStream]。
  /// data['type'] = attributes['signal']，其余透传字段一并带上，并附 'from'。
  void _extractCallSignals(List<ChatMessage> messages) {
    for (final m in messages) {
      final body = m.body;
      if (body is! ChatCmdMessageBody) continue;
      if (body.action != callSignalAction) continue;
      final attrs = m.attributes;
      final signal = attrs?[extCallSignal]?.toString();
      if (signal == null || signal.isEmpty) continue;
      final data = <String, dynamic>{};
      if (attrs != null) {
        attrs.forEach((k, v) => data[k] = v);
      }
      data['type'] = signal; // 复用旧 WS 的字段名，直接喂给 _handleWebRTCSignal
      if (m.from != null) data['from'] = m.from;
      logger.debug('💬 [AgoraChat] 收到通话信令 $signal from=${m.from}');
      _callSignalController.add(data);
    }
  }

  /// 发布自己的在线状态（description 自定义，如 'online'/'busy'）。
  Future<void> publishPresence(String description) async {
    if (!_initialized) return;
    if (_useWebBridge) {
      await _bridge.publishPresence(description);
      return;
    }
    try {
      await ChatClient.getInstance.presenceManager.publishPresence(description);
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 发布在线状态失败 code=${e.code} desc=${e.description}');
    }
  }

  /// 订阅一批用户的在线状态（有效期秒）。返回当前状态快照。
  Future<List<ChatPresence>> subscribePresence(
    List<int> userIds, {
    int expiry = 86400,
  }) async {
    if (!_initialized || userIds.isEmpty) return [];
    // 桌面端:在线状态订阅暂未桥接(UI 未接线),返回空
    if (_useWebBridge) return [];
    try {
      return await ChatClient.getInstance.presenceManager.subscribe(
        members: userIds.map((e) => e.toString()).toList(),
        expiry: expiry,
      );
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 订阅在线状态失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  /// 取消订阅一批用户的在线状态。
  Future<void> unsubscribePresence(List<int> userIds) async {
    if (!_initialized || userIds.isEmpty) return;
    if (_useWebBridge) return;
    try {
      await ChatClient.getInstance.presenceManager
          .unsubscribe(members: userIds.map((e) => e.toString()).toList());
    } on ChatError catch (_) {}
  }

  /// 主动查询一批用户的当前在线状态快照。
  Future<List<ChatPresence>> fetchPresence(List<int> userIds) async {
    if (!_initialized || userIds.isEmpty) return [];
    // 桌面端:在线状态查询暂未桥接,返回空
    if (_useWebBridge) return [];
    try {
      return await ChatClient.getInstance.presenceManager.fetchPresenceStatus(
        members: userIds.map((e) => e.toString()).toList(),
      );
    } on ChatError catch (e) {
      logger.error('💬 [AgoraChat] 查询在线状态失败 code=${e.code} desc=${e.description}');
      return [];
    }
  }

  // ==================== 桌面端桥接私有实现 ====================

  /// 把桥接层的事件接进与原生 SDK 相同的各条流(只接一次)。
  void _wireBridge() {
    if (_bridgeWired) return;
    _bridgeWired = true;
    _bridge.onConnectionChanged = (connected) {
      if (connected) _loggedIn = true;
      _connectionController.add(connected);
      logger.debug('💬 [AgoraChat/桥接] ${connected ? "onConnected" : "onDisconnected"}');
    };
    _bridge.onTokenWillExpire = () {
      logger.debug('💬 [AgoraChat/桥接] token 即将过期，尝试续期');
      _renewToken();
    };
    _bridge.onTokenExpired = () {
      logger.debug('💬 [AgoraChat/桥接] token 已过期，尝试续期');
      _renewToken();
    };
    _bridge.onMessage = (map) {
      try {
        final msg = _chatMessageFromBridgeMap(map);
        _rememberDesktopMessage(msg);
        logger.debug('💬 [AgoraChat/桥接] 收到 1 条消息 from=${msg.from}');
        _messageController.add([msg]);
        // 与移动端一致:接收方异步上报服务器归档(后台聊天记录)
        unawaited(_syncMessagesToServer([msg]));
      } catch (e) {
        logger.error('💬 [AgoraChat/桥接] 消息适配失败: $e');
      }
    };
    _bridge.onCmd = (map) {
      try {
        final msg = _chatMessageFromBridgeMap(map);
        _cmdController.add([msg]);
        _extractCallSignals([msg]);
      } catch (e) {
        logger.error('💬 [AgoraChat/桥接] 命令消息适配失败: $e');
      }
    };
    _bridge.onRecall = (map) {
      try {
        final msg = _chatMessageFromBridgeMap(map);
        logger.debug('💬 [AgoraChat/桥接] 1 条消息被撤回 msgId=${msg.msgId}');
        _recallController.add([msg]);
        unawaited(_syncRecallToServer([msg]));
      } catch (e) {
        logger.error('💬 [AgoraChat/桥接] 撤回消息适配失败: $e');
      }
    };
    _bridge.onRead = (map) {
      try {
        _readController.add([_chatMessageFromBridgeMap(map)]);
      } catch (_) {}
    };
    _bridge.onConvRead = (from) {
      if (from.isNotEmpty) {
        logger.debug('💬 [AgoraChat/桥接] 收到会话已读回执 from=$from');
        _conversationReadController.add(from);
      }
    };
  }

  /// 把桥接层的 normMsg map 合成为 SDK 的 ChatMessage(纯 Dart,走 fromJson)。
  /// 之后所有既有消费方(chatMessageToModel/页面监听)零改动复用。
  ChatMessage _chatMessageFromBridgeMap(Map<String, dynamic> m) {
    final isGroup = m['chatType'] == 'groupChat';
    final isCmd = m['msgType'] == 'cmd';
    final from = m['from']?.toString() ?? '';
    final to = m['to']?.toString() ?? '';
    final isSend =
        _currentUsername != null && from.isNotEmpty && from == _currentUsername;
    final time = (m['time'] is num) ? (m['time'] as num).toInt() : 0;
    final ext = (m['ext'] is Map)
        ? Map<String, dynamic>.from(m['ext'] as Map)
        : <String, dynamic>{};
    // 🔴 fromJson 的枚举字段(direction/body.type/chatType/status)都要求
    // 枚举下标 int，传字符串会抛 type 'String' is not a subtype of type 'int'；
    // 会话ID的键是 convId 而非 conversationId。
    return ChatMessage.fromJson({
      'from': from,
      'to': to,
      'body': isCmd
          ? {
              'type': MessageType.CMD.index,
              'action': m['action']?.toString() ?? '',
            }
          : {
              'type': MessageType.TXT.index,
              'content': m['msg']?.toString() ?? '',
            },
      'attributes': ext,
      'direction': (isSend ? MessageDirection.SEND : MessageDirection.RECEIVE)
          .index,
      'msgId': m['id']?.toString() ?? '',
      // 单聊会话ID=对端;群聊=Agora群ID(to)
      'convId': isGroup ? to : (isSend ? to : from),
      'chatType': (isGroup ? ChatType.GroupChat : ChatType.Chat).index,
      'serverTime': time,
      'localTime': time,
      'status': MessageStatus.SUCCESS.index,
    });
  }

  /// 桌面端:登记消息元数据(撤回用)+ 更新会话最后消息缓存(latestMessageFor 用)。
  void _rememberDesktopMessage(ChatMessage msg) {
    try {
      final isGroup = msg.chatType == ChatType.GroupChat;
      // 自己发出的消息才可能被本端撤回
      if (msg.direction == MessageDirection.SEND && msg.msgId.isNotEmpty) {
        _desktopMsgMeta[msg.msgId] =
            (msg.to ?? '', isGroup ? 'groupChat' : 'singleChat');
      }
      final model = chatMessageToModel(msg);
      final key = isGroup
          ? 'g:${msg.conversationId ?? msg.to ?? ''}'
          : 'u:${msg.direction == MessageDirection.SEND ? model.receiverId : model.senderId}';
      final prev = _desktopLastMsg[key];
      // 只允许更新为更新的消息(历史拉取的旧消息不回退缓存)
      if (prev == null ||
          model.createdAt.millisecondsSinceEpoch >=
              prev.createdAt.millisecondsSinceEpoch) {
        _desktopLastMsg[key] = model;
      }
    } catch (_) {}
  }

  /// 桌面端发送(文本/富媒体URL,单聊/群聊统一)。成功返回合成的 ChatMessage。
  Future<ChatMessage?> _bridgeSendText({
    required String to,
    required String content,
    required String chatType,
    Map<String, dynamic>? ext,
  }) async {
    final msgId = await _bridge.sendText(
      to: to,
      content: content,
      chatType: chatType,
      ext: ext,
    );
    if (msgId == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    final msg = _chatMessageFromBridgeMap({
      'id': msgId,
      'from': _currentUsername ?? '',
      'to': to,
      'chatType': chatType,
      'msg': content,
      'ext': ext ?? {},
      'time': now,
      'msgType': 'txt',
    });
    _rememberDesktopMessage(msg);
    logger.debug('💬 [AgoraChat/桥接] 已发送消息 msgId=$msgId -> $to ($chatType)');
    return msg;
  }

  /// 桌面端服务端分页拉历史(单聊/群聊统一)。返回该页消息(旧→新)+ 下一页游标。
  Future<AgoraMsgPage> _bridgeHistoryPage({
    required String targetId,
    required bool isGroup,
    int pageSize = 30,
    String cursor = '',
  }) async {
    final res = await _bridge.getHistory(
      targetId: targetId,
      chatType: isGroup ? 'groupChat' : 'singleChat',
      pageSize: pageSize,
      cursor: cursor,
    );
    if (res == null) return const AgoraMsgPage([], '');
    final raw = (res['messages'] is List) ? res['messages'] as List : const [];
    final list = <ChatMessage>[];
    for (final it in raw) {
      if (it is! Map) continue;
      try {
        final msg = _chatMessageFromBridgeMap(Map<String, dynamic>.from(it));
        list.add(msg);
        // 历史里自己发的消息也登记撤回元数据(不动 lastMsg 缓存,避免旧消息回退)
        if (msg.direction == MessageDirection.SEND && msg.msgId.isNotEmpty) {
          _desktopMsgMeta[msg.msgId] =
              (msg.to ?? '', isGroup ? 'groupChat' : 'singleChat');
        }
      } catch (_) {}
    }
    list.sort((a, b) {
      final ta = a.serverTime != 0 ? a.serverTime : a.localTime;
      final tb = b.serverTime != 0 ? b.serverTime : b.localTime;
      return ta.compareTo(tb);
    });
    final isLast = res['isLast'] == true;
    final nextCursor = isLast ? '' : (res['cursor']?.toString() ?? '');
    logger.debug(
        '💬 [AgoraChat/桥接] 拉取历史 ${list.length} 条 (target=$targetId, group=$isGroup)');
    return AgoraMsgPage(list, nextCursor);
  }

  /// 桌面端:由 Web SDK 服务端会话列表构建"最近会话"摘要(游标取尽)。
  Future<List<AgoraConversationSummary>> _bridgeConversationSummaries() async {
    final out = <AgoraConversationSummary>[];
    String cursor = '';
    while (true) {
      final res = await _bridge.getConversations(pageSize: 50, cursor: cursor);
      if (res == null) break;
      final convs =
          (res['conversations'] is List) ? res['conversations'] as List : const [];
      for (final c in convs) {
        if (c is! Map) continue;
        final id = c['id']?.toString() ?? '';
        if (id.isEmpty) continue;
        final isGroup = c['type'] == 'groupChat';
        // 群会话须已登记本地群ID映射;单聊会话ID即对端用户ID
        final peerId =
            isGroup ? (localGroupIdFor(id) ?? 0) : (int.tryParse(id) ?? 0);
        if (peerId == 0) continue;
        MessageModel? lastModel;
        int sortTime = 0;
        final lm = c['lastMessage'];
        if (lm is Map) {
          try {
            final cm = _chatMessageFromBridgeMap(Map<String, dynamic>.from(lm));
            lastModel = chatMessageToModel(cm);
            sortTime = cm.serverTime != 0 ? cm.serverTime : cm.localTime;
            // 顺手喂 lastMsg 缓存(latestMessageFor 用)
            _rememberDesktopMessage(cm);
          } catch (_) {}
        }
        out.add(AgoraConversationSummary(
          isGroup: isGroup,
          peerId: peerId,
          agoraId: id,
          lastMessage: lastModel,
          unreadCount: (c['unread'] is num) ? (c['unread'] as num).toInt() : 0,
          sortTime: sortTime,
        ));
      }
      final next = res['cursor']?.toString() ?? '';
      if (next.isEmpty || next == cursor || convs.isEmpty) break;
      cursor = next;
    }
    out.sort((a, b) => b.sortTime.compareTo(a.sortTime));
    logger.debug('💬 [AgoraChat/桥接] 会话摘要 ${out.length} 个');
    return out;
  }

  /// 登出（清理登录态，保留 SDK 初始化）
  Future<void> logout() async {
    try {
      if (_initialized) {
        if (_useWebBridge) {
          await _bridge.logout();
          _desktopMsgMeta.clear();
          _desktopLastMsg.clear();
        } else {
          // 超时保护：避免原生 logout 迟迟不回调导致 await 永久挂起
          await ChatClient.getInstance
              .logout(true)
              .timeout(const Duration(seconds: 8));
        }
      }
    } catch (e) {
      logger.debug('💬 [AgoraChat] 登出忽略异常: $e');
    } finally {
      _loggedIn = false;
      _currentUsername = null;
      _authToken = null;
    }
  }
}

/// 服务端历史分页结果：该页消息(旧→新) + 下一页游标(空=无更旧)。
class AgoraMsgPage {
  final List<ChatMessage> messages;
  final String cursor;
  const AgoraMsgPage(this.messages, this.cursor);
  bool get hasMore => cursor.isNotEmpty;
}

/// 阶段5：最近会话摘要（来自 Agora 会话，需上层补全昵称/头像展示信息）。
class AgoraConversationSummary {
  final bool isGroup;
  final int peerId; // 单聊=对端用户ID；群聊=本地群ID
  final String agoraId; // Agora 会话ID（单聊=对端用户名；群聊=Agora群ID）
  final MessageModel? lastMessage;
  final int unreadCount;
  final int sortTime; // 最后消息时间(ms)，用于排序

  AgoraConversationSummary({
    required this.isGroup,
    required this.peerId,
    required this.agoraId,
    required this.lastMessage,
    required this.unreadCount,
    required this.sortTime,
  });
}
