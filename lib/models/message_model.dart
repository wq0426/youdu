import '../utils/timezone_helper.dart';
import '../utils/logger.dart';

/// 消息模型
class MessageModel {
  final int id; // 本地数据库ID（Agora 消息用 msgId 的稳定哈希派生，保证列表 key 唯一）
  final int? serverId; // 服务器返回的消息ID（用于引用消息时使用）
  final String? agoraMsgId; // Agora Chat 消息ID（撤回/已读/引用等操作以此为准）
  final int senderId;
  final int receiverId;
  final String senderName;
  final String receiverName;
  final String? senderAvatar; // 发送者头像URL
  final String? receiverAvatar; // 接收者头像URL
  final String? senderNickname; // 发送者在群组中的昵称（仅群组消息）
  final String? senderFullName; // 发送者昵称（full_name）
  final String? receiverFullName; // 接收者昵称（full_name）
  final String content;
  final String messageType;
  final String? fileName; // 文件名（用于file类型消息）
  final int? quotedMessageId; // 被引用的消息ID
  final String? quotedMessageContent; // 被引用的消息内容
  final String? status; // 消息状态（sent/recalled等）
  final List<int>? mentionedUserIds; // 被@的用户ID列表（群聊专用）
  final String? mentions; // 被@的用户信息（格式："@all" 或 "@fullname(username)"）
  final String? callType; // 通话类型（voice/video，仅通话类型消息使用）
  final String? channelName; // 通话频道名称（用于加入群组通话）
  final int? voiceDuration; // 语音消息时长（秒）
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final double? uploadProgress; // 上传进度（0.0-1.0）

  MessageModel({
    required this.id,
    this.serverId,
    this.agoraMsgId,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    this.senderAvatar,
    this.receiverAvatar,
    this.senderNickname,
    this.senderFullName,
    this.receiverFullName,
    required this.content,
    required this.messageType,
    this.fileName,
    this.quotedMessageId,
    this.quotedMessageContent,
    this.status,
    this.mentionedUserIds,
    this.mentions,
    this.callType,
    this.channelName,
    this.voiceDuration,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    this.uploadProgress,
  });

  /// 从 JSON 创建模型
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final logger = Logger();
    
    // 🔴 添加详细日志：记录所有消息的时间解析
    final content = json['content']?.toString() ?? '';
    final messageId = json['id'];
    final createdAtRaw = json['created_at'];
    
    // 处理 mentioned_user_ids，可能是字符串（逗号分隔）或列表
    List<int>? mentionedUserIds;
    final mentionedUserIdsJson = json['mentioned_user_ids'];
    if (mentionedUserIdsJson != null) {
      if (mentionedUserIdsJson is String) {
        // 如果是字符串，按逗号分隔并转换为整数列表
        if (mentionedUserIdsJson.isNotEmpty) {
          mentionedUserIds = mentionedUserIdsJson
              .split(',')
              .where((s) => s.trim().isNotEmpty)
              .map((s) => int.parse(s.trim()))
              .toList();
        }
      } else if (mentionedUserIdsJson is List) {
        // 如果已经是列表，直接转换
        mentionedUserIds = mentionedUserIdsJson.map((e) => e as int).toList();
      }
    }

    // 安全获取int类型字段
    final id = json['id'] is int 
        ? json['id'] as int 
        : int.tryParse(json['id']?.toString() ?? '') ?? 0;
    
    final senderId = json['sender_id'] is int
        ? json['sender_id'] as int
        : int.tryParse(json['sender_id']?.toString() ?? '') ?? 0;
    
    // 处理 receiverId：群组消息使用 group_id，私聊消息使用 receiver_id
    int receiverId = 0;
    if (json['receiver_id'] != null) {
      receiverId = json['receiver_id'] is int
          ? json['receiver_id'] as int
          : int.tryParse(json['receiver_id']?.toString() ?? '') ?? 0;
    } else if (json['group_id'] != null) {
      receiverId = json['group_id'] is int
          ? json['group_id'] as int
          : int.tryParse(json['group_id']?.toString() ?? '') ?? 0;
    }

    // 🔍 添加详细日志，显示昵称相关字段
    final senderName = json['sender_name'] as String? ?? '';
    final senderNickname = json['sender_nickname'] as String?;
    final senderFullName = json['sender_full_name'] as String?;
    final groupId = json['group_id'];
    
    final serverId = json['server_id'] != null
        ? (json['server_id'] is int
            ? json['server_id'] as int
            : int.tryParse(json['server_id']?.toString() ?? ''))
        : null;
    
    final quotedMessageId = json['quoted_message_id'] != null
        ? (json['quoted_message_id'] is int
            ? json['quoted_message_id'] as int
            : int.tryParse(json['quoted_message_id']?.toString() ?? ''))
        : null;
    

    // 解析语音时长
    final voiceDuration = json['voice_duration'] != null
        ? (json['voice_duration'] is int
            ? json['voice_duration'] as int
            : int.tryParse(json['voice_duration']?.toString() ?? ''))
        : null;
    
