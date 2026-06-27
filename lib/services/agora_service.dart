// 声网 Agora 通话服务（统一三端:Android/iOS/Windows/macOS/Linux）
//
// 本服务用 agora_rtc_engine 作为唯一音视频引擎，信令走服务端已就绪的
// REST(/api/call/*)+ WebSocket(incoming_call / incoming_group_call ...)。
//
// 设计要点:
// - Agora 频道内 uid 直接等于用户ID(服务端 uint32(userID))，因此远端 uid 即对方用户ID。
// - Token 全部来自服务端，客户端只持有 AgoraConfig.appId。
// - 公开 API（回调 / 方法 / getter）与旧适配层保持一致，使上层页面改动最小。

import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'api_service.dart';
import 'websocket_service.dart';
import '../config/agora_config.dart';
import '../utils/logger.dart';
import '../utils/storage.dart';

/// 通话状态
enum CallState { idle, calling, ringing, connected, ended }

/// 通话类型
enum CallType { voice, video }

/// 声网通话服务（单例）
class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  // ===== 引擎与连接 =====
  RtcEngine? _engine;
  final WebSocketService _wsService = WebSocketService();
  bool _initialized = false;
  bool _joined = false;

  // ===== 通话状态 =====
  CallState _callState = CallState.idle;
  CallType _callType = CallType.voice;
  int? _myUserId;
  int? _currentCallUserId;
  String? _currentChannelName;
  String? _currentToken;
  DateTime? _callStartTime;
  bool _isLocalHangup = false;
  final Set<int> _remoteUids = {};

  // ===== 群组通话状态 =====
  bool _isGroupCall = false;
  int? _currentGroupId;
  int? _lastGroupId;
  List<int>? _currentGroupCallUserIds;
  List<String>? _currentGroupCallDisplayNames;
  final Set<int> _connectedMemberIds = {};

  // ===== 上一次通话信息（兼容 UI） =====
  CallType? _lastCallType;
  int? _lastCallUserId;

  // ===== 待接来电信息（来自 WebSocket 信令） =====
  String? _pendingChannelName;
  String? _pendingToken;
  int? _pendingCallerId;
  CallType? _pendingCallType;
  int? _pendingGroupId;
  List<Map<String, dynamic>>? _pendingMembers;

  // ===== 最小化悬浮窗状态 =====
  bool _isMinimized = false;
  int? _minimizedCallUserId;
  String? _minimizedCallDisplayName;
  CallType? _minimizedCallType;
  bool _minimizedIsGroupCall = false;
  int? _minimizedGroupId;

  // ====================== 回调（与旧适配层一致） ======================
  Function(CallState)? onCallStateChanged;
  Function(int uid)? onRemoteUserJoined;
  Function(int uid)? onRemoteUserLeft;
  Function(String)? onError;
  Function(int userId, String displayName, CallType callType)? onIncomingCall;
  Function(int userId, String displayName, CallType callType,
      List<Map<String, dynamic>> members, int? groupId)? onIncomingGroupCall;
  Function()? onLocalVideoReady;
  Function(int uid)? onRemoteVideoReady;
  Function(int callDuration)? onCallEnded;
  Function(int uid, bool isMuted)? onRemoteVideoMuted;
  Function(int userId, String status, String? displayName)?
      onGroupCallMemberStatusChanged;
  Function(int targetUserId, CallType callType, bool isCaller)? onCallCancelled;
  Function(int callerUserId, CallType callType)? onCallRejectedByMe;
  Function(int roomId, List<int> userIds, List<String> displayNames,
      CallType callType, int? groupId)? onGroupCallRoomEntered;
  Function(int callerId, String callerIdStr, CallType callType, bool isGroupCall,
      List<String> calleeIdList)? onTUICallReceived;
  Function()? onCallConnecting;
  Function()? onCallConnected;
  Function(int groupId, CallType callType, int callDuration, String? callId)?
      onGroupCallLeftButContinuing;
  Function(int groupId, CallType callType, int callDuration, bool isLastMember)?
      onGroupCallHangup;
  Function(int callerId, CallType callType)? onCallBusyRejected;
  Function(String)? onUserSigExpired; // 兼容旧 UI，Agora 用 Token 过期回调触发

  // ====================== Getter（与旧适配层一致） ======================
  RtcEngine? get engine => _engine;
  bool get isDesktop => false; // 统一引擎后不再区分桌面/移动
  CallState get callState => _callState;
  CallType get callType => _callType;
  int? get currentCallUserId => _currentCallUserId;
  int? get myUserId => _myUserId;
  DateTime? get callStartTime => _callStartTime;
  int? get currentGroupId => _currentGroupId;
  int? get lastGroupId => _lastGroupId;
  CallType? get lastCallType => _lastCallType;
  int? get lastCallUserId => _lastCallUserId;
  bool get isCallMinimized => _isMinimized;
  bool get isMinimized => _isMinimized;
  bool get isMinimizedGroupCall => _minimizedIsGroupCall;
  int? get minimizedCallUserId => _minimizedCallUserId;
  String? get minimizedCallDisplayName => _minimizedCallDisplayName;
  CallType? get minimizedCallType => _minimizedCallType;
  bool get minimizedIsGroupCall => _minimizedIsGroupCall;
  int? get minimizedGroupId => _minimizedGroupId;
  List<int>? get currentGroupCallUserIds => _currentGroupCallUserIds;
  List<String>? get currentGroupCallDisplayNames => _currentGroupCallDisplayNames;
  List<int>? get minimizedGroupCallUserIds => _currentGroupCallUserIds;
  List<String>? get minimizedGroupCallDisplayNames => _currentGroupCallDisplayNames;
  Set<int>? get connectedMemberIds => _connectedMemberIds;
  Set<int> get remoteUids => _remoteUids;
  bool get isLocalHangup => _isLocalHangup;
  String? get currentChannelName => _currentChannelName;
  String? get currentToken => _currentToken;
  bool get isInGroupCall => _isGroupCall;

  // ====================== 初始化 ======================

  Future<void> initialize(int currentUserId) async {
    _myUserId = currentUserId;

    if (!_initialized) {
      if (AgoraConfig.appId.isEmpty) {
        logger.error('📞 [Agora] App ID 未配置，请在 AgoraConfig.appId 或 --dart-define 填入');
        onError?.call('Agora App ID 未配置');
        // 仍然注册信令，以便后续配置后可用；但引擎不可用
      } else {
        try {
          _engine = createAgoraRtcEngine();
          await _engine!.initialize(RtcEngineContext(
            appId: AgoraConfig.appId,
            channelProfile: ChannelProfileType.channelProfileCommunication,
          ));
          _registerEngineHandlers();
          await _engine!.enableAudio();
          _initialized = true;
          logger.debug('📞 [Agora] 引擎初始化完成，userId=$currentUserId');
        } catch (e) {
          logger.error('📞 [Agora] 引擎初始化失败: $e');
          onError?.call('通话引擎初始化失败: $e');
        }
      }
    }

    // 注册（或刷新）WebSocket 信令处理
    _wsService.onWebRTCSignal = _handleWebRTCSignal;
  }

  void _registerEngineHandlers() {
    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        _joined = true;
        logger.debug('📞 [Agora] 已加入频道 ${connection.channelId} uid=${connection.localUid}');
        onCallConnecting?.call();
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        logger.debug('📞 [Agora] 远端用户加入: $remoteUid');
        _remoteUids.add(remoteUid);
        _connectedMemberIds.add(remoteUid);
        onRemoteUserJoined?.call(remoteUid);
        onGroupCallMemberStatusChanged?.call(remoteUid, 'connected', null);
        // 通话接通（首位远端加入）
        if (_callState != CallState.connected) {
          _callStartTime = DateTime.now();
          _setState(CallState.connected);
          onCallConnected?.call();
        }
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        logger.debug('📞 [Agora] 远端用户离开: $remoteUid ($reason)');
        _remoteUids.remove(remoteUid);
        _connectedMemberIds.remove(remoteUid);
        onRemoteUserLeft?.call(remoteUid);
        onGroupCallMemberStatusChanged?.call(remoteUid, 'left', null);
        // 一对一:对方离开即结束
        if (!_isGroupCall && _remoteUids.isEmpty) {
          _finishCall(isLocalHangup: false);
        } else if (_isGroupCall && _remoteUids.isEmpty) {
          // 群组中所有人离开
          _finishCall(isLocalHangup: false);
        }
      },
      onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid,
          RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
        if (state == RemoteVideoState.remoteVideoStateStarting ||
            state == RemoteVideoState.remoteVideoStateDecoding) {
          onRemoteVideoReady?.call(remoteUid);
          onRemoteVideoMuted?.call(remoteUid, false);
        } else if (state == RemoteVideoState.remoteVideoStateStopped) {
          onRemoteVideoMuted?.call(remoteUid, true);
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logger.debug('📞 [Agora] 已离开频道');
        _joined = false;
      },
      onError: (ErrorCodeType err, String msg) {
        logger.error('📞 [Agora] 引擎错误: $err $msg');
        if (err == ErrorCodeType.errTokenExpired ||
            err == ErrorCodeType.errInvalidToken) {
          // 尝试刷新 Token
          _refreshToken();
          onUserSigExpired?.call('通话凭证已过期');
        } else {
          onError?.call('通话错误: $msg');
        }
      },
      onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        _refreshToken();
      },
    ));
  }

  // ====================== WebSocket 信令处理 ======================

  void _handleWebRTCSignal(Map<String, dynamic> data) async {
    final type = data['type']?.toString();
    logger.debug('📞 [Agora] 收到信令: $type');
    switch (type) {
      case 'incoming_call':
        _handleIncomingCall(data);
        break;
      case 'incoming_group_call':
        _handleIncomingGroupCall(data);
        break;
      case 'call_rejected':
        _handleCallRejected(data);
        break;
      case 'call_ended':
      case 'call-ended':
        _finishCall(isLocalHangup: false);
        break;
      case 'group_call_member_accepted':
        _handleGroupMemberAccepted(data);
        break;
      case 'group_call_member_left':
        _handleGroupMemberLeft(data);
        break;
      case 'group_call_ended':
        _handleGroupCallEnded(data);
        break;
      default:
        break;
    }
  }

  void _handleIncomingCall(Map<String, dynamic> data) {
    // 通话中:自动拒接并提示忙线
    if (_callState != CallState.idle) {
      final callerId = _asInt(data['caller_id']);
      final ct = _parseCallType(data['call_type']);
      onCallBusyRejected?.call(callerId, ct);
      return;
    }
    _pendingChannelName = data['channel_name']?.toString();
    _pendingToken = data['token']?.toString();
    _pendingCallerId = _asInt(data['caller_id']);
    _pendingCallType = _parseCallType(data['call_type']);
    _pendingGroupId = null;
    _pendingMembers = null;

    _isGroupCall = false;
    _callType = _pendingCallType!;
    _currentCallUserId = _pendingCallerId;
    _setState(CallState.ringing);

    final displayName =
        data['caller_display_name']?.toString() ?? data['caller_username']?.toString() ?? '未知';
    onIncomingCall?.call(_pendingCallerId!, displayName, _pendingCallType!);
  }

  void _handleIncomingGroupCall(Map<String, dynamic> data) {
    if (_callState != CallState.idle) {
      final callerId = _asInt(data['caller_id']);
      final ct = _parseCallType(data['call_type']);
      onCallBusyRejected?.call(callerId, ct);
      return;
    }
    _pendingChannelName = data['channel_name']?.toString();
    _pendingToken = data['token']?.toString();
    _pendingCallerId = _asInt(data['caller_id']);
    _pendingCallType = _parseCallType(data['call_type']);
    _pendingGroupId = data['group_id'] == null ? null : _asInt(data['group_id']);
    _pendingMembers = _parseMembers(data['members']);

    _isGroupCall = true;
    _callType = _pendingCallType!;
    _currentCallUserId = _pendingCallerId;
    _currentGroupId = _pendingGroupId;
    _lastGroupId = _pendingGroupId;
    _setState(CallState.ringing);

    final displayName =
        data['caller_display_name']?.toString() ?? data['caller_username']?.toString() ?? '未知';
    onIncomingGroupCall?.call(_pendingCallerId!, displayName, _pendingCallType!,
        _pendingMembers ?? [], _pendingGroupId);
  }

  void _handleCallRejected(Map<String, dynamic> data) {
    // 主叫方收到:被叫拒绝
    final calleeId = _asInt(data['callee_id']);
    onCallRejectedByMe?.call(calleeId, _callType);
    _finishCall(isLocalHangup: false);
  }

  void _handleGroupMemberAccepted(Map<String, dynamic> data) {
    final uid = _asInt(data['accepter_user_id']);
    final name = data['accepter_display_name']?.toString();
    onGroupCallMemberStatusChanged?.call(uid, 'connected', name);
  }

  void _handleGroupMemberLeft(Map<String, dynamic> data) {
    final uid = _asInt(data['left_user_id']);
    final name = data['left_display_name']?.toString();
    onGroupCallMemberStatusChanged?.call(uid, 'left', name);
  }

  void _handleGroupCallEnded(Map<String, dynamic> data) {
    final groupId = data['group_id'] == null ? null : _asInt(data['group_id']);
    final duration = _callStartTime == null
        ? 0
        : DateTime.now().difference(_callStartTime!).inSeconds;
    if (groupId != null) {
      onGroupCallHangup?.call(groupId, _callType, duration, true);
    }
    _finishCall(isLocalHangup: false);
  }

  // ====================== 发起通话 ======================

  Future<void> startVoiceCall(int targetUserId, String targetDisplayName) =>
      _startSingleCall(targetUserId, targetDisplayName, CallType.voice);

  Future<void> startVideoCall(int targetUserId, String targetDisplayName) =>
      _startSingleCall(targetUserId, targetDisplayName, CallType.video);

  Future<void> _startSingleCall(
      int targetUserId, String displayName, CallType type) async {
    if (_engine == null) {
      onError?.call('通话引擎未就绪');
      return;
    }
    try {
      final token = await Storage.getToken();
      if (token == null) {
        onError?.call('未登录');
        return;
      }
      _isGroupCall = false;
      _callType = type;
      _currentCallUserId = targetUserId;
      _lastCallType = type;
      _lastCallUserId = targetUserId;
      _isLocalHangup = false;
      _setState(CallState.calling);

      final resp = await ApiService.initiateCall(
        token: token,
        calleeId: targetUserId,
        callType: type == CallType.video ? 'video' : 'voice',
      );
      final channel = resp['channel_name']?.toString();
      final agoraToken = resp['token']?.toString();
      final uid = _asInt(resp['caller_uid']);
      if (channel == null || agoraToken == null) {
        onError?.call('发起通话失败:服务端未返回频道');
        _finishCall(isLocalHangup: true);
        return;
      }
      await _joinChannel(channel, agoraToken, uid, type == CallType.video);
    } catch (e) {
      logger.error('📞 [Agora] 发起通话失败: $e');
      onError?.call('发起通话失败: $e');
      _finishCall(isLocalHangup: true);
    }
  }

  Future<void> startGroupVoiceCall(
    List<int> userIds,
    List<String> displayNames, {
    int? groupId,
  }) =>
      _startGroupCall(userIds, displayNames, CallType.voice, groupId: groupId);

  Future<void> startGroupVideoCall(
    List<int> userIds,
    List<String> displayNames, {
    int? groupId,
  }) =>
      _startGroupCall(userIds, displayNames, CallType.video, groupId: groupId);

  Future<void> _startGroupCall(
    List<int> userIds,
    List<String> displayNames,
    CallType type, {
    int? groupId,
  }) async {
    if (_engine == null) {
      onError?.call('通话引擎未就绪');
      return;
    }
    try {
      final token = await Storage.getToken();
      if (token == null) {
        onError?.call('未登录');
        return;
      }
      _isGroupCall = true;
      _callType = type;
      _currentGroupId = groupId;
      _lastGroupId = groupId;
      _currentGroupCallUserIds = List<int>.from(userIds);
      _currentGroupCallDisplayNames = List<String>.from(displayNames);
      _lastCallType = type;
      _isLocalHangup = false;
      _setState(CallState.calling);

      final resp = await ApiService.initiateGroupCall(
        token: token,
        calleeIds: userIds,
        callType: type == CallType.video ? 'video' : 'voice',
        groupId: groupId,
      );
      final channel = resp['channel_name']?.toString();
      final agoraToken = resp['token']?.toString();
      final uid = _asInt(resp['caller_uid']);
      if (channel == null || agoraToken == null) {
        onError?.call('发起群组通话失败:服务端未返回频道');
        _finishCall(isLocalHangup: true);
        return;
      }
      await _joinChannel(channel, agoraToken, uid, type == CallType.video);
      onGroupCallRoomEntered?.call(
          0, userIds, displayNames, type, groupId);
    } catch (e) {
      logger.error('📞 [Agora] 发起群组通话失败: $e');
      onError?.call('发起群组通话失败: $e');
      _finishCall(isLocalHangup: true);
    }
  }

  /// 加入已存在的群组通话
  Future<void> joinGroupCall(
    List<int> userIds,
    List<String> displayNames,
    CallType callType, {
    int? groupId,
  }) async {
    if (_engine == null) {
      onError?.call('通话引擎未就绪');
      return;
    }
    try {
      final token = await Storage.getToken();
      if (token == null) return;
      _isGroupCall = true;
      _callType = callType;
      _currentGroupId = groupId;
      _currentGroupCallUserIds = List<int>.from(userIds);
      _currentGroupCallDisplayNames = List<String>.from(displayNames);
      _isLocalHangup = false;
      _setState(CallState.calling);

      // 通过群组状态查询拿到频道名，再用 accept_group / token 拿 token
      String? channel = _pendingChannelName;
      if ((channel == null || channel.isEmpty) && groupId != null) {
        final status =
            await ApiService.getGroupCallStatus(token: token, groupId: groupId);
        channel = status['channel_name']?.toString();
      }
      if (channel == null || channel.isEmpty) {
        onError?.call('加入通话失败:无频道');
        _finishCall(isLocalHangup: true);
        return;
      }
      await ApiService.acceptGroupCall(token: token, channelName: channel);
      final tk =
          await ApiService.refreshChannelToken(token: token, channelName: channel);
      final agoraToken = tk['token']?.toString() ?? _pendingToken;
      final uid = _asInt(tk['uid'] ?? _myUserId);
      if (agoraToken == null) {
        onError?.call('加入通话失败:无 Token');
        _finishCall(isLocalHangup: true);
        return;
      }
      await _joinChannel(channel, agoraToken, uid, callType == CallType.video);
    } catch (e) {
      logger.error('📞 [Agora] 加入群组通话失败: $e');
      onError?.call('加入通话失败: $e');
      _finishCall(isLocalHangup: true);
    }
  }

  // ====================== 接听 / 拒绝 / 结束 ======================

  Future<void> acceptCall() async {
    if (_engine == null) {
      onError?.call('通话引擎未就绪');
      return;
    }
    final channel = _pendingChannelName;
    if (channel == null) {
      logger.error('📞 [Agora] 无待接来电信息');
      return;
    }
    try {
      onCallConnecting?.call();
      final token = await Storage.getToken();
      String? agoraToken = _pendingToken;
      int uid = _myUserId ?? 0;

      if (token != null) {
        try {
          final resp = _isGroupCall
              ? await ApiService.acceptGroupCall(token: token, channelName: channel)
              : await ApiService.acceptCall(token: token, channelName: channel);
          if (resp['token'] != null) agoraToken = resp['token'].toString();
          if (resp['uid'] != null) uid = _asInt(resp['uid']);
        } catch (e) {
          logger.debug('📞 [Agora] accept REST 失败，回退使用信令 Token: $e');
        }
      }
      if (agoraToken == null) {
        onError?.call('接听失败:无 Token');
        return;
      }
      await _joinChannel(channel, agoraToken, uid,
          (_pendingCallType ?? _callType) == CallType.video);
    } catch (e) {
      logger.error('📞 [Agora] 接听失败: $e');
      onError?.call('接听失败: $e');
    }
  }

  Future<void> rejectCall() async {
    try {
      final token = await Storage.getToken();
      final channel = _pendingChannelName;
      final callerId = _pendingCallerId;
      if (token != null && channel != null && callerId != null) {
        await ApiService.rejectCall(
            token: token, channelName: channel, callerId: callerId);
      }
    } catch (e) {
      logger.debug('📞 [Agora] 拒绝通话(REST)失败: $e');
    }
    _isLocalHangup = true;
    _finishCall(isLocalHangup: true);
  }

  Future<void> endCall({bool isLocalHangup = true}) async {
    _isLocalHangup = isLocalHangup;
    try {
      final token = await Storage.getToken();
      final channel = _currentChannelName ?? _pendingChannelName;
      if (token != null && channel != null) {
        if (_isGroupCall) {
          await ApiService.leaveGroupCall(
            token: token,
            channelName: channel,
            groupId: _currentGroupId,
            callType: _callType == CallType.video ? 'video' : 'voice',
          );
        } else if (_currentCallUserId != null) {
          await ApiService.endCall(
              token: token, channelName: channel, peerId: _currentCallUserId!);
        }
      }
    } catch (e) {
      logger.debug('📞 [Agora] 结束通话(REST)失败: $e');
    }
    _finishCall(isLocalHangup: isLocalHangup);
  }

  /// 群组通话中单个成员离开（通话可能继续）
  Future<Map<String, dynamic>> leaveGroupCallOnly() async {
    try {
      final token = await Storage.getToken();
      final channel = _currentChannelName;
      if (token != null && channel != null) {
        final resp = await ApiService.leaveGroupCall(
          token: token,
          channelName: channel,
          groupId: _currentGroupId,
          callType: _callType == CallType.video ? 'video' : 'voice',
        );
        final isEnded = resp['is_call_ended'] == true ||
            (resp['data'] is Map && resp['data']['is_call_ended'] == true);
        final duration = _callStartTime == null
            ? 0
            : DateTime.now().difference(_callStartTime!).inSeconds;
        _finishCall(isLocalHangup: true);
        return {'callDuration': duration, 'isCallEnded': isEnded};
      }
    } catch (e) {
      logger.debug('📞 [Agora] 离开群组通话失败: $e');
    }
    _finishCall(isLocalHangup: true);
    return {'callDuration': 0, 'isCallEnded': true};
  }

  // ====================== 媒体控制 ======================

  /// 切换麦克风静音（mute=true 表示静音）
  Future<void> toggleMute(bool mute) async {
    await _engine?.muteLocalAudioStream(mute);
  }

  /// 开/关麦克风（enable=true 表示开启）
  Future<void> toggleMicrophone(bool enable) async {
    await _engine?.muteLocalAudioStream(!enable);
  }

  /// 静音/取消静音本地麦克风
  Future<void> muteMicrophone(bool mute) async {
    await _engine?.muteLocalAudioStream(mute);
  }

  /// 切换扬声器（enable=true 扬声器，false 听筒）
  Future<void> toggleSpeaker(bool enable) async {
    await _engine?.setEnableSpeakerphone(enable);
  }

  /// 开/关摄像头
  Future<void> toggleCamera(bool enable) async {
    await _engine?.enableLocalVideo(enable);
    await _engine?.muteLocalVideoStream(!enable);
  }

  /// 静音/取消静音本地视频
  Future<void> muteCamera(bool mute) async {
    await _engine?.muteLocalVideoStream(mute);
  }

  /// 切换前后摄像头
  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  // ====================== 设备管理（桌面） ======================

  Future<List<dynamic>> getMicrophoneDevices() async {
    try {
      return await _engine?.getAudioDeviceManager().enumerateRecordingDevices() ??
          [];
    } catch (_) {
      return [];
    }
  }

  Future<List<dynamic>> getSpeakerDevices() async {
    try {
      return await _engine?.getAudioDeviceManager().enumeratePlaybackDevices() ??
          [];
    } catch (_) {
      return [];
    }
  }

  Future<List<dynamic>> getCameraDevices() async {
    try {
      return await _engine?.getVideoDeviceManager().enumerateVideoDevices() ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> setMicrophoneDevice(String deviceId) async {
    try {
      await _engine?.getAudioDeviceManager().setRecordingDevice(deviceId);
    } catch (_) {}
  }

  Future<void> setSpeakerDevice(String deviceId) async {
    try {
      await _engine?.getAudioDeviceManager().setPlaybackDevice(deviceId);
    } catch (_) {}
  }

  Future<void> setCameraDevice(String deviceId) async {
    try {
      await _engine?.getVideoDeviceManager().setDevice(deviceId);
    } catch (_) {}
  }

  // ====================== 最小化状态 ======================

  void setMinimized({
    required bool isMinimized,
    int? callUserId,
    String? displayName,
    CallType? callType,
    bool isGroupCall = false,
    int? groupId,
  }) {
    _isMinimized = isMinimized;
    _minimizedCallUserId = callUserId;
    _minimizedCallDisplayName = displayName;
    _minimizedCallType = callType;
    _minimizedIsGroupCall = isGroupCall;
    _minimizedGroupId = groupId;
  }

  void clearMinimizedState() {
    _isMinimized = false;
    _minimizedCallUserId = null;
    _minimizedCallDisplayName = null;
    _minimizedCallType = null;
    _minimizedIsGroupCall = false;
    _minimizedGroupId = null;
  }

  void setCurrentGroupId(int? groupId) {
    _currentGroupId = groupId;
    if (groupId != null) _lastGroupId = groupId;
  }

  // ====================== 桌面端视频视图（统一后由 AgoraVideoView 接管，保留空实现） ======================

  Future<void> setLocalVideoView(int viewId) async {}
  Future<void> setRemoteVideoView(int userId, int viewId) async {}
  Future<void> stopRemoteVideoView(int userId) async {}

  // ====================== 用户信息 / 杂项（兼容旧 UI，多为无操作） ======================

  Future<void> setSelfInfo(String nickname, String avatar) async {}
  Future<void> updateUserAvatar(String avatar) async {}
  Future<void> setCallingBell(String assetName) async {}
  Future<void> enableMuteMode(bool enable) async {}
  Future<void> enableFloatWindow(bool enable) async {}
  Future<void> enableVirtualBackground(bool enable) async {}
  Future<void> reconfigureProxy() async {}
  Future<void> setMicrophoneVolume(int volume) async {}
  Future<void> setSpeakerVolume(int volume) async {}
  void setGroupCallChannel(String channelName, String token, List<int> userIds,
      List<String> displayNames) {}
  void setIncomingCallInfo({
    required int callerId,
    required String channelName,
    required String token,
    required CallType callType,
    int? groupId,
  }) {
    _pendingCallerId = callerId;
    _pendingChannelName = channelName;
    _pendingToken = token;
    _pendingCallType = callType;
    _pendingGroupId = groupId;
  }

  Future<void> inviteToGroupCall(
      List<int> userIds, List<String> displayNames) async {
    try {
      final token = await Storage.getToken();
      final channel = _currentChannelName;
      if (token != null && channel != null) {
        await ApiService.inviteToGroupCall(
          token: token,
          channelName: channel,
          calleeIds: userIds,
          callType: _callType == CallType.video ? 'video' : 'voice',
        );
      }
    } catch (e) {
      logger.debug('📞 [Agora] 邀请成员失败: $e');
    }
  }

  Future<void> logout() async {
    await _leaveAndReset();
    try {
      await _engine?.release();
    } catch (_) {}
    _engine = null;
    _initialized = false;
  }

  // ====================== 内部辅助 ======================

  Future<void> _joinChannel(
      String channel, String token, int uid, bool isVideo) async {
    _currentChannelName = channel;
    _currentToken = token;
    _remoteUids.clear();
    _connectedMemberIds.clear();

    if (isVideo) {
      await _engine!.enableVideo();
      await _engine!.startPreview();
      onLocalVideoReady?.call();
    } else {
      await _engine!.disableVideo();
    }

    await _engine!.joinChannel(
      token: token,
      channelId: channel,
      uid: uid,
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishMicrophoneTrack: true,
        publishCameraTrack: isVideo,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
    logger.debug('📞 [Agora] joinChannel $channel uid=$uid video=$isVideo');
  }

  Future<void> _refreshToken() async {
    try {
      final token = await Storage.getToken();
      final channel = _currentChannelName;
      if (token != null && channel != null) {
        final resp =
            await ApiService.refreshChannelToken(token: token, channelName: channel);
        final newToken = resp['token']?.toString();
        if (newToken != null) {
          _currentToken = newToken;
          await _engine?.renewToken(newToken);
          logger.debug('📞 [Agora] Token 已刷新');
        }
      }
    } catch (e) {
      logger.debug('📞 [Agora] 刷新 Token 失败: $e');
    }
  }

  /// 仅离开频道并清空通话状态，不调用 REST
  Future<void> _leaveAndReset() async {
    try {
      if (_joined) {
        await _engine?.leaveChannel();
      }
      await _engine?.stopPreview();
    } catch (_) {}
    _resetCallState();
  }

  /// 结束通话:离开频道 + 通知 UI
  void _finishCall({required bool isLocalHangup}) {
    if (_callState == CallState.ended || _callState == CallState.idle) {
      // 仍确保引擎离开频道
    }
    final duration = _callStartTime == null
        ? 0
        : DateTime.now().difference(_callStartTime!).inSeconds;
    _isLocalHangup = isLocalHangup;
    _setState(CallState.ended);
    // 离开频道
    () async {
      try {
        if (_joined) await _engine?.leaveChannel();
        await _engine?.stopPreview();
      } catch (_) {}
    }();
    onCallEnded?.call(duration);
    _resetCallState();
  }

  void _resetCallState() {
    _callState = CallState.idle;
    _isGroupCall = false;
    _currentCallUserId = null;
    _currentChannelName = null;
    _currentToken = null;
    _callStartTime = null;
    _currentGroupId = null;
    _currentGroupCallUserIds = null;
    _currentGroupCallDisplayNames = null;
    _remoteUids.clear();
    _connectedMemberIds.clear();
    _pendingChannelName = null;
    _pendingToken = null;
    _pendingCallerId = null;
    _pendingCallType = null;
    _pendingGroupId = null;
    _pendingMembers = null;
    _joined = false;
  }

  void _setState(CallState state) {
    _callState = state;
    onCallStateChanged?.call(state);
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  CallType _parseCallType(dynamic v) {
    return v?.toString() == 'video' ? CallType.video : CallType.voice;
  }

  List<Map<String, dynamic>> _parseMembers(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((m) => Map<String, dynamic>.from(m))
          .toList();
    }
    return [];
  }
}
