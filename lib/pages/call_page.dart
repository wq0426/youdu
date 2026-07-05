/// 声网 Agora 统一通话页面（Android/iOS/Windows/macOS/Linux）
///
/// 支持:一对一 / 群组 × 语音 / 视频。
/// 媒体引擎与信令统一由 AgoraService 提供;视频渲染用 AgoraVideoView。

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/agora_service.dart';
import '../utils/logger.dart';
import '../utils/storage.dart';
import '../utils/responsive_helper.dart';

/// 通话页面 - 支持单人和群组通话
class CallPage extends StatefulWidget {
  final int targetUserId;
  final String targetDisplayName;
  final bool isIncoming;
  final CallType callType;
  final String? targetAvatar;
  // 群组通话相关参数
  final List<int>? groupCallUserIds;
  final List<String>? groupCallDisplayNames;
  final List<String?>? groupCallAvatarUrls;
  final int? currentUserId;
  final int? groupId;
  final bool isJoiningExistingCall;
  final String? memberRole;
  // 🔴 恢复模式：从最小化悬浮球重新打开时为 true，不重新发起/加入通话，只重新绑定实时状态
  final bool isReattach;

  const CallPage({
    super.key,
    required this.targetUserId,
    required this.targetDisplayName,
    this.isIncoming = false,
    this.callType = CallType.voice,
    this.targetAvatar,
    this.groupCallUserIds,
    this.groupCallDisplayNames,
    this.groupCallAvatarUrls,
    this.currentUserId,
    this.groupId,
    this.isJoiningExistingCall = false,
    this.memberRole,
    this.isReattach = false,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final AgoraService _callService = AgoraService();
  AudioPlayer? _waitingPlayer;

  CallState _callState = CallState.idle;
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isCameraOn = true;
  int _callDuration = 0;
  bool _isClosing = false;
  bool _disposed = false;
  // 🔴 本地是否点了"拒绝"：pop 时返回 callRejected，由 home 页发送拒绝消息（只有拒绝方发送）
  bool _didReject = false;

  Timer? _durationTimer;
  String _statusText = '正在连接...';

  // 群组通话成员
  List<int> _currentGroupCallUserIds = [];
  List<String> _currentGroupCallDisplayNames = [];
  List<String?> _currentGroupCallAvatarUrls = [];
  final Set<int> _connectedMemberIds = {};

  // 视频视图缓存
  AgoraVideoView? _localVideoView;
  final Map<int, AgoraVideoView> _remoteVideoViews = {};

  String? _currentUserAvatarUrl;
  String? _targetAvatarUrl;

  bool get _isGroupCall =>
      widget.groupCallUserIds != null && widget.groupCallUserIds!.isNotEmpty;
  bool get _isVideoCall => widget.callType == CallType.video;

  @override
  void initState() {
    super.initState();
    logger.debug('📞 [CallPage] initState target=${widget.targetUserId} '
        'incoming=${widget.isIncoming} type=${widget.callType} group=$_isGroupCall');

    _targetAvatarUrl = widget.targetAvatar;
    if (widget.groupCallUserIds != null) {
      _currentGroupCallUserIds = List<int>.from(widget.groupCallUserIds!);
      _currentGroupCallDisplayNames =
          List<String>.from(widget.groupCallDisplayNames ?? []);
      _currentGroupCallAvatarUrls =
          List<String?>.from(widget.groupCallAvatarUrls ?? []);
    }

    _loadCurrentUserAvatar();
    _setupCallbacks();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_disposed) _startCall();
    });
  }

  Future<void> _loadCurrentUserAvatar() async {
    try {
      final avatar = await Storage.getAvatar();
      if (mounted) setState(() => _currentUserAvatarUrl = avatar);
    } catch (_) {}
  }

  void _setupCallbacks() {
    _callService.onCallStateChanged = (state) {
      if (_disposed || !mounted || _isClosing) return;
      logger.debug('📞 [CallPage] 状态变化: $state');
      switch (state) {
        case CallState.calling:
        case CallState.ringing:
          if (_callState != CallState.connected) _playWaitingSound();
          break;
        case CallState.connected:
          _stopSound();
          if (_durationTimer == null) _startDurationTimer();
          break;
        case CallState.ended:
          _stopSound();
          _handleCallEnded();
          return;
        case CallState.idle:
          break;
      }
      setState(() {
        _callState = state;
        _updateStatusText();
      });
    };

    _callService.onRemoteUserJoined = (uid) {
      if (_disposed || !mounted) return;
      logger.debug('📞 [CallPage] 远端加入: $uid');
      setState(() {
        _connectedMemberIds.add(uid);
        if (_isVideoCall) _ensureRemoteVideoView(uid);
      });
      if (_callState != CallState.connected) {
        _stopSound();
        setState(() {
          _callState = CallState.connected;
          _updateStatusText();
        });
        if (_durationTimer == null) _startDurationTimer();
      }
    };

    _callService.onRemoteUserLeft = (uid) {
      if (_disposed || !mounted) return;
      logger.debug('📞 [CallPage] 远端离开: $uid');
      setState(() {
        _connectedMemberIds.remove(uid);
        _remoteVideoViews.remove(uid);
      });
    };

    _callService.onRemoteVideoReady = (uid) {
      if (_disposed || !mounted) return;
      setState(() => _ensureRemoteVideoView(uid));
    };

    _callService.onError = (error) {
      if (_disposed || !mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    };

    _callService.onCallEnded = (duration) {
      logger.debug('📞 [CallPage] onCallEnded, 时长: $duration');
      _callDuration = duration;
      if (!_isClosing && mounted) _handleCallEnded();
    };
  }

  Future<void> _startCall() async {
    // 🔴 恢复模式（从最小化悬浮球重新打开）：不重新发起/加入通话，
    // 仅从 AgoraService 单例读取当前实时状态并重建 UI（回调已在 _setupCallbacks 中重新绑定）。
    if (widget.isReattach) {
      // 🔴 用接通时刻计算真实时长（含最小化期间流逝的时间）
      if (_connectedAt != null) {
        _callDuration = DateTime.now().difference(_connectedAt!).inSeconds;
      }
      setState(() {
        _callState = _callService.callState;
        _connectedMemberIds
          ..clear()
          ..addAll(_callService.remoteUids);
        if (_isVideoCall) {
          for (final uid in _callService.remoteUids) {
            _ensureRemoteVideoView(uid);
          }
        }
        _updateStatusText();
      });
      if (_isVideoCall) _prepareLocalVideo();
      if (_callState == CallState.connected && _durationTimer == null) {
        _startDurationTimer();
      }
      return;
    }

    // 🔴 全新通话开始：清空上一通可能残留的接通时刻
    _connectedAt = null;

    // 加入已存在的群组通话
    if (widget.isJoiningExistingCall && _isGroupCall) {
      setState(() {
        _callState = CallState.calling;
        _statusText = '正在加入通话...';
      });
      await _callService.joinGroupCall(
        widget.groupCallUserIds ?? [],
        widget.groupCallDisplayNames ?? [],
        widget.callType,
        groupId: widget.groupId,
      );
      _prepareLocalVideo();
      return;
    }

    if (widget.isIncoming) {
      // 来电:接听通常已在外部触发。若尚未加入频道，则在此接听。
      if (_callService.currentChannelName == null &&
          _callService.callState != CallState.connected) {
        await _callService.acceptCall();
      }
      setState(() {
        _callState = _callService.callState == CallState.connected
            ? CallState.connected
            : CallState.calling;
        _updateStatusText();
      });
      _prepareLocalVideo();
      if (_callState == CallState.connected && _durationTimer == null) {
        _startDurationTimer();
      }
      return;
    }

    // 去电
    setState(() {
      _callState = CallState.calling;
      _updateStatusText();
    });
    _playWaitingSound();
    try {
      if (_isGroupCall) {
        if (_isVideoCall) {
          await _callService.startGroupVideoCall(
            widget.groupCallUserIds!,
            widget.groupCallDisplayNames ?? [],
            groupId: widget.groupId,
          );
        } else {
          await _callService.startGroupVoiceCall(
            widget.groupCallUserIds!,
            widget.groupCallDisplayNames ?? [],
            groupId: widget.groupId,
          );
        }
      } else {
        if (_isVideoCall) {
          await _callService.startVideoCall(
              widget.targetUserId, widget.targetDisplayName);
        } else {
          await _callService.startVoiceCall(
              widget.targetUserId, widget.targetDisplayName);
        }
      }
      _prepareLocalVideo();
    } catch (e) {
      _showError('发起通话失败: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _prepareLocalVideo() {
    if (!_isVideoCall) return;
    final engine = _callService.engine;
    if (engine == null) return;
    try {
      final controller = VideoViewController(
        rtcEngine: engine,
        useAndroidSurfaceView: true,
        useFlutterTexture: false,
        canvas: const VideoCanvas(uid: 0),
      );
      if (mounted) {
        setState(() => _localVideoView = AgoraVideoView(controller: controller));
      }
    } catch (e) {
      logger.error('📞 [CallPage] 创建本地视频视图失败: $e');
    }
  }

  void _ensureRemoteVideoView(int uid) {
    if (!_isVideoCall || _remoteVideoViews.containsKey(uid)) return;
    final engine = _callService.engine;
    final channel = _callService.currentChannelName;
    if (engine == null || channel == null) return;
    try {
      final controller = VideoViewController.remote(
        rtcEngine: engine,
        useAndroidSurfaceView: true,
        useFlutterTexture: false,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: channel),
      );
      _remoteVideoViews[uid] = AgoraVideoView(controller: controller);
    } catch (e) {
      logger.error('📞 [CallPage] 创建远端视频视图失败: $e');
    }
  }

  void _updateStatusText() {
    switch (_callState) {
      case CallState.idle:
        _statusText = '准备中...';
        break;
      case CallState.calling:
        _statusText = widget.isJoiningExistingCall
            ? '正在加入通话...'
            : (widget.isIncoming ? '来电中...' : '正在呼叫...');
        break;
      case CallState.ringing:
        _statusText = widget.isIncoming ? '来电中...' : '对方响铃中...';
        break;
      case CallState.connected:
        _statusText = '通话中';
        break;
      case CallState.ended:
        _statusText = '通话结束';
        break;
    }
  }

  void _handleCallEnded() {
    if (_isClosing) return;
    _isClosing = true;
    _stopDurationTimer();
    _connectedAt = null; // 🔴 通话结束，清空接通时刻，避免影响下一通
    _removeMinimizedOverlay(); // 通话结束时移除可能残留的最小化悬浮球
    _stopSound();
    final isLastMember = _callService.remoteUids.isEmpty;
    if (mounted) {
      Navigator.of(context).pop({
        'callEnded': true,
        // 🔴 本地拒接时返回 callRejected，home 页据此发送拒绝消息（拒绝方发送）
        'callRejected': _didReject,
        'callType': widget.callType,
        'callDuration': _callDuration,
        'isLocalHangup': _callService.isLocalHangup,
        'isCallEnded': isLastMember,
        'isGroupCall': _isGroupCall,
      });
    }
  }

  void _startDurationTimer() {
    // 🔴 接通时刻只记录一次（恢复时不覆盖，保证时长连续）
    _connectedAt ??= DateTime.now();
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_disposed && _connectedAt != null) {
        setState(() {
          _callDuration = DateTime.now().difference(_connectedAt!).inSeconds;
        });
      }
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  Future<void> _playWaitingSound() async {
    if (_disposed || !mounted) return;
    // 🔴 已在播放则直接返回，避免重复创建播放器：
    // 旧实例被覆盖后无人引用，_stopSound 停不掉，导致接通/挂断后等待音仍在循环
    if (_waitingPlayer != null) return;
    final player = AudioPlayer();
    _waitingPlayer = player;
    try {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource('mp3/wait.mp3'));
      // 🔴 播放启动期间可能已被 _stopSound 停止（接通/挂断先到），此时立即停掉
      if (_waitingPlayer != player) {
        await player.stop();
        await player.dispose();
      }
    } catch (_) {}
  }

  Future<void> _stopSound() async {
    try {
      await _waitingPlayer?.stop();
      await _waitingPlayer?.dispose();
      _waitingPlayer = null;
    } catch (_) {}
  }

  Future<void> _acceptCall() async => _callService.acceptCall();

  Future<void> _rejectCall() async {
    _didReject = true;
    await _callService.rejectCall();
  }

  Future<void> _endCall() async {
    if (_callState == CallState.ringing && widget.isIncoming) {
      _didReject = true;
      await _callService.rejectCall();
    } else {
      await _callService.endCall(isLocalHangup: true);
    }
  }

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _callService.toggleMute(_isMuted);
  }

  Future<void> _toggleSpeaker() async {
    setState(() => _isSpeakerOn = !_isSpeakerOn);
    await _callService.toggleSpeaker(_isSpeakerOn);
  }

  Future<void> _toggleCamera() async {
    if (!_isVideoCall) return;
    setState(() => _isCameraOn = !_isCameraOn);
    await _callService.toggleCamera(_isCameraOn);
  }

  Future<void> _switchCamera() async {
    if (!_isVideoCall) return;
    await _callService.switchCamera();
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _disposed = true;
    _stopDurationTimer();
    _stopSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Scaffold(
      backgroundColor: _isVideoCall ? Colors.black : const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Stack(
          children: [
            if (_isVideoCall && _callState == CallState.connected)
              _buildVideoLayout()
            else
              _buildMainContent(isMobile),
            Positioned(
              left: 0,
              right: 0,
              bottom: isMobile ? 50 : 40,
              child: _buildControlButtons(isMobile),
            ),
            // 🔴 左上角返回箭头：点击最小化通话页（通话继续，显示悬浮球可恢复）
            Positioned(
              left: 8,
              top: 8,
              child: GestureDetector(
                onTap: _minimize,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- 最小化 / 恢复 ----------
  static OverlayEntry? _minimizedOverlay;
  // 🔴 通话接通时刻（静态，跨最小化/恢复保持）：时长 = now - _connectedAt，
  // 这样最小化期间流逝的时间也会被计入。
  static DateTime? _connectedAt;
  static Offset _minimizedPos = const Offset(16, 80);

  static void _removeMinimizedOverlay() {
    _minimizedOverlay?.remove();
    _minimizedOverlay = null;
  }

  /// 最小化通话页：pop 当前页（不结束通话），插入全局悬浮球，点击悬浮球可恢复。
  void _minimize() {
    if (_isClosing || _disposed) return;

    // 通话尚未真正建立（仅来电响铃/呼叫中且未连接）时也允许最小化，状态恢复时按实时状态展示。
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final overlay = Overlay.of(context, rootOverlay: true);

    // 时长基于静态接通时刻 _connectedAt 计算，最小化期间会继续累积，无需在此保存。

    // 捕获当前页面参数，用于恢复时以 reattach 模式重建
    final w = widget;

    // 最小化期间：通话结束则自动移除悬浮球
    _callService.onCallEnded = (_) => _removeMinimizedOverlay();
    _callService.onCallStateChanged = (state) {
      if (state == CallState.ended) _removeMinimizedOverlay();
    };

    _removeMinimizedOverlay();
    final entry = OverlayEntry(
      builder: (ctx) => _MinimizedCallButton(
        isVideo: _isVideoCall,
        onRestore: () {
          _removeMinimizedOverlay();
          rootNavigator.push(
            MaterialPageRoute(
              builder: (_) => CallPage(
                targetUserId: w.targetUserId,
                targetDisplayName: w.targetDisplayName,
                isIncoming: w.isIncoming,
                callType: w.callType,
                targetAvatar: w.targetAvatar,
                groupCallUserIds: w.groupCallUserIds,
                groupCallDisplayNames: w.groupCallDisplayNames,
                groupCallAvatarUrls: w.groupCallAvatarUrls,
                currentUserId: w.currentUserId,
                groupId: w.groupId,
                memberRole: w.memberRole,
                isReattach: true,
              ),
            ),
          );
        },
      ),
    );
    _minimizedOverlay = entry;
    overlay.insert(entry);

    // 关闭当前通话页（不结束通话）
    _isClosing = true;
    Navigator.of(context).pop();
  }

  // ---------- 视频布局 ----------
  Widget _buildVideoLayout() {
    if (_isGroupCall) return _buildGroupVideoGrid();
    // 一对一:远端全屏 + 本地小窗
    final remoteUid =
        _remoteVideoViews.keys.isNotEmpty ? _remoteVideoViews.keys.first : null;
    return Stack(
      children: [
        Positioned.fill(
          child: remoteUid != null
              ? _remoteVideoViews[remoteUid]!
              : Container(color: Colors.black),
        ),
        if (_localVideoView != null)
          Positioned(
            right: 16,
            top: 16,
            width: 110,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _localVideoView!,
            ),
          ),
      ],
    );
  }

  Widget _buildGroupVideoGrid() {
    final tiles = <Widget>[];
    if (_localVideoView != null) {
      tiles.add(_videoTile(_localVideoView!, '我'));
    }
    _remoteVideoViews.forEach((uid, view) {
      tiles.add(_videoTile(view, _nameForUid(uid)));
    });
    if (tiles.isEmpty) {
      return Container(color: Colors.black);
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: tiles.length <= 2 ? 1 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: tiles,
      ),
    );
  }

  Widget _videoTile(Widget view, String label) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(8), child: view),
        Positioned(
          left: 6,
          bottom: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            color: Colors.black54,
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  String _nameForUid(int uid) {
    final idx = _currentGroupCallUserIds.indexOf(uid);
    if (idx >= 0 && idx < _currentGroupCallDisplayNames.length) {
      return _currentGroupCallDisplayNames[idx];
    }
    return '用户$uid';
  }

  // ---------- 语音 / 等待 UI ----------
  Widget _buildMainContent(bool isMobile) {
    return _isGroupCall
        ? _buildGroupCallContent(isMobile)
        : _buildSingleCallContent(isMobile);
  }

  Widget _buildSingleCallContent(bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatar(_targetAvatarUrl, widget.targetDisplayName,
              isMobile ? 120 : 100),
          const SizedBox(height: 24),
          Text(widget.targetDisplayName,
              style: TextStyle(
                  fontSize: isMobile ? 28 : 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            _callState == CallState.connected
                ? _formatDuration(_callDuration)
                : _statusText,
            style: TextStyle(
                fontSize: isMobile ? 18 : 16,
                color: Colors.white.withOpacity(0.7)),
          ),
          if (_isVideoCall) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam,
                    color: Colors.white.withOpacity(0.5), size: 20),
                const SizedBox(width: 4),
                Text('视频通话',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 14)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGroupCallContent(bool isMobile) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Text('群组${_isVideoCall ? '视频' : '语音'}通话',
            style: TextStyle(
                fontSize: isMobile ? 24 : 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          _callState == CallState.connected
              ? _formatDuration(_callDuration)
              : _statusText,
          style: TextStyle(
              fontSize: isMobile ? 18 : 16,
              color: Colors.white.withOpacity(0.7)),
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildMembersList(isMobile)),
      ],
    );
  }

  Widget _buildMembersList(bool isMobile) {
    final members = _currentGroupCallUserIds;
    final names = _currentGroupCallDisplayNames;
    final avatars = _currentGroupCallAvatarUrls;
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 3 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final userId = members[index];
        final name = index < names.length ? names[index] : '用户$userId';
        final avatar = index < avatars.length ? avatars[index] : null;
        final isMe = userId == widget.currentUserId;
        final isConnected = _connectedMemberIds.contains(userId) || isMe;
        return _buildMemberItem(
          userId: userId,
          name: name,
          avatar: avatar,
          isConnected: isConnected,
          isMe: isMe,
          isMobile: isMobile,
        );
      },
    );
  }

  Widget _buildMemberItem({
    required int userId,
    required String name,
    String? avatar,
    required bool isConnected,
    required bool isMe,
    required bool isMobile,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            _buildAvatar(isMe ? _currentUserAvatarUrl : avatar, name,
                isMobile ? 60 : 50),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isConnected ? Colors.green : Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(isMe ? '我' : name,
            style: TextStyle(
                color: Colors.white, fontSize: isMobile ? 14 : 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        Text(isConnected ? '已连接' : '等待中...',
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isMobile ? 12 : 10)),
      ],
    );
  }

  Widget _buildAvatar(String? avatarUrl, String name, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[700],
        image: avatarUrl != null && avatarUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(avatarUrl),
                fit: BoxFit.cover,
                onError: (_, __) {})
            : null,
      ),
      child: avatarUrl == null || avatarUrl.isEmpty
          ? Center(
              child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.bold)))
          : null,
    );
  }

  Widget _buildControlButtons(bool isMobile) {
    if (_callState == CallState.ringing && widget.isIncoming) {
      return _buildIncomingCallButtons(isMobile);
    }
    return _buildCallControlButtons(isMobile);
  }

  Widget _buildIncomingCallButtons(bool isMobile) {
    final size = isMobile ? 70.0 : 60.0;
    final iconSize = isMobile ? 32.0 : 28.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircleButton(
            onTap: _rejectCall,
            color: Colors.red,
            icon: Icons.call_end,
            label: '拒绝',
            size: size,
            iconSize: iconSize),
        _buildCircleButton(
            onTap: _acceptCall,
            color: Colors.green,
            icon: Icons.call,
            label: '接听',
            size: size,
            iconSize: iconSize),
      ],
    );
  }

  Widget _buildCallControlButtons(bool isMobile) {
    final size = isMobile ? 56.0 : 48.0;
    final iconSize = isMobile ? 26.0 : 22.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircleButton(
            onTap: _toggleMute,
            color: _isMuted ? Colors.red : Colors.white.withOpacity(0.2),
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            label: _isMuted ? '取消静音' : '静音',
            size: size,
            iconSize: iconSize),
        _buildCircleButton(
            onTap: _toggleSpeaker,
            color: _isSpeakerOn ? Colors.blue : Colors.white.withOpacity(0.2),
            icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
            label: _isSpeakerOn ? '扬声器' : '听筒',
            size: size,
            iconSize: iconSize),
        if (_isVideoCall) ...[
          _buildCircleButton(
              onTap: _toggleCamera,
              color: _isCameraOn ? Colors.blue : Colors.white.withOpacity(0.2),
              icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
              label: _isCameraOn ? '关闭摄像头' : '开启摄像头',
              size: size,
              iconSize: iconSize),
          _buildCircleButton(
              onTap: _switchCamera,
              color: Colors.white.withOpacity(0.2),
              icon: Icons.cameraswitch,
              label: '切换摄像头',
              size: size,
              iconSize: iconSize),
        ],
        _buildCircleButton(
            onTap: _endCall,
            color: Colors.red,
            icon: Icons.call_end,
            label: '挂断',
            size: size + 8,
            iconSize: iconSize + 4),
      ],
    );
  }

  Widget _buildCircleButton({
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
    required String label,
    required double size,
    required double iconSize,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
      ],
    );
  }
}

