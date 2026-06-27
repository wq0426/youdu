/// 桌面端一对一通话页(兼容封装)
///
/// 统一 Agora 迁移后,桌面与移动共用同一套 CallPage 实现。
/// 本类仅保留原有构造器签名,内部委托给统一的 CallPage,
/// 以便 home_page.dart 等现有调用方无需改动。

import 'package:flutter/material.dart';
import '../services/agora_service.dart' show CallType;
import 'call_page.dart';

class DesktopCallPage extends StatelessWidget {
  final int targetUserId;
  final String targetDisplayName;
  final String? targetAvatar;
  final bool isIncoming;
  final bool isVideoCall;

  const DesktopCallPage({
    super.key,
    required this.targetUserId,
    required this.targetDisplayName,
    this.targetAvatar,
    this.isIncoming = false,
    this.isVideoCall = false,
  });

  @override
  Widget build(BuildContext context) {
    return CallPage(
      targetUserId: targetUserId,
      targetDisplayName: targetDisplayName,
      targetAvatar: targetAvatar,
      isIncoming: isIncoming,
      callType: isVideoCall ? CallType.video : CallType.voice,
    );
  }
}
