import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../utils/storage.dart';
import '../config/api_config.dart';
import '../utils/logger.dart';
import '../utils/timezone_helper.dart';
import 'local_database_service.dart';
import 'notification_service.dart';
import 'native_message_service.dart';
import 'auth_state_service.dart';
import 'agora_chat_service.dart';
import '../widgets/network_disconnected_banner.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  StreamSubscription? _channelSubscription;  // 🔴 新增：存储stream订阅，用于取消
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;
  String? _token;
  
  // 🔴 静默重连模式：从后台恢复时使用，不触发UI显示"正在连接..."
  bool _isSilentReconnect = false;
  bool get isSilentReconnect => _isSilentReconnect;
  
  // 🔴 记录上次成功连接的时间，用于判断是否需要显示连接状态
  DateTime? _lastConnectedTime;
  static const Duration _silentReconnectThreshold = Duration(minutes: 5); // 5分钟内静默重连
  
  // 🔴 临时存储最近发送的消息信息（用于错误处理）
  // key: receiverId_content的hash, value: {localId, receiverId, content, etc.}
  final Map<String, Map<String, dynamic>> _pendingPrivateMessages = {};
  final Map<String, Map<String, dynamic>> _pendingGroupMessages = {};
  
  // 🔴 心跳检测相关变量
  Timer? _heartbeatTimer;  // 心跳定时器
  bool _waitingForPong = false;  // 是否正在等待pong响应（发出ping后置true，收到pong置false）
  bool _intentionalDisconnect = false;  // 🔴 是否是主动断开连接（主动断开不重连）
  bool _isForcedLogout = false;  // 🔴 是否被强制登出（被踢下线后永久禁止重连）

  // 🔴 连接互斥锁：同一时刻只允许一个 connect() 真正执行，
  // 其他调用方（后台服务watchdog、生命周期resumed、重连循环等）复用同一个 Future，
  // 避免并发建立多条连接导致服务器互踢（forced_logout 风暴）
  Future<bool>? _connectFuture;

  // 🔴 连接探测：ensureConnected() 发一次性ping后等待pong，验证连接是否真的存活
  Completer<void>? _pongProbe;

  // 🔴 重连循环相关变量：心跳失败/连接断开后，最多重连5次，指数退避
  static const int _maxReconnectAttempts = 5;  // 最大重连次数
  bool _isReconnectLoopRunning = false;  // 重连循环是否正在运行（防止并发启动多个循环）
  
  // 🔴 登录保护期：新登录后短时间内忽略 forced_logout 消息
  DateTime? _loginTime;  // 登录/连接成功的时间
  static const Duration _loginGracePeriod = Duration(seconds: 10);  // 登录保护期10秒
  final _localDb = LocalDatabaseService();
  final _notificationService = NotificationService.instance;

  // 消息流，供外部监听
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _isConnected;
  bool get isForcedLogout => _isForcedLogout;  // 🔴 是否被强制登出

  // WebRTC信令回调
  Function(Map<String, dynamic>)? onWebRTCSignal;

  // 被踢下线回调
  Function(String message)? onForcedLogout;

  // 🔴 重连成功回调：用于通知UI层同步数据
  Function()? onReconnected;
  
  // 🔴 消息ACK回调：用于可靠消息服务
  Function(String clientMessageId, int serverId)? onMessageSentAck;
  Function(String clientMessageId, int messageId)? onMessageDeliveredAck;
  Function(String clientMessageId, int messageId)? onMessageReadAck;
  
  /// 🔴 本地广播头像更新事件（不经过服务端）
  /// 用于用户在本端修改自己的头像后，主动触发与服务端 `avatar_updated` 等价的本地刷新
  /// （更新本地数据库、联系人快照、会话列表与聊天页缓存），无需等待新消息驱动。
  void broadcastLocalAvatarUpdated(int userId, String? avatar) {
    if (_messageController.isClosed) return;
    _messageController.add({
      'type': 'avatar_updated',
      'data': {
        'user_id': userId,
        'avatar': avatar,
      },
    });
  }

  /// 🔴 重置强制登出状态（用户重新登录时调用）
  /// 这会清除被踢下线的标记，允许重新建立 WebSocket 连接
  void resetForcedLogoutState() {
    logger.debug('🔄 [WebSocket] 重置强制登出状态');
    _isForcedLogout = false;
    _intentionalDisconnect = false;
    _loginTime = null;
  }
  
  /// 🔴 清理旧连接（防止 "Stream has already been listened to" 错误）
  Future<void> _cleanupOldConnection() async {
    // 取消旧的stream订阅
    if (_channelSubscription != null) {
      logger.debug('🧹 [WebSocket] 取消旧的stream订阅');
      try {
        await _channelSubscription!.cancel();
      } catch (e) {
        logger.debug('⚠️ [WebSocket] 取消订阅时出错: $e');
      }
      _channelSubscription = null;
    }
    
    // 关闭旧的channel
    if (_channel != null) {
      logger.debug('🧹 [WebSocket] 关闭旧的WebSocket连接');
      try {
        _channel!.sink.close(status.goingAway);
      } catch (e) {
        logger.debug('⚠️ [WebSocket] 关闭旧连接时出错: $e');
      }
      _channel = null;
    }
  }

  // 连接到WebSocket服务
  // 🔴 互斥入口：如果已有连接正在建立中，复用同一个 Future，
  // 绝不并发创建第二条 socket（并发连接会导致服务器单点登录互踢风暴）
  Future<bool> connect({String? token}) {
    // 🔴 如果被强制登出，禁止重连
    if (_isForcedLogout) {
      logger.debug('🚫 [WebSocket] 已被强制登出，禁止重连');
      return Future.value(false);
    }

    // 🔴 如果已连接，直接返回
    if (_isConnected) {
      return Future.value(true);
    }

    // 🔴 已有连接正在建立中，等待同一个结果，不新开连接
    final inflight = _connectFuture;
    if (inflight != null) {
      logger.debug('🔄 [WebSocket] 已有连接正在建立中，复用同一个连接请求');
      return inflight;
    }

    final future = _doConnect(token: token);
    _connectFuture = future;
    return future.whenComplete(() {
      _connectFuture = null;
    });
  }

  // 🔴 真正的连接逻辑（只允许通过 connect() 的互斥锁进入）
  Future<bool> _doConnect({String? token}) async {

    // 🔴 关键修复：在创建新连接前，先清理旧连接
    await _cleanupOldConnection();

    try {
      // 优先使用传入的token，避免从Storage读取被其他窗口覆盖的token
      if (token != null && token.isNotEmpty) {
        _token = token;
      } else {
        // 如果没有传入token，则从Storage获取
        _token = await Storage.getToken();
      }

      if (_token == null || _token!.isEmpty) {
        return false;
      }

      // 使用配置的WebSocket服务器地址和独立端口
      final wsUrl = '${ApiConfig.wsBaseUrl}/ws?token=$_token';
      logger.debug('🔌 [WebSocket] 连接URL: $wsUrl');
      logger.debug('🔌 [WebSocket] wsBaseUrl: ${ApiConfig.wsBaseUrl}');
      logger.debug('🔌 [WebSocket] wsProtocol: ${ApiConfig.wsProtocol}');
      logger.debug('🔌 [WebSocket] useHttps: ${ApiConfig.useHttps}');
      logger.debug('🔌 [WebSocket] kDebugMode: $kDebugMode');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // 🔴 修复：等待连接就绪，添加超时处理
      // 🔴 关键修复：添加 null 检查，防止 "Null check operator used on a null value" 错误
      try {
        final channel = _channel;
        if (channel == null) {
          logger.error('❌ [WebSocket] _channel 为 null，连接失败');
          _scheduleReconnect();
          return false;
        }
        
        await channel.ready.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('WebSocket连接超时');
          },
        );
      } catch (e) {
        logger.error('❌ [WebSocket] 连接失败: $e');
        _channelSubscription?.cancel();
        _channelSubscription = null;
        _channel?.sink.close();
        _channel = null;
        _scheduleReconnect();
        return false;
      }

      // 🔴 监听消息，并保存订阅以便后续取消
      // 🔴 关键修复：再次检查 _channel 是否为 null
      final channelForListen = _channel;
      if (channelForListen == null) {
        logger.error('❌ [WebSocket] 连接就绪后 _channel 变为 null');
        _scheduleReconnect();
        return false;
      }
      
      _channelSubscription = channelForListen.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _isConnected = true;
      _intentionalDisconnect = false;  // 🔴 连接成功后重置主动断开标志
      // 🔴 登录保护期只对"登录后的首次连接"生效：
      // 不能每次重连都重置 _loginTime，否则断线重连后收到的 forced_logout
      // 永远落在保护期内被忽略（日志表现为"已登录 0 秒"），
      // 客户端在被服务器踢下线时会一直盲目重连，形成互踢循环
      _loginTime ??= DateTime.now();

      // 🔴 连接成功，隐藏"网络已断开"横幅（如果正在显示）
      NetworkDisconnectedBanner.hide();

      // 🔴 启动心跳检测
      _startHeartbeat();
      
      return true;
    } catch (e) {
      logger.error('❌ [WebSocket] connect异常: $e');
      _channel?.sink.close();
      _channel = null;
      _scheduleReconnect();
      return false;
    }
  }

  // 上线通知回调
  Function(Map<String, dynamic>)? onOnlineNotification;

  // 离线通知回调
  Function(Map<String, dynamic>)? onOfflineNotification;

  // 消息发送错误回调
  Function(String errorType, String errorMessage)? onMessageError;

  // 处理接收到的消息
  Future<void> _onMessage(dynamic data) async {
    try {
      // 处理可能包含多个JSON对象的数据（用换行符分隔）
      final dataString = data as String;
      final lines = dataString.trim().split('\n');

      for (final line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.isEmpty) continue;

        try {
          final message = jsonDecode(trimmedLine) as Map<String, dynamic>;
          // 🔴 处理心跳响应
          if (message['type'] == 'pong') {
            _waitingForPong = false;  // 收到响应
            // 🔴 完成一次性连接探测（ensureConnected 发起）
            if (_pongProbe != null && !_pongProbe!.isCompleted) {
              _pongProbe!.complete();
            }
            continue;
          }

          // 🚫 处理被踢下线通知
          if (message['type'] == 'forced_logout') {
            final logoutMessage = message['message'] as String? ?? '您的账号已在其他设备登录';
            
            // 🔴 登录保护期检查：新登录后10秒内忽略 forced_logout 消息
            // 这是为了防止服务器错误地将 forced_logout 发送给新登录的设备
            if (_loginTime != null) {
              final timeSinceLogin = DateTime.now().difference(_loginTime!);
              if (timeSinceLogin < _loginGracePeriod) {
                logger.debug('🛡️ [WebSocket] 登录保护期内收到 forced_logout，忽略此消息 (已登录 ${timeSinceLogin.inSeconds} 秒)');
                continue;  // 忽略此消息，继续处理其他消息
              }
            }
            
            logger.debug('🚫 [WebSocket] 收到 forced_logout 消息: $logoutMessage');
            
            // 🔴 关键修复：标记为被强制登出，永久禁止自动重连
            _isForcedLogout = true;
            _intentionalDisconnect = true;
            
            // 🔴 立即停止心跳（重连循环会通过 _isForcedLogout 标志自行退出）
            _stopHeartbeat();
            
            // 🔴 清除登录时间，防止后续消息被保护期过滤
            _loginTime = null;
            
            // 🔴 立即关闭 WebSocket 连接（同步执行，不要异步）
            _isConnected = false;
            // 🔴 取消stream订阅
            if (_channelSubscription != null) {
              try {
                _channelSubscription!.cancel();
              } catch (e) {
                logger.debug('⚠️ [WebSocket] 取消订阅时出错: $e');
              }
              _channelSubscription = null;
            }
            if (_channel != null) {
              try {
                _channel!.sink.close(status.goingAway);
              } catch (e) {
                logger.debug('⚠️ [WebSocket] 关闭连接时出错: $e');
              }
              _channel = null;
            }
            
            // 先调用回调通知上层（在断开连接之后）
            if (onForcedLogout != null) {
              onForcedLogout!(logoutMessage);
            }
            
            // 不继续处理其他消息
            return;
          }

          // 🚫 处理私聊消息发送错误通知
          if (message['type'] == 'message_error') {
            final errorData = message['data'] as Map<String, dynamic>? ?? {};
            final errorType = errorData['error'] as String? ?? '发送失败';
            final errorMessage = errorData['message'] as String? ?? '消息发送失败';
            
            // 🔴 从临时存储中获取最后一条私聊消息，插入status为forbidden的消息
            await _handlePrivateMessageError(errorType, errorMessage);
            
            // 调用错误回调通知上层
            if (onMessageError != null) {
              onMessageError!(errorType, errorMessage);
            }
            
            // 将错误消息添加到消息流，以便UI可以显示错误提示
            _messageController.add(message);
            continue;
          }
          
          // 🚫 处理群组消息发送错误通知
          if (message['type'] == 'group_message_error') {
            final errorData = message['data'] as Map<String, dynamic>? ?? {};
            final errorType = errorData['error'] as String? ?? '发送失败';
            
            // 🔴 从临时存储中获取最后一条群组消息，插入status为forbidden的消息
            await _handleGroupMessageError(errorType);
            
            // 将错误消息添加到消息流，以便UI可以显示错误提示  
            _messageController.add(message);
            continue;
          }

          // 处理WebRTC信令消息
          if (message['type'] != null && _isWebRTCSignal(message['type'])) {
            onWebRTCSignal?.call(message['data'] ?? message);
            continue;
          }

          // 处理上线通知消息
          if (message['type'] == 'online_notification') {
            onOnlineNotification?.call(message['data'] ?? {});
            // 上线通知也添加到消息流，以便HomePage可以监听
            _messageController.add(message);
            continue;
          }

          // 处理离线通知消息
          if (message['type'] == 'offline_notification') {
            onOfflineNotification?.call(message['data'] ?? {});
            // 离线通知也添加到消息流，以便HomePage可以监听
            _messageController.add(message);
            continue;
          }

          // 处理群组昵称更新通知
          if (message['type'] == 'group_nickname_updated') {
            await _handleGroupNicknameUpdated(message['data']);
            // 将消息添加到流中，供HomePage处理UI更新
            _messageController.add(message);
            continue;
          }

          // 🔵 阶段6：私聊消息已迁移到 Agora Chat，服务端不再下发 "message" 帧；离线投递改由 Agora 承担，
          // 不再下发 "offline_messages"/"offline_group_messages" 帧。对应处理与本地落库已删除。

          // 处理群聊【系统通知】消息（建群/加人/移除/禁言/通话按钮等，服务端内存构造 + WS 广播）- 保存到本地数据库
          if (message['type'] == 'group_message' && message['data'] != null) {
            await _saveGroupMessageToLocal(message['data']);
          }

          // 🔵 阶段6：离线投递改由 Agora 承担，不再下发/处理 offline_messages_saved 同步信号。

          // 🔴 已移除：不再处理message_sent和group_message_sent ACK消息
          // 服务器端已移除ACK返回逻辑，客户端使用channel缓冲保证可靠性

          // 🔴 处理消息送达确认 - 接收端已收到消息
          if (message['type'] == 'message_delivered') {
            final data = message['data'] as Map<String, dynamic>?;
            if (data != null) {
              final clientMessageId = data['client_message_id'] as String?;
              final serverMessageId = data['server_message_id'] as int? ?? data['message_id'] as int?;
              logger.debug('📬 [WebSocket] 收到消息送达确认: clientId=$clientMessageId, serverId=$serverMessageId');
              // 🔴 调用回调通知 ReliableMessageService
              if (clientMessageId != null && serverMessageId != null) {
                onMessageDeliveredAck?.call(clientMessageId, serverMessageId);
              }
              // 通知 MessageQueueService 处理送达确认
              _messageController.add(message);
            }
            continue;
          }

          // 🔴 处理消息已读确认
          if (message['type'] == 'message_read') {
            final data = message['data'] as Map<String, dynamic>?;
            if (data != null) {
              final clientMessageId = data['client_message_id'] as String?;
              final serverMessageId = data['server_message_id'] as int? ?? data['message_id'] as int?;
              logger.debug('👁️ [WebSocket] 收到消息已读确认: clientId=$clientMessageId, serverId=$serverMessageId');
              // 🔴 调用回调通知 ReliableMessageService
              if (clientMessageId != null && serverMessageId != null) {
                onMessageReadAck?.call(clientMessageId, serverMessageId);
              }
              // 通知 MessageQueueService 处理已读确认
              _messageController.add(message);
            }
            continue;
          }

          // 🔴 调试日志：打印所有收到的消息类型
          final msgType = message['type'] as String?;
          logger.debug('📨 [WebSocket] 收到消息类型: $msgType');

          // 通过流发送给监听器
          _messageController.add(message);
          logger.debug('📨 [WebSocket] 已转发消息到监听器: $msgType');
        } catch (e) {
          logger.error('❌ [WebSocket] 解析消息失败: $e');
        }
      }
    } catch (e) {
    }
  }

  // 判断是否是WebRTC信令消息
  bool _isWebRTCSignal(String type) {
    const webrtcTypes = [
      'offer',
      'answer',
      'ice-candidate',
      'call-request',
      'call-accepted',
      'call-rejected',
      'call-ended',
      'incoming_call', // 服务器发送的来电通知
      'incoming_group_call', // 服务器发送的群组来电通知
      'group_call_member_accepted', // 群组通话成员接听通知
      'group_call_member_left', // 群组通话成员离开通知
      'group_call_ended', // 🔴 群组通话结束通知（通知未接听成员关闭来电弹窗）
      'call_rejected', // 服务器发送的拒绝通知
      'call_ended', // 服务器发送的结束通知
    ];
    return webrtcTypes.contains(type);
  }

  // 处理错误
  void _onError(error) {
    final timestamp = DateTime.now().toString();
    _isConnected = false;
    _stopHeartbeat();  // 🔴 停止心跳检测
    logger.debug('❌ [WebSocket] 连接错误: $error, 时间: $timestamp');
    
    // 🔴 只有非主动断开时才重连
    if (!_intentionalDisconnect) {
      _scheduleReconnect();
    } else {
      logger.debug('🔄 [WebSocket] 主动断开，不重连');
    }
  }

  // 处理连接关闭
  void _onDone() {
    final timestamp = DateTime.now().toString();
    _isConnected = false;
    _stopHeartbeat();  // 🔴 停止心跳检测
    logger.debug('🔌 [WebSocket] 连接关闭, 时间: $timestamp');
    
    // 🔴 只有非主动断开时才重连
    if (!_intentionalDisconnect) {
      _scheduleReconnect();
    } else {
      logger.debug('🔄 [WebSocket] 主动断开，不重连');
    }
  }

  // ==================== 私聊消息发送 ====================
  
  /// 获取临时消息列表（供外部访问）
  Map<String, Map<String, dynamic>> getPendingPrivateMessages() {
    return Map.from(_pendingPrivateMessages);
  }

  /// 立即保存最近的临时消息到数据库
  /// 用于在收到 message_sent 确认后立即保存消息
  /// [receiverId] 接收者ID
  /// [serverMessageId] 服务器返回的消息ID（可选，如果提供则直接更新数据库中的消息状态）
  Future<void> saveRecentPendingMessage(int receiverId, {int? serverMessageId}) async {
    try {
      
      // 🔴 修复：如果提供了serverMessageId，直接通过localId查找并更新消息状态
      if (serverMessageId != null) {
        // 查找匹配的临时消息（通过receiverId查找最近的）
        String? targetKey;
        int? targetLocalId;
        DateTime? latestTime;
        
        for (final entry in _pendingPrivateMessages.entries) {
          final msg = entry.value;
          if (msg['receiverId'] == receiverId) {
            final createdAtStr = msg['created_at'] as String?;
            if (createdAtStr != null) {
              try {
                final createdAt = DateTime.parse(createdAtStr);
                if (latestTime == null || createdAt.isAfter(latestTime)) {
                  latestTime = createdAt;
                  targetKey = entry.key;
                  targetLocalId = msg['localId'] as int?;
                }
              } catch (e) {
              }
            }
          }
        }
        
        if (targetLocalId != null) {
          // 直接更新数据库中的消息状态
          final count = await _localDb.updateMessageStatusById(
            localId: targetLocalId,
            status: 'sent',
            serverId: serverMessageId,
          );
          if (count > 0) {
            if (targetKey != null) {
              _pendingPrivateMessages.remove(targetKey);
            }
          } else {
            // 🔴 备用方案：查找数据库中状态为sending的最近消息并更新
            await _updateSendingMessageByReceiverId(receiverId, serverMessageId);
          }
        } else {
          // 🔴 备用方案：查找数据库中状态为sending的最近消息并更新
          await _updateSendingMessageByReceiverId(receiverId, serverMessageId);
        }
        return;
      }
      
      // 原有逻辑：查找最近发送给该接收者的临时消息
      String? targetKey;
      DateTime? latestTime;
      
      for (final entry in _pendingPrivateMessages.entries) {
        final msg = entry.value;
        if (msg['receiverId'] == receiverId) {
          final createdAtStr = msg['created_at'] as String?;
          if (createdAtStr != null) {
            try {
              final createdAt = DateTime.parse(createdAtStr);
              if (latestTime == null || createdAt.isAfter(latestTime)) {
                latestTime = createdAt;
                targetKey = entry.key;
              }
            } catch (e) {
            }
          }
        }
      }
      
      if (targetKey != null && _pendingPrivateMessages.containsKey(targetKey)) {
        final finalMessage = Map<String, dynamic>.from(_pendingPrivateMessages[targetKey]!);
        
        // 🔴 移除不属于数据库表的字段
        finalMessage.remove('localId');
        finalMessage.remove('created_at');
        
        // 🔴 特殊处理：如果是通话拒绝消息，修改内容为"已拒绝"（自己看到的）
        final messageType = finalMessage['message_type'] as String?;
        if (messageType == 'call_rejected' || messageType == 'call_rejected_video') {
          finalMessage['content'] = '已拒绝';
        }
        
        await _localDb.insertMessage(finalMessage);
        _pendingPrivateMessages.remove(targetKey);
      } else {
      }
    } catch (e) {
      logger.error('❌ 保存临时消息失败: $e');
    }
  }
  
  /// 🔴 备用方案：查找数据库中状态为sending的最近消息并更新状态
  /// 当找不到临时消息时使用此方法
  Future<void> _updateSendingMessageByReceiverId(int receiverId, int? serverMessageId) async {
    try {
      final senderId = await Storage.getUserId();
      if (senderId == null) {
        return;
      }
      
      // 🔴 使用LocalDatabaseService的getMessages方法查找消息，然后筛选状态为sending的
      // 注意：getMessages返回的是双向消息，我们需要筛选出sender_id匹配且status为sending的
      final allMessages = await _localDb.getMessages(
        userId1: senderId,
        userId2: receiverId,
        limit: 50, // 只查询最近50条，应该足够找到sending状态的消息
      );
      
      // 筛选出状态为sending且sender_id匹配的消息，按created_at降序排列
      final sendingMessages = allMessages
          .where((msg) => 
              msg['sender_id'] == senderId && 
              msg['receiver_id'] == receiverId &&
              msg['status'] == 'sending')
          .toList();
      
      // 按created_at降序排序，取最近的一条
      sendingMessages.sort((a, b) {
        final aTime = a['created_at'] as String?;
        final bTime = b['created_at'] as String?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });
      
      if (sendingMessages.isNotEmpty) {
        final message = sendingMessages.first;
        final localId = message['id'] as int?;
        if (localId != null) {
          final count = await _localDb.updateMessageStatusById(
            localId: localId,
            status: 'sent',
            serverId: serverMessageId,
          );
          if (count > 0) {
          } else {
          }
        }
      } else {
      }
    } catch (e) {
      logger.error('❌ [备用方案] 更新消息状态失败: $e');
    }
  }
  
  /// 发送私聊消息
  /// 
  /// 🔴 已移除重试机制，服务器使用channel缓冲保证可靠性
  Future<bool> sendMessage({
    required int receiverId,
    required String content,
    String messageType = 'text',
    String? fileName,
    int? quotedMessageId,
    String? quotedMessageContent,
    String? callType,
    int? voiceDuration, // 语音消息时长（秒）
  }) async {
    // 🔵 阶段6：聊天消息已迁移到 Agora Chat，后端不再承载，因此后端 messages 表不再写入。
    // 此方法现存调用方仅剩【通话状态消息(call_*)】与【转发】，统一改走 Agora，不再经 WebSocket 落库。
    final userName = await Storage.getUsername() ?? '';
    final userAvatar = await Storage.getAvatar() ?? '';
    final sent = await AgoraChatService().sendText(
      toUserId: receiverId,
      content: content,
      ext: {
        AgoraChatService.extSenderName: userName,
        AgoraChatService.extSenderAvatar: userAvatar,
        AgoraChatService.extMessageType: messageType,
        if (fileName != null) AgoraChatService.extFileName: fileName,
        if (quotedMessageContent != null)
          AgoraChatService.extQuotedContent: quotedMessageContent,
        if (voiceDuration != null)
          AgoraChatService.extVoiceDuration: voiceDuration,
      },
    );
    return sent != null;
  }
  

  // ==================== 群组消息发送 ====================
  
  /// 发送群组消息
  /// 
  /// 🔴 已移除重试机制，服务器使用channel缓冲保证可靠性
  Future<bool> sendGroupMessage({
    required int groupId,
    required String content,
    String messageType = 'text',
    String? fileName,
    int? quotedMessageId,
    String? quotedMessageContent,
    List<int>? mentionedUserIds,
    String? mentions,
    String? callType,
    int? voiceDuration, // 语音消息时长（秒）
  }) async {
    // 🔵 阶段6：群聊消息已迁移到 Agora Chat。现存调用方仅剩【群通话状态消息】与【转发】，
    // 统一改走 Agora 群消息，不再写后端 group_messages 表。
    final agoraGid = AgoraChatService().agoraGroupIdFor(groupId);
    if (agoraGid == null || agoraGid.isEmpty) {
      logger.error('🌐 [WS->Agora] 群 $groupId 未登记 agora_group_id，无法发送群消息');
      return false;
    }
    final userName = await Storage.getUsername() ?? '';
    final userAvatar = await Storage.getAvatar() ?? '';
    final userFullName = await Storage.getFullName() ?? '';
    final sent = await AgoraChatService().sendGroupText(
      agoraGroupId: agoraGid,
      content: content,
      ext: {
        AgoraChatService.extSenderName: userName,
        AgoraChatService.extSenderAvatar: userAvatar,
        if (userFullName.isNotEmpty)
          AgoraChatService.extSenderFullName: userFullName,
        AgoraChatService.extMessageType: messageType,
        if (fileName != null) AgoraChatService.extFileName: fileName,
        if (quotedMessageContent != null)
          AgoraChatService.extQuotedContent: quotedMessageContent,
        if (mentionedUserIds != null && mentionedUserIds.isNotEmpty)
          AgoraChatService.extMentionedUserIds: mentionedUserIds,
        if (mentions != null && mentions.isNotEmpty)
          AgoraChatService.extMentions: mentions,
        if (voiceDuration != null)
          AgoraChatService.extVoiceDuration: voiceDuration,
      },
    );
    return sent != null;
  }
  

  // 发送状态变更
  Future<bool> sendStatusChange(String status) async {
    if (!_isConnected || _channel == null) {
      final connected = await connect();
      if (!connected) {
        return false;
      }
    }

    // 验证状态
    const validStatuses = ['online', 'busy', 'away', 'offline'];
    if (!validStatuses.contains(status)) {
      return false;
    }

    final message = {
      'type': 'status_change',
      'data': {'status': status},
    };

    try {
      _channel!.sink.add(jsonEncode(message));
      return true;
    } catch (e) {
      return false;
    }
  }

  // 🔴 心跳检测：每15秒发送一次ping消息保持连接
  // 每次tick先检查上一个ping是否收到了pong：没收到（或发送ping本身失败）
  // 即判定连接已断开 → 停止心跳定时器 → 进入重连循环
  // （5秒太激进：后台isolate会被系统冻结，Timer根本不跑；前台15秒足够检测掉线）
  void _startHeartbeat() {
    _stopHeartbeat();

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!_isConnected || _channel == null) {
        timer.cancel();
        return;
      }

      // 🔴 上一个ping在5秒内没有收到pong → 判定掉线
      if (_waitingForPong) {
        logger.debug('💔 [心跳] 上次ping未收到pong，判定连接已断开，停止心跳并进入重连');
        _handleHeartbeatFailure();
        return;
      }

      try {
        // 发送ping消息
        final pingMessage = {'type': 'ping'};
        _channel!.sink.add(jsonEncode(pingMessage));
        _waitingForPong = true;  // 等待pong，收到后由 _onMessage 置回false
        logger.debug('💓 [心跳] 发送ping消息');
      } catch (e) {
        logger.error('❌ [心跳] 发送ping失败，判定连接已断开: $e');
        _handleHeartbeatFailure();
      }
    });

    logger.debug('💓 [心跳] 已启动心跳定时器（15秒间隔）');
  }

  // 🔴 心跳失败处理：停止定时ping，清理连接，进入重连循环
  Future<void> _handleHeartbeatFailure() async {
    _stopHeartbeat();
    _isConnected = false;
    // 先取消订阅再关闭连接，避免触发 _onDone 重复进入重连
    await _cleanupOldConnection();

    if (!_intentionalDisconnect) {
      _scheduleReconnect();
    }
  }

  // 🔴 停止心跳检测
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _waitingForPong = false;
  }

  // 🔴 重连入口：启动重连循环（最多5次，每次间隔5秒）
  // 连续5次失败：移动端在页面顶部弹红色横幅"网络已断开，请检查网络"并停止自动重连；
  // PC端保留原有行为（连续5次失败自动退登）。
  void _scheduleReconnect() {
    // 🔴 如果被强制登出，永久禁止重连
    if (_isForcedLogout) {
      logger.debug('🚫 [WebSocket] 已被强制登出，禁止重连');
      return;
    }

    // 🔴 如果是主动断开，不重连
    if (_intentionalDisconnect) {
      logger.debug('🔄 [WebSocket] 主动断开，不重连');
      return;
    }

    // 🔴 重连循环已在运行，不重复启动（connect() 失败时会再次调用本方法）
    if (_isReconnectLoopRunning) {
      return;
    }

    _startReconnectLoop();
  }

  // 🔴 重连循环：最多尝试 _maxReconnectAttempts 次，指数退避 + 随机抖动
  // （固定间隔会让多个客户端/多个触发源在同一时刻挤在一起重连，加剧服务器压力和互踢）
  Future<void> _startReconnectLoop() async {
    _isReconnectLoopRunning = true;
    try {
      for (int attempt = 1; attempt <= _maxReconnectAttempts; attempt++) {
        // 每轮开始前检查是否已被强制登出/主动断开
        if (_isForcedLogout || _intentionalDisconnect) {
          logger.debug('🔄 [WebSocket] 重连循环退出（强制登出或主动断开）');
          return;
        }

        logger.debug('🔄 [WebSocket] 重连尝试 $attempt/$_maxReconnectAttempts...');

        final success = await connect();

        if (success) {
          logger.debug('═══════════════════════════════════════════════════════════');
          logger.debug('✅ [WebSocket] ========== WebSocket重连成功（第 $attempt 次尝试）==========');
          logger.debug('✅ [WebSocket] 触发数据同步回调 (onReconnected)');
          logger.debug('═══════════════════════════════════════════════════════════');
          // 连接成功时 connect() 内部已重启心跳并隐藏横幅
          onReconnected?.call();
          return;
        }

        // 🔴 失败后指数退避再试：2s → 4s → 8s → 16s → 上限30s，附加0~1s随机抖动
        if (attempt < _maxReconnectAttempts) {
          final backoffMs = (2000 * (1 << (attempt - 1))).clamp(2000, 30000);
          final delay = Duration(milliseconds: backoffMs + Random().nextInt(1000));
          logger.debug('🔄 [WebSocket] ${delay.inMilliseconds}ms 后进行下一次重连');
          await Future.delayed(delay);
        }
      }

      // 🔴 连续5次全部失败
      if (_isForcedLogout || _intentionalDisconnect) return;

      final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
      if (isDesktop) {
        // PC端保留原有行为：连续5次连接失败后自动退登
        logger.debug('🚫 [WebSocket] PC端连续$_maxReconnectAttempts次连接失败，触发自动退登');
        _isForcedLogout = true;
        _intentionalDisconnect = true;
        AuthStateService().handleTokenInvalid('当前账号已有设备登录，请重新登录');
      } else {
        // 移动端：页面顶部弹红色横幅提示，停止自动重连
        // （点击"重试"或 app 回前台/下拉刷新等路径调用 connect() 时会重新开始）
        logger.debug('🚫 [WebSocket] 连续$_maxReconnectAttempts次重连失败，显示网络断开提示');
        NetworkDisconnectedBanner.show(
          onRetry: () {
            logger.debug('🔄 [WebSocket] 用户点击横幅重试按钮，强制重连');
            forceReconnect();
          },
        );
      }
    } finally {
      _isReconnectLoopRunning = false;
    }
  }
  
  /// 🔴 强制重连（用于后台服务检测到断开时调用）
  /// 注意：不再无条件拆掉现有连接——如果已连接、或有连接正在建立中、
  /// 或重连循环正在运行，都直接复用/让路，避免并发建多条连接被服务器互踢
  Future<bool> forceReconnect() async {
    logger.debug('🔄 [WebSocket] 强制重连被调用');

    if (_isForcedLogout) {
      logger.debug('🚫 [WebSocket] 已被强制登出，禁止重连');
      return false;
    }

    _intentionalDisconnect = false;

    // 已连接：什么都不做
    if (_isConnected) {
      logger.debug('✅ [WebSocket] 当前已连接，无需强制重连');
      return true;
    }

    // 有连接正在建立中：等待同一个结果，不新开连接
    final inflight = _connectFuture;
    if (inflight != null) {
      logger.debug('🔄 [WebSocket] 已有连接正在建立中，等待其结果');
      return inflight;
    }

    // 重连循环正在运行：让循环自己重试，不插队
    if (_isReconnectLoopRunning) {
      logger.debug('🔄 [WebSocket] 重连循环正在运行，跳过强制重连');
      return false;
    }

    // 确实没有任何连接活动，清理残留后发起一次连接
    await _cleanupOldConnection();
    _isConnected = false;
    _stopHeartbeat();
    return await connect();
  }

  /// 🔴 统一的"确保连接"入口：
  /// 所有"检查一下连接、断了就重连"的调用方（生命周期resumed、后台watchdog、
  /// 网络状态回调等）都应该走这里，而不是各自直接 connect()/forceReconnect()。
  ///
  /// - 已连接：主动发一次ping探测，3秒内收到pong视为连接真实存活（应用从后台
  ///   恢复时 _isConnected 往往还是 true，但底层TCP早已被系统杀死）
  /// - 探测失败：清理死连接后走统一的 connect() 互斥入口
  /// - 有连接在建立中/重连循环在跑：复用/让路
  Future<bool> ensureConnected() async {
    if (_isForcedLogout) return false;

    // 已标记连接：发ping探测验证是否真的活着
    if (_isConnected && _channel != null) {
      try {
        final probe = Completer<void>();
        _pongProbe = probe;
        _channel!.sink.add(jsonEncode({'type': 'ping'}));
        logger.debug('🔎 [WebSocket] ensureConnected: 发送探测ping');
        await probe.future.timeout(const Duration(seconds: 3));
        _pongProbe = null;
        logger.debug('✅ [WebSocket] ensureConnected: 探测成功，连接存活');
        return true;
      } catch (e) {
        _pongProbe = null;
        logger.debug('💔 [WebSocket] ensureConnected: 探测失败（$e），连接已死，进入重连');
        _stopHeartbeat();
        await _cleanupOldConnection();
        _isConnected = false;
      }
    }

    _intentionalDisconnect = false;

    // 有连接正在建立中：等待同一个结果
    final inflight = _connectFuture;
    if (inflight != null) {
      logger.debug('🔄 [WebSocket] ensureConnected: 已有连接正在建立中，等待其结果');
      return inflight;
    }

    // 重连循环正在运行：让循环自己重试
    if (_isReconnectLoopRunning) {
      logger.debug('🔄 [WebSocket] ensureConnected: 重连循环正在运行，跳过');
      return false;
    }

    return connect();
  }

  // 断开连接
  Future<void> disconnect({bool sendOfflineStatus = false}) async {
    // 🔴 标记为主动断开，防止自动重连
    _intentionalDisconnect = true;
    
    // 如果需要发送离线状态，先发送再断开
    if (sendOfflineStatus && _isConnected && _channel != null) {
      try {
        await sendStatusChange('offline');
        // 等待一小段时间确保消息发送
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
      }
    }

    _stopHeartbeat();  // 🔴 停止心跳检测

    // 🔴 使用统一的清理方法
    await _cleanupOldConnection();

    _isConnected = false;
  }

  // 发送正在输入指示器
  Future<bool> sendTypingIndicator({
    required int receiverId,
    required bool isTyping,
  }) async {
    if (!_isConnected || _channel == null) {
      return false;
    }

    final message = {
      'type': 'typing_indicator',
      'data': {'receiver_id': receiverId, 'is_typing': isTyping},
    };

    try {
      _channel!.sink.add(jsonEncode(message));
      return true;
    } catch (e) {
      return false;
    }
  }

  // 发送WebRTC信令
  Future<bool> sendWebRTCSignal(Map<String, dynamic> data) async {
    if (!_isConnected || _channel == null) {
      final connected = await connect();
      if (!connected) {
        return false;
      }
    }

    final type = data['type'];
    final message = {'type': type, 'data': data};

    try {
      _channel!.sink.add(jsonEncode(message));
      return true;
    } catch (e) {
      return false;
    }
  }

  // 发送消息删除
  Future<bool> sendMessageDelete({
    required int messageId,
    required int userId,
    required bool isGroup,
  }) async {
    if (!_isConnected || _channel == null) {
      return false;
    }

    final message = {
      'type': 'message_delete',
      'data': {'messageId': messageId, 'userId': userId, 'isGroup': isGroup},
    };

    try {
      _channel!.sink.add(jsonEncode(message));
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== 可靠消息投递相关方法 ====================

  /// 发送原始消息（供 MessageQueueService 使用）
  /// 
  /// 直接发送 JSON 消息，不做额外处理
  void sendRaw(Map<String, dynamic> message) {
    if (!_isConnected || _channel == null) {
      logger.error('❌ [WebSocket] sendRaw 失败：未连接');
      return;
    }
    
    try {
      _channel!.sink.add(jsonEncode(message));
      logger.debug('📤 [WebSocket] sendRaw 成功: ${message['type']}');
    } catch (e) {
      logger.error('❌ [WebSocket] sendRaw 异常: $e');
    }
  }

  /// 发送送达确认（ACK）给服务器
  /// 
  /// 当客户端成功接收并保存消息后，发送此确认
  void sendDeliveryAck(int messageId, {String? clientMessageId, bool isGroup = false}) {
    if (!_isConnected || _channel == null) {
      logger.debug('⚠️ [WebSocket] 无法发送送达确认：未连接');
      return;
    }
    
    final ack = {
      'type': 'delivery_ack',
      'data': {
        'message_id': messageId,
        if (clientMessageId != null) 'client_message_id': clientMessageId,
        'is_group': isGroup,
      }
    };
    
    try {
      _channel!.sink.add(jsonEncode(ack));
      logger.debug('📬 [WebSocket] 发送送达确认: messageId=$messageId, isGroup=$isGroup');
    } catch (e) {
      logger.error('❌ [WebSocket] 发送送达确认失败: $e');
    }
  }

  /// 请求同步离线消息
  /// 
  /// 🔴 已废弃：不再使用此方法
  /// 现在统一使用服务器B的 check-sync API 方式同步离线消息
  /// 保留此方法仅为兼容性考虑，未来版本可能移除
  /// 
  /// @deprecated 使用 MessageSyncService.checkSyncImmediately() 代替
  @Deprecated('Use MessageSyncService.checkSyncImmediately() instead')
  // 保存群聊消息到本地数据库
  Future<void> _saveGroupMessageToLocal(
    Map<String, dynamic> messageData,
  ) async {
    try {
      // 🔴 客户端消息去重：根据服务器消息ID查询本地数据库，如果已存在则直接跳过
      final serverId = messageData['id'];
      if (serverId != null) {
        final existingMsg = await _localDb.getGroupMessageByServerId(serverId as int);
        if (existingMsg != null) {
          logger.debug('⏭️ [_saveGroupMessageToLocal] 群组消息已存在本地数据库，跳过处理 - server_id: $serverId');
          return;
        }
      }

      // 🔴 乐观更新：检查是否是自己发送的消息回传
      // 服务器会广播消息给群组所有成员（包括发送者）
      final currentUserId = await Storage.getUserId();
      final senderId = messageData['sender_id'];
      final messageType = messageData['message_type'] ?? 'text';
      
      // 🔴 系统消息和通话相关消息必须保存，因为这些是服务器生成的消息
      // 即使是自己发起的通话，也需要保存"XX发起了语音通话"消息
      final systemMessageTypes = [
        'system',
        'group_call_initiated',
        'group_video_call_initiated',
        'join_voice_button',
        'join_video_button',
        'call_ended',
        'call_ended_video',
      ];
      if (systemMessageTypes.contains(messageType)) {
        await _insertGroupMessageToLocal(messageData);
        return;
      }
      
      if (currentUserId != null && senderId == currentUserId) {
        
        final groupId = messageData['group_id'];
        final content = messageData['content'];
        final serverId = messageData['id'];
        
        // 🔴 关键：使用groupId+content查找临时存储中的localId
        final messageKey = '${groupId}_${content.hashCode}';
        final pendingMsg = _pendingGroupMessages[messageKey];
        
        if (pendingMsg != null) {
          final localId = pendingMsg['localId'] as int;
          
          // 🔴 根据localId更新消息状态和服务器ID
          final count = await _localDb.updateGroupMessageStatusById(
            localId: localId,
            status: 'sent',
            serverId: serverId,
          );
          
          if (count > 0) {
          }
          
          // 从临时存储移除
          _pendingGroupMessages.remove(messageKey);
        } else {
          // 如果没找到，可能是多端同步的消息，正常插入
          await _insertGroupMessageToLocal(messageData);
        }
        return;
      }
      
      // 其他人发送的消息，正常插入
      await _insertGroupMessageToLocal(messageData);
    } catch (e) {
    }
  }

  /// 🔴 检查是否应该跳过群组通话结束消息（数据库去重处理）
  /// 查找最近一次"XX发起了语音/视频通话"消息，检查从该消息到当前消息之间是否已存在"通话时长"消息
  Future<bool> _shouldSkipGroupCallEndedMessageInDb(int groupId, String content) async {
    try {
      // 通话发起消息类型
      final initiatedMessageTypes = ['group_call_initiated', 'group_video_call_initiated'];
      // 通话结束消息类型
      final endedMessageTypes = ['call_ended', 'call_ended_video'];
      
      // 从本地数据库查询该群组最近的消息（最多查询50条）
      // 注意：getGroupMessages 返回的消息是按时间正序排列的（旧消息在前，新消息在后）
      final messages = await _localDb.getGroupMessages(groupId: groupId, limit: 50);
      
      if (messages.isEmpty) {
        logger.debug('📞 [数据库去重检查] 群组 $groupId 没有历史消息，允许插入');
        return false;
      }
      
      
      // 按时间倒序查找最近一次"XX发起了语音/视频通话"消息
      // 因为 messages 是正序的，所以从后往前遍历
      int initiatedIndex = -1;
      for (int i = messages.length - 1; i >= 0; i--) {
        final msgType = messages[i]['message_type'] as String?;
        if (initiatedMessageTypes.contains(msgType)) {
          initiatedIndex = i;
          logger.debug('📞 [数据库去重检查] 找到通话发起消息，位置: $i, 内容: ${messages[i]['content']}');
          break;
        }
      }
      
      if (initiatedIndex == -1) {
        logger.debug('📞 [数据库去重检查] 未找到通话发起消息，允许插入');
        return false;
      }
      
      // 检查从通话发起消息到最新消息之间是否已存在"通话时长"消息
      // messages 是正序的，所以从 initiatedIndex+1 到末尾是通话发起后的消息
      for (int i = initiatedIndex + 1; i < messages.length; i++) {
        final msg = messages[i];
        final msgType = msg['message_type'] as String?;
        final msgContent = msg['content'] as String? ?? '';
        if (endedMessageTypes.contains(msgType) && msgContent.startsWith('通话时长')) {
          logger.debug('📞 [数据库去重检查] 已存在通话时长消息，位置: $i, 内容: $msgContent，跳过插入');
          return true;
        }
      }
      
      logger.debug('📞 [数据库去重检查] 未找到重复的通话时长消息，允许插入');
      return false;
    } catch (e) {
      logger.debug('📞 [数据库去重检查] 查询失败: $e，允许插入');
      return false;
    }
  }

  // 插入群聊消息到本地数据库（实际插入逻辑）
  Future<void> _insertGroupMessageToLocal(
    Map<String, dynamic> messageData,
  ) async {
    // 🔴 群组通话结束消息去重处理
    // 检查从最近一次"XX发起了语音/视频通话"消息到当前消息之间是否已存在"通话时长"消息
    final messageType = messageData['message_type'] as String?;
    final content = messageData['content'] as String? ?? '';
    final groupId = messageData['group_id'] as int?;
    
    if ((messageType == 'call_ended' || messageType == 'call_ended_video') && 
        content.startsWith('通话时长') && 
        groupId != null) {
      final shouldSkip = await _shouldSkipGroupCallEndedMessageInDb(groupId, content);
      if (shouldSkip) {
        logger.debug('📞 [数据库去重] 检测到重复的通话时长消息，跳过插入: groupId=$groupId, content=$content');
        return;
      }
    }
    
    // 处理mentioned_user_ids - 如果是List，转换为逗号分隔的字符串
    String? mentionedUserIdsStr;
    if (messageData['mentioned_user_ids'] != null) {
      if (messageData['mentioned_user_ids'] is List) {
        mentionedUserIdsStr = (messageData['mentioned_user_ids'] as List)
            .map((e) => e.toString())
            .join(',');
      } else {
        mentionedUserIdsStr = messageData['mentioned_user_ids'].toString();
      }
    }

    // 🔴 时区处理：服务器发送的是 UTC 时间，需要转换为上海时区
    String createdAtStr;
    if (messageData['created_at'] != null) {
      final originalTimeStr = messageData['created_at'].toString();

      final shanghaiTime = TimezoneHelper.parseToShanghaiTime(
        originalTimeStr,
        assumeUtc: true,
      );
      createdAtStr = shanghaiTime.toIso8601String().replaceAll('Z', '');
      
    } else {
      createdAtStr = TimezoneHelper.nowInShanghaiString();
    }

    // 构建消息数据
    final message = {
      'server_id': messageData['id'], // 保存服务器返回的消息ID
      'group_id': messageData['group_id'],
      'sender_id': messageData['sender_id'],
      'sender_name': messageData['sender_name'],
      'group_name': messageData['group_name'],
      'group_avatar': messageData['group_avatar'],
      'content': messageData['content'],
      'message_type': messageData['message_type'] ?? 'text',
      'file_name': messageData['file_name'],
      'quoted_message_id': messageData['quoted_message_id'],
      'quoted_message_content': messageData['quoted_message_content'],
      'status': messageData['status'] ?? 'normal',
      'created_at': createdAtStr, // 🔴 使用上海时区时间
      'sender_avatar': messageData['sender_avatar'],
      'mentioned_user_ids': mentionedUserIdsStr,
      'mentions': messageData['mentions'],
      'deleted_by_users': messageData['deleted_by_users'] ?? '',
      'call_type': messageData['call_type'],
      'channel_name': messageData['channel_name'],
      'voice_duration': messageData['voice_duration'], // 🔴 添加voice_duration字段
    };

    // 移除null值
    message.removeWhere((key, value) => value == null);
    

    // 🔍 调试：查看要保存的消息数据（特别是通话按钮消息）
    if (messageData['message_type'] == 'join_voice_button' || messageData['message_type'] == 'join_video_button') {
    }

    await _localDb.insertGroupMessage(message);
    
    // 显示通知
    await _showGroupMessageNotification(messageData);
  }

  // 显示群组消息通知
  Future<void> _showGroupMessageNotification(
    Map<String, dynamic> messageData,
  ) async {
    try {
      final groupId = messageData['group_id'];
      final senderId = messageData['sender_id'];
      final senderName = messageData['sender_name'] ?? '未知用户';
      final content = messageData['content'] ?? '';
      final messageType = messageData['message_type'] ?? 'text';
      final fileName = messageData['file_name'];
      final senderAvatar = messageData['sender_avatar'];
      final groupName = messageData['group_name'] ?? '群聊 $groupId';
      
      // 格式化消息内容
      final formattedContent = _notificationService.formatMessageContent(
        messageType,
        content,
        fileName,
      );
      
      // 🔴 检查应用是否在后台，如果在后台则显示原生弹窗（Android/iOS）
      final isAppInBackground = WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed;
      
      if ((Platform.isAndroid || Platform.isIOS) && isAppInBackground) {
        // 应用在后台，显示原生消息弹窗
        try {
          await NativeMessageService().showMessageOverlay(
            senderName: senderName,
            senderId: senderId,
            content: formattedContent,
            messageType: messageType,
            isGroupMessage: true,
            groupId: groupId,
            groupName: groupName,
            senderAvatar: senderAvatar,
          );
        } catch (e) {
          logger.debug('❌ [WebSocket] 显示原生群组消息弹窗失败: $e');
          // 失败时回退到普通通知
          await _notificationService.showGroupMessageNotification(
            id: groupId,
            groupName: groupName,
            senderName: senderName,
            message: formattedContent,
            payload: 'group:$groupId',
          );
        }
      }
      // 🔴 应用在前台时不显示任何通知，用户可以直接在聊天列表看到新消息
    } catch (e) {
      logger.error('显示群组消息通知失败: $e');
    }
  }

  // 处理群组昵称更新通知
  Future<void> _handleGroupNicknameUpdated(Map<String, dynamic> data) async {
    try {
      final groupId = data['group_id'] as int?;
      final userId = data['user_id'] as int?;
      final newNickname = data['new_nickname'] as String?;
      
      if (groupId == null || userId == null || newNickname == null) {
        return;
      }
      
      
      // 更新本地数据库中该用户在该群组的所有历史消息的昵称
      final updatedCount = await _localDb.updateGroupMemberNickname(
        groupId,
        userId,
        newNickname,
      );
      
    } catch (e) {
    }
  }

  // ==================== 消息错误处理 ====================
  
  /// 处理私聊消息发送错误
  Future<void> _handlePrivateMessageError(String errorType, String errorMessage) async {
    try {
      // 获取最后一条待处理的私聊消息
      if (_pendingPrivateMessages.isEmpty) {
        return;
      }
      
      // 获取最后一条消息
      final lastEntry = _pendingPrivateMessages.entries.last;
      final messageKey = lastEntry.key;
      final lastMessage = lastEntry.value;
      final localId = lastMessage['localId'] as int;
      final receiverId = lastMessage['receiverId'] as int;
      
      
      // 🔴 关键：使用localId更新状态
      final count = await _localDb.updateMessageStatusById(
        localId: localId,
        status: 'forbidden',
      );
      
      if (count > 0) {
      } else {
      }
      
      // 从待处理列表中移除
      _pendingPrivateMessages.remove(messageKey);
      
    } catch (e) {
      logger.error('❌ 处理私聊消息错误失败: $e');
    }
  }
  
  /// 处理群组消息发送错误
  Future<void> _handleGroupMessageError(String errorType) async {
    try {
      // 获取最后一条待处理的群组消息
      if (_pendingGroupMessages.isEmpty) {
        return;
      }
      
      // 获取最后一条消息
      final lastEntry = _pendingGroupMessages.entries.last;
      final messageKey = lastEntry.key;
      final lastMessage = lastEntry.value;
      final localId = lastMessage['localId'] as int;
      final groupId = lastMessage['groupId'] as int;
      
      
      // 🔴 关键：使用localId更新状态
      final count = await _localDb.updateGroupMessageStatusById(
        localId: localId,
        status: 'forbidden',
      );
      
      if (count > 0) {
      } else {
      }
      
      // 从待处理列表中移除
      _pendingGroupMessages.remove(messageKey);
      
    } catch (e) {
      logger.error('❌ 处理群组消息错误失败: $e');
    }
  }

  // 释放资源
  void dispose() {
    disconnect();
    _messageController.close();
  }
}