    return MessageModel(
      id: id,
      serverId: serverId,
      agoraMsgId: json['agora_msg_id'] as String?,
      senderId: senderId,
      receiverId: receiverId,
      senderName: senderName,
      receiverName: json['receiver_name'] as String? ?? '',
      senderAvatar: json['sender_avatar'] as String?,
      receiverAvatar: json['receiver_avatar'] as String?,
      senderNickname: senderNickname,
      senderFullName: senderFullName,
      receiverFullName: json['receiver_full_name'] as String?,
      content: json['content']?.toString() ?? '',
      messageType: json['message_type'] as String? ?? 'text',
      fileName: json['file_name'] as String?,
      quotedMessageId: quotedMessageId,
      quotedMessageContent: json['quoted_message_content'] as String?,
      status: json['status'] as String?,
      mentionedUserIds: mentionedUserIds,
      mentions: json['mentions'] as String?,
      callType: json['call_type'] as String?,
      channelName: json['channel_name'] as String?,
      voiceDuration: voiceDuration,
      // 处理is_read：SQLite使用0/1表示布尔值，需要兼容int和bool类型
      isRead: json['is_read'] is bool 
          ? json['is_read'] as bool
          : (json['is_read'] == 1 || json['is_read'] == true),
      // 🔴 时区处理：解析时间字符串
      // - 带 Z 后缀的是 UTC 时间（来自服务器），需要转换为上海时区
      // - 不带 Z 后缀的是上海时间（来自本地数据库），直接使用
      createdAt: () {
        final createdAtStr = json['created_at'] as String?;
        
        if (createdAtStr == null || createdAtStr.isEmpty) {
          return DateTime.now();
        }
        try {
          // 检查是否带 Z 后缀（UTC 时间）
          final hasZSuffix = createdAtStr.endsWith('Z');
          if (hasZSuffix) {
            // 带 Z 后缀：来自服务器的 UTC 时间，需要转换为上海时区
            return TimezoneHelper.parseToShanghaiTime(createdAtStr, assumeUtc: true);
          } else {
            // 不带 Z 后缀：来自本地数据库，已经是上海时间，直接解析
            return DateTime.parse(createdAtStr);
          }
        } catch (e) {
          logger.debug('🕐 [MessageModel.fromJson] 解析失败: $e，使用当前时间');
          return DateTime.now();
        }
      }(),
      readAt: json['read_at'] != null
          ? () {
              try {
                return DateTime.parse(json['read_at'] as String);
              } catch (e) {
                return null;
              }
            }()
          : null,
      uploadProgress: json['upload_progress'] as double?,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (serverId != null) 'server_id': serverId,
      if (agoraMsgId != null) 'agora_msg_id': agoraMsgId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_name': senderName,
      'receiver_name': receiverName,
      if (senderAvatar != null) 'sender_avatar': senderAvatar,
      if (receiverAvatar != null) 'receiver_avatar': receiverAvatar,
      if (senderNickname != null) 'sender_nickname': senderNickname,
      if (senderFullName != null) 'sender_full_name': senderFullName,
      if (receiverFullName != null) 'receiver_full_name': receiverFullName,
      'content': content,
      'message_type': messageType,
      if (fileName != null) 'file_name': fileName,
      if (quotedMessageId != null) 'quoted_message_id': quotedMessageId,
      if (quotedMessageContent != null)
        'quoted_message_content': quotedMessageContent,
      if (status != null) 'status': status,
      if (mentionedUserIds != null && mentionedUserIds!.isNotEmpty)
        'mentioned_user_ids': mentionedUserIds,
      if (mentions != null && mentions!.isNotEmpty) 'mentions': mentions,
      if (callType != null) 'call_type': callType,
      if (channelName != null) 'channel_name': channelName,
      if (voiceDuration != null) 'voice_duration': voiceDuration,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      if (uploadProgress != null) 'upload_progress': uploadProgress,
    };
  }

  /// 获取显示的发送者名称（优先使用群组昵称，其次使用全名，最后使用账号）
  String get displaySenderName {
    final logger = Logger();
    String result;
    
    // 优先使用群组昵称
    if (senderNickname != null && senderNickname!.isNotEmpty) {
      result = senderNickname!;
      logger.debug('👤 [displaySenderName] 使用群昵称: "$result" (sender_id: $senderId)');
      return result;
    }
    // 其次使用全名（昵称）
    if (senderFullName != null && senderFullName!.isNotEmpty) {
      result = senderFullName!;
      // logger.debug('👤 [displaySenderName] 使用全名: "$result" (sender_id: $senderId)');
      return result;
    }
    // 最后使用账号
    result = senderName;
    // logger.debug('👤 [displaySenderName] 使用账号: "$result" (sender_id: $senderId)');
    return result;
  }

  /// 格式化时间显示
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      // 今天，显示时间
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // 昨天
      return '昨天 ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      // 一周内
      final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      return '${weekdays[createdAt.weekday - 1]} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else {
      // 更早
      return '${createdAt.month}-${createdAt.day} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    }
  }

  /// 创建副本并更新指定字段
  MessageModel copyWith({
    int? id,
    int? serverId,
    String? agoraMsgId,
    int? senderId,
    int? receiverId,
    String? senderName,
    String? receiverName,
    String? senderAvatar,
    String? receiverAvatar,
    String? senderNickname,
    String? senderFullName,
    String? receiverFullName,
    String? content,
    String? messageType,
    String? fileName,
    int? quotedMessageId,
    String? quotedMessageContent,
    String? status,
    List<int>? mentionedUserIds,
    String? mentions,
    String? callType,
    String? channelName,
    int? voiceDuration,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
    double? uploadProgress,
  }) {
    return MessageModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      agoraMsgId: agoraMsgId ?? this.agoraMsgId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      receiverAvatar: receiverAvatar ?? this.receiverAvatar,
      senderNickname: senderNickname ?? this.senderNickname,
      senderFullName: senderFullName ?? this.senderFullName,
      receiverFullName: receiverFullName ?? this.receiverFullName,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      fileName: fileName ?? this.fileName,
      quotedMessageId: quotedMessageId ?? this.quotedMessageId,
      quotedMessageContent: quotedMessageContent ?? this.quotedMessageContent,
      status: status ?? this.status,
      mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
      mentions: mentions ?? this.mentions,
      callType: callType ?? this.callType,
      channelName: channelName ?? this.channelName,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}