/// 兼容旧代码的别名
typedef VoiceCallPage = CallPage;
typedef GroupVideoCallPage = CallPage;

/// 根据参数返回通话页面 Widget（统一 Agora 实现，全平台一致）
Widget buildCallPage({
  required int targetUserId,
  required String targetDisplayName,
  bool isIncoming = false,
  CallType callType = CallType.voice,
  String? targetAvatar,
  List<int>? groupCallUserIds,
  List<String>? groupCallDisplayNames,
  List<String?>? groupCallAvatarUrls,
  int? currentUserId,
  int? groupId,
  bool isJoiningExistingCall = false,
  String? memberRole,
}) {
  return CallPage(
    targetUserId: targetUserId,
    targetDisplayName: targetDisplayName,
    isIncoming: isIncoming,
    callType: callType,
    targetAvatar: targetAvatar,
    groupCallUserIds: groupCallUserIds,
    groupCallDisplayNames: groupCallDisplayNames,
    groupCallAvatarUrls: groupCallAvatarUrls,
    currentUserId: currentUserId,
    groupId: groupId,
    isJoiningExistingCall: isJoiningExistingCall,
    memberRole: memberRole,
  );
}

/// 显示通话页面的便捷方法
Future<Map<String, dynamic>?> showCallPage(
  BuildContext context, {
  required int targetUserId,
  required String targetDisplayName,
  bool isIncoming = false,
  CallType callType = CallType.voice,
  String? targetAvatar,
  List<int>? groupCallUserIds,
  List<String>? groupCallDisplayNames,
  List<String?>? groupCallAvatarUrls,
  int? currentUserId,
  int? groupId,
  bool isJoiningExistingCall = false,
  String? memberRole,
  bool useDialog = false,
}) async {
  final page = buildCallPage(
    targetUserId: targetUserId,
    targetDisplayName: targetDisplayName,
    isIncoming: isIncoming,
    callType: callType,
    targetAvatar: targetAvatar,
    groupCallUserIds: groupCallUserIds,
    groupCallDisplayNames: groupCallDisplayNames,
    groupCallAvatarUrls: groupCallAvatarUrls,
    currentUserId: currentUserId,
    groupId: groupId,
    isJoiningExistingCall: isJoiningExistingCall,
    memberRole: memberRole,
  );
  if (useDialog) {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => page,
    );
  }
  return await Navigator.of(context)
      .push<Map<String, dynamic>>(MaterialPageRoute(builder: (context) => page));
}

/// 最小化后的通话悬浮球：可拖动，点击恢复通话页面。
class _MinimizedCallButton extends StatefulWidget {
  final bool isVideo;
  final VoidCallback onRestore;

  const _MinimizedCallButton({required this.isVideo, required this.onRestore});

  @override
  State<_MinimizedCallButton> createState() => _MinimizedCallButtonState();
}

class _MinimizedCallButtonState extends State<_MinimizedCallButton> {
  Offset _pos = _CallPageState._minimizedPos;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const btn = 64.0;
    return Positioned(
      left: _pos.dx,
      top: _pos.dy,
      child: GestureDetector(
        onTap: widget.onRestore,
        onPanUpdate: (d) {
          setState(() {
            _pos = Offset(
              (_pos.dx + d.delta.dx).clamp(0.0, size.width - btn),
              (_pos.dy + d.delta.dy).clamp(0.0, size.height - btn),
            );
            _CallPageState._minimizedPos = _pos;
          });
        },
        child: Container(
          width: btn,
          height: btn,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Icon(
            widget.isVideo ? Icons.videocam : Icons.phone_in_talk,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
