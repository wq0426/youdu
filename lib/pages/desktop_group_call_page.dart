/// 桌面端群组通话页(兼容封装)
///
/// 统一 Agora 迁移后,桌面群组通话复用统一的 CallPage(群组模式)。
/// 本类仅保留原有构造器签名,内部委托给 CallPage,
/// 以便 home_page.dart 等现有调用方无需改动。

import 'package:flutter/material.dart';
import '../services/agora_service.dart' show CallType, AgoraService;
import 'call_page.dart';

/// 群组成员(兼容旧签名,迁移后仅用于构造参数占位)
class DesktopGroupCallMember {
  final int userId;
  final String displayName;
  final String? avatarUrl;
  final bool isConnected;

  DesktopGroupCallMember({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.isConnected = false,
  });
}

class DesktopGroupCallPage extends StatelessWidget {
  final List<int> userIds;
  final List<String> displayNames;
  final List<String?>? avatarUrls;
  final int? groupId;
  final bool isVideoCall;
  final int currentUserId;
  final String currentUserName;
  final String? currentUserAvatar;

  // 从最小化恢复时的状态(兼容保留)
  final bool isRestoring;
  final int? restoredCallDuration;
  final bool? restoredHasAnyoneConnected;
  final List<DesktopGroupCallMember>? restoredMembers;

  const DesktopGroupCallPage({
    super.key,
    required this.userIds,
    required this.displayNames,
    this.avatarUrls,
    this.groupId,
    this.isVideoCall = false,
    required this.currentUserId,
    required this.currentUserName,
    this.currentUserAvatar,
    this.isRestoring = false,
    this.restoredCallDuration,
    this.restoredHasAnyoneConnected,
    this.restoredMembers,
  });

  @override
  Widget build(BuildContext context) {
    // 若已处于通话频道(来电接听后已加入),则按"已接听"渲染,避免重复发起;
    // 否则视为主叫,发起群组通话。
    final alreadyInCall = AgoraService().currentChannelName != null;
    final firstTarget = userIds.isNotEmpty ? userIds.first : currentUserId;
    final firstName = displayNames.isNotEmpty ? displayNames.first : '';

    return CallPage(
      targetUserId: firstTarget,
      targetDisplayName: firstName,
      isIncoming: alreadyInCall,
      callType: isVideoCall ? CallType.video : CallType.voice,
      groupCallUserIds: userIds,
      groupCallDisplayNames: displayNames,
      groupCallAvatarUrls: avatarUrls,
      currentUserId: currentUserId,
      groupId: groupId,
    );
  }
}
