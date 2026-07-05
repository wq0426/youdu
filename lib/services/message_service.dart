import 'dart:async';
import 'dart:convert';

import '../models/message_model.dart';
import '../utils/logger.dart';
import '../utils/storage.dart';
import 'local_database_service.dart';
import 'api_service.dart';
import 'agora_chat_service.dart';

/// 消息服务 - 统一管理私聊和群聊消息
/// 所有消息都存储在本地SQLite数据库中
class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  final _localDb = LocalDatabaseService();

  // ============ 私聊消息 ============

  /// 获取私聊消息历史
  Future<List<MessageModel>> getMessages({
    required int contactId,
    int page = 1,
    int pageSize = 50,
    int? beforeId, // 🔴 新增：获取此ID之前的消息（用于加载更多历史）
  }) async {
    try {
      // 获取当前用户ID
      final currentUserId = await Storage.getUserId();
      if (currentUserId == null) {
        logger.debug('未找到当前用户信息');
        return [];
      }

      // 从本地数据库获取消息
      final messages = await _localDb.getMessages(
        userId1: currentUserId,
        userId2: contactId,
        limit: pageSize,
        beforeId: beforeId,
      );

      // 🔄 对于image、video、file、voice类型，替换content中的OSS域名前缀
      final processedMessages = <Map<String, dynamic>>[];
      for (final data in messages) {
        final messageType = data['message_type'] as String?;
        final messageId = data['id'];
        
        // 创建可修改的副本
        final mutableData = Map<String, dynamic>.from(data);
        
        // 替换消息内容
        if (messageType == 'image' || messageType == 'video' || messageType == 'file' || messageType == 'voice') {
          final content = mutableData['content'] as String?;
          
          if (content != null && content.isNotEmpty) {
            final replacedContent = await Storage.replaceOSSPrefixInUrl(content);
            if (replacedContent != content) {
              logger.debug('🔄 [PrivateMessage] ID=$messageId, 类型=$messageType, 替换content: $content -> $replacedContent');
              mutableData['content'] = replacedContent;
            }
          }
        }
        
        // 🔄 替换引用消息内容（quoted_message_content）
        final quotedContent = mutableData['quoted_message_content'] as String?;
        if (quotedContent != null && quotedContent.isNotEmpty) {
          final replacedQuotedContent = await Storage.replaceOSSPrefixInUrl(quotedContent);
          if (replacedQuotedContent != quotedContent) {
            logger.debug('🔄 [PrivateMessage] ID=$messageId, 替换quoted_content: $quotedContent -> $replacedQuotedContent');
            mutableData['quoted_message_content'] = replacedQuotedContent;
          }
        }
        
        // 🔄 替换发送者头像（sender_avatar）
        final senderAvatar = mutableData['sender_avatar'] as String?;
        if (senderAvatar != null && senderAvatar.isNotEmpty) {
          final replacedAvatar = await Storage.replaceOSSPrefixInUrl(senderAvatar);
          if (replacedAvatar != senderAvatar) {
            logger.debug('🔄 [PrivateMessage] ID=$messageId, 替换sender_avatar: $senderAvatar -> $replacedAvatar');
            mutableData['sender_avatar'] = replacedAvatar;
          }
        }
        
        // 🔄 替换接收者头像（receiver_avatar）
        final receiverAvatar = mutableData['receiver_avatar'] as String?;
        if (receiverAvatar != null && receiverAvatar.isNotEmpty) {
          final replacedAvatar = await Storage.replaceOSSPrefixInUrl(receiverAvatar);
          if (replacedAvatar != receiverAvatar) {
            logger.debug('🔄 [PrivateMessage] ID=$messageId, 替换receiver_avatar: $receiverAvatar -> $replacedAvatar');
            mutableData['receiver_avatar'] = replacedAvatar;
          }
        }
        
        processedMessages.add(mutableData);
      }

      // 转换为MessageModel
      final messageList = processedMessages
          .map((json) => MessageModel.fromJson(json))
          .toList();

      return messageList;
    } catch (e) {
      logger.debug('获取私聊消息失败: $e');
      return [];
    }
  }

  /// 获取私聊消息历史（兼容旧API）
  Future<Map<String, dynamic>> getMessageHistory({
    required int userId,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final messages = await getMessages(
        contactId: userId,
        page: page,
        pageSize: pageSize,
      );

      return {
        'code': 0,
        'message': '成功',
        'data': {
          'messages': messages.map((m) => m.toJson()).toList(),
          'page': page,
          'page_size': pageSize,
          'total': messages.length,
        },
      };
    } catch (e) {
      logger.debug('获取消息历史失败: $e');
      return {'code': -1, 'message': '获取失败: $e', 'data': null};
    }
  }

  /// 保存私聊消息到本地数据库
  Future<int> saveMessage(Map<String, dynamic> messageData) async {
    try {
      return await _localDb.insertMessage(messageData);
    } catch (e) {
      logger.debug('保存私聊消息失败: $e');
      rethrow;
    }
  }

  /// 更新消息已读状态
  Future<void> markMessageAsRead(int messageId) async {
    try {
      await _localDb.updateMessageReadStatus(messageId);
    } catch (e) {
      logger.debug('更新消息已读状态失败: $e');
      rethrow;
    }
  }

  /// 批量标记消息为已读
  /// 同时更新本地数据库和服务器数据库
  Future<void> markMessagesAsRead(int senderId) async {
    try {
      logger.debug('🔍 [MessageService.markMessagesAsRead] 开始标记消息为已读 - senderId: $senderId');
      
      final receiverId = await Storage.getUserId();
      if (receiverId == null) {
        logger.debug('⚠️ [MessageService.markMessagesAsRead] receiverId为空，跳过');
        return;
      }
      
      logger.debug('🔍 [MessageService.markMessagesAsRead] receiverId: $receiverId');

      // 1. 更新本地数据库
      await _localDb.markMessagesAsRead(senderId, receiverId);
      logger.debug('✅ [MessageService.markMessagesAsRead] 本地数据库已标记消息为已读 - senderId: $senderId, receiverId: $receiverId');

      // 2. 同步到服务器数据库（异步执行，不阻塞UI，但记录结果）
      _syncMarkMessagesAsReadToServer(senderId).then((_) {
        logger.debug('✅ [MessageService.markMessagesAsRead] 服务器同步已读状态完成 - senderId: $senderId');
      }).catchError((e) {
        logger.error('❌ [MessageService.markMessagesAsRead] 服务器同步已读状态失败 - senderId: $senderId, error: $e');
      });
    } catch (e) {
      logger.debug('❌ [MessageService.markMessagesAsRead] 批量标记消息为已读失败: $e');
      rethrow;
    }
  }

  /// 同步私聊已读状态（迁移到 Agora Chat）
  ///
  /// 已读状态改由 Agora 会话已读回执承载（替代旧的 /api/messages/mark-read 写库）。
  /// 单聊 conversationId = 对端用户ID字符串。
  Future<void> _syncMarkMessagesAsReadToServer(int senderId) async {
    try {
      final conversationId = senderId.toString();
      await AgoraChatService().markConversationAllRead(
        conversationId: conversationId,
      );
      await AgoraChatService().sendConversationReadAck(conversationId);
      logger.debug('✅ [Agora已读] 私聊会话已读已同步 - senderId: $senderId');
    } catch (e) {
      logger.error('❌ [Agora已读] 私聊会话已读同步异常 - senderId: $senderId, 错误: $e');
      // 不抛出异常，因为本地已经标记成功
    }
  }

  /// 撤回消息
  Future<void> recallMessage(int messageId) async {
    try {
      await _localDb.recallMessage(messageId);
    } catch (e) {
      logger.debug('撤回消息失败: $e');
      rethrow;
    }
  }

  /// 删除消息
  Future<void> deleteMessage(int messageId, int userId) async {
    try {
      await _localDb.deleteMessage(messageId, userId);
    } catch (e) {
      logger.debug('删除消息失败: $e');
      rethrow;
    }
  }

  /// 获取未读消息数量
  Future<int> getUnreadMessageCount(int receiverId) async {
    try {
      return await _localDb.getUnreadMessageCount(receiverId);
    } catch (e) {
      logger.debug('获取未读消息数量失败: $e');
      return 0;
    }
  }

  /// 格式化消息预览：将特殊类型的消息转换为显示文本
  /// [isSender] 当前用户是否是消息的发送者（用于通话拒绝/取消消息的显示）
  String _formatMessagePreview(
    String messageType,
    String content,
    String? fileName, {
    int? voiceDuration,
    bool isSender = false,
  }) {
    switch (messageType) {
      case 'image':
        return '[图片]';
      case 'file':
        return '[文件]';
      case 'audio':
      case 'voice':
        if (voiceDuration != null && voiceDuration > 0) {
          return '[语音] ${voiceDuration}秒';
        }
        return '[语音]';
      case 'video':
        return '[视频]';
      case 'call_ended':
      case 'call_ended_video':
        // Telegram 风格：自己发起的通话显示"拨出"，对方发起显示"来电"
        return isSender ? '拨出' : '来电';
      // 🔴 修复：通话拒绝消息根据当前用户是发送者还是接收者显示不同内容
      case 'call_rejected':
      case 'call_rejected_video':
        // 发送者（拒绝方）看到"已拒绝"，接收者（被拒绝方）看到"对方已拒绝"
        return isSender ? '已拒绝' : '对方已拒绝';
      case 'call_cancelled':
      case 'call_cancelled_video':
        // 发送者（取消方）看到"已取消"，接收者（被取消方）看到"对方已取消"
        return isSender ? '已取消' : '对方已取消';
      default:
        // 检测是否为纯表情消息（格式：[emotion:xxx.png]）
        if (content.contains('[emotion:')) {
          final withoutEmotions = content
              .replaceAll(RegExp(r'\[emotion:[^\]]+\.png\]'), '')
              .trim();
          if (withoutEmotions.isEmpty) {
            return '[表情]';
          }
        }
        return content;
    }
  }

  /// 判断字符串是否是纯数字ID
  bool _isNumericId(String value) {
    if (value.isEmpty) return false;
    return int.tryParse(value) != null;
  }

  /// 判断是否为自动生成的群聊名称（例如“群聊123”）
  bool _isGeneratedGroupName(String name, int groupId) {
    final trimmed = name.trim();
    return trimmed == '群聊$groupId' || trimmed == '群聊 $groupId';
  }

  static const Duration _contactSnapshotTtl = Duration(hours: 12);

  bool _isSnapshotExpired(Map<String, dynamic> snapshot) {
    final updatedAt = snapshot['updated_at']?.toString();
    if (updatedAt == null || updatedAt.isEmpty) {
      return true;
    }
    final parsed = DateTime.tryParse(updatedAt);
    if (parsed == null) {
      return true;
    }
    return DateTime.now().difference(parsed) > _contactSnapshotTtl;
  }

  Future<Map<String, dynamic>?> _getOrFetchContactSnapshot({
    required int ownerId,
    required int contactId,
    required String contactType,
    required String? token,
    bool forceRefresh = false,
    String? fallbackName,
    String? fallbackAvatar,
  }) async {
    final normalizedType = contactType == 'group' ? 'group' : 'user';
    Map<String, dynamic>? snapshot;

    try {
      snapshot = await _localDb.getContactSnapshot(
        ownerId: ownerId,
        contactId: contactId,
        contactType: normalizedType,
      );
    } catch (e) {
      logger.debug('❌ 读取联系人快照失败: $e');
    }

    final bool hasToken = token != null && token.isNotEmpty;
    final bool missingName = snapshot == null ||
        ((snapshot['full_name']?.toString().trim().isEmpty ?? true) &&
            (snapshot['username']?.toString().trim().isEmpty ?? true));
    final bool shouldRefresh =
        hasToken && (forceRefresh || missingName || (snapshot != null && _isSnapshotExpired(snapshot)));

    if (shouldRefresh) {
      // 🚀 优化：仅在「无可展示数据」（快照缺失/无名字）或显式要求时才阻塞等待 HTTP；
      // 快照只是过期（TTL 12h）时先返回旧数据供首屏渲染，HTTP 刷新放后台执行，
      // 完成后经 onSnapshotsRefreshed 通知会话列表刷新（UI 侧防抖合并）。
      // 否则每隔 12h 的首次打开，N 个会话 = N 个并发 HTTP 一起挡住首屏。
      final bool blocking = forceRefresh || missingName;
      if (blocking) {
        final remote = await _fetchContactSnapshotFromApi(
          ownerId: ownerId,
          contactId: contactId,
          contactType: normalizedType,
          token: token!,
        );
        if (remote != null) {
          await _localDb.upsertContactSnapshot(
            ownerId: ownerId,
            contactId: contactId,
            contactType: normalizedType,
            username: remote['username'] as String?,
            fullName: remote['full_name'] as String?,
            avatar: remote['avatar'] as String?,
            remark: remote['remark'] as String?,
            metadata: remote['metadata'] as String?,
          );
          snapshot = remote;
        }
      } else {
        unawaited(_refreshSnapshotInBackground(
          ownerId: ownerId,
          contactId: contactId,
          contactType: normalizedType,
          token: token!,
        ));
      }
    }

    if (snapshot == null &&
        fallbackName != null &&
        fallbackName.trim().isNotEmpty) {
      snapshot = {
        'contact_type': normalizedType,
        'contact_id': contactId,
        'owner_id': ownerId,
        'full_name': fallbackName.trim(),
        'username': fallbackName.trim(),
        'avatar': fallbackAvatar,
        'updated_at': DateTime.now().toIso8601String(),
      };
    } else if (snapshot != null &&
        (snapshot['avatar'] == null ||
            (snapshot['avatar'] as String?)?.isEmpty == true) &&
        fallbackAvatar != null) {
      snapshot = Map<String, dynamic>.from(snapshot);
      snapshot['avatar'] = fallbackAvatar;
    }

    return snapshot;
  }

  /// 🚀 联系人快照后台刷新完成后的通知（用于会话列表刷新名称/头像）。
  /// 由 UI 层注入（如 MobileChatListPage.needRefresh），避免 service→page 反向依赖。
  /// 多次触发由 UI 侧防抖合并。
  static void Function()? onSnapshotsRefreshed;

  /// 🚀 后台刷新过期的联系人快照（同一联系人并发去重）
  static final Set<String> _snapshotRefreshInFlight = {};

  Future<void> _refreshSnapshotInBackground({
    required int ownerId,
    required int contactId,
    required String contactType,
    required String token,
  }) async {
    final key = '$ownerId:$contactType:$contactId';
    if (!_snapshotRefreshInFlight.add(key)) return; // 已有同款刷新在跑
    try {
      final remote = await _fetchContactSnapshotFromApi(
        ownerId: ownerId,
        contactId: contactId,
        contactType: contactType,
        token: token,
      );
      if (remote != null) {
        await _localDb.upsertContactSnapshot(
          ownerId: ownerId,
          contactId: contactId,
          contactType: contactType,
          username: remote['username'] as String?,
          fullName: remote['full_name'] as String?,
          avatar: remote['avatar'] as String?,
          remark: remote['remark'] as String?,
          metadata: remote['metadata'] as String?,
        );
        onSnapshotsRefreshed?.call();
      }
    } catch (e) {
      logger.debug('❌ 后台刷新联系人快照失败: $e');
    } finally {
      _snapshotRefreshInFlight.remove(key);
    }
  }

  Future<Map<String, dynamic>?> _fetchContactSnapshotFromApi({
    required int ownerId,
    required int contactId,
    required String contactType,
    required String token,
  }) async {
    try {
      if (contactType == 'group') {
        final response = await ApiService.getGroupDetail(
          token: token,
          groupId: contactId,
        );
        if (_isApiSuccess(response) && response['data'] != null) {
          final groupData =
              _extractPayloadMap(response['data'], nestedKey: 'group');
          if (groupData != null) {
            final name =
                groupData['name']?.toString().trim().isNotEmpty == true
                    ? groupData['name'].toString().trim()
                    : '群聊$contactId';
            final avatar = (groupData['avatar'] ??
                    groupData['avatar_url'] ??
                    groupData['icon'])
                ?.toString();
            final remark = groupData['remark']?.toString();
            return {
              'owner_id': ownerId,
              'contact_id': contactId,
              'contact_type': 'group',
              'username': name,
              'full_name': name,
              'avatar': avatar,
              'remark': remark,
              'metadata': _safeEncode(groupData),
              'updated_at': DateTime.now().toIso8601String(),
            };
          }
        }
      } else {
        final response = await ApiService.getUserInfo(contactId, token: token);
        if (_isApiSuccess(response) && response['data'] != null) {
          final userData =
              _extractPayloadMap(response['data'], nestedKey: 'user');
          if (userData != null) {
            final username = userData['username']?.toString().trim().isNotEmpty ==
                    true
                ? userData['username'].toString().trim()
                : contactId.toString();
            final fullName =
                userData['full_name']?.toString().trim().isNotEmpty == true
                    ? userData['full_name'].toString().trim()
                    : username;
            final avatar = (userData['avatar'] ??
                    userData['avatar_url'] ??
                    userData['profile_photo'])
                ?.toString();
            final remark = userData['remark']?.toString();
            return {
              'owner_id': ownerId,
              'contact_id': contactId,
              'contact_type': 'user',
              'username': username,
              'full_name': fullName,
              'avatar': avatar,
              'remark': remark,
              'metadata': _safeEncode(userData),
              'updated_at': DateTime.now().toIso8601String(),
            };
          }
        }
      }
    } catch (e) {
      logger.debug(
        '❌ 从接口获取联系人快照失败: $e (type=$contactType, id=$contactId)',
      );
    }
    return null;
  }

  Map<String, dynamic>? _extractPayloadMap(
    dynamic payload, {
    String? nestedKey,
  }) {
    if (payload is Map<String, dynamic>) {
      if (nestedKey != null && payload[nestedKey] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(
          payload[nestedKey] as Map<String, dynamic>,
        );
      }
      return Map<String, dynamic>.from(payload);
    }
    return null;
  }

  bool _isApiSuccess(Map<String, dynamic> response) {
    final code = response['code'];
    if (code is int) {
      return code == 0 || code == 200;
    }
    return false;
  }

  String? _safeEncode(Map<String, dynamic> data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      logger.debug('❌ 编码联系人快照元数据失败: $e');
      return null;
    }
  }

  /// 获取最近联系人列表
  ///
  /// 阶段5：会话列表来源切换为 Agora Chat（消息已迁移到 Agora，后端/本地SQLite 不再有新消息）。
  /// 由 Agora 会话拿到最后一条消息 + 未读数，名称/头像复用联系人/群组快照（后端 roster 仍可用）。
  Future<Map<String, dynamic>> getRecentContacts({bool preferLocal = true}) async {
    try {
      final currentUserId = await Storage.getUserId();
      if (currentUserId == null) {
        return {'code': -1, 'message': '未登录', 'data': null};
      }

      final authToken = await Storage.getToken();
      final pendingContactIds =
          await Storage.getPendingContactsForCurrentUser();

      // 默认本地优先：进会话列表时直接读 Agora 本地库，秒出且不联网；
      // 本地为空（首登/换机）会自动回退服务端拉取。
      final summaries =
          await AgoraChatService().buildConversationSummaries(preferLocal: preferLocal);
      logger.debug('📊 [RecentContacts] Agora 会话 ${summaries.length} 个');

      final contactsFutures =
          summaries.map<Future<Map<String, dynamic>?>>((s) async {
        try {
          final contactType = s.isGroup ? 'group' : 'user';
          final contactId = s.peerId;

          // 私聊：过滤仍在待审核的联系人
          if (!s.isGroup && pendingContactIds.contains(contactId)) {
            return null;
          }

          final last = s.lastMessage;
          final isSender = last != null && last.senderId == currentUserId;
          final formattedMessage = last == null
              ? ''
              : _formatMessagePreview(
                  last.messageType,
                  last.content,
                  last.fileName,
                  voiceDuration: last.voiceDuration,
                  isSender: isSender,
                );
          final lastMessageStatus = last?.status;
          final lastMessageTime =
              (last?.createdAt ?? DateTime.now()).toIso8601String();

          // 名称/头像：复用联系人/群组快照
          String contactUsername = contactId.toString();
          String contactFullName = contactId.toString();
          String? contactAvatar;
          String? contactRemark;

          final snapshot = await _getOrFetchContactSnapshot(
            ownerId: currentUserId,
            contactId: contactId,
            contactType: contactType,
            token: authToken,
            forceRefresh: false,
          );
          if (snapshot != null) {
            final cachedFullName = snapshot['full_name']?.toString();
            final cachedUsername = snapshot['username']?.toString();
            if (cachedFullName != null && cachedFullName.trim().isNotEmpty) {
              contactFullName = cachedFullName.trim();
            } else if (cachedUsername != null &&
                cachedUsername.trim().isNotEmpty) {
              contactFullName = cachedUsername.trim();
            }
            if (cachedUsername != null && cachedUsername.trim().isNotEmpty) {
              contactUsername = cachedUsername.trim();
            }
            final cachedAvatar = snapshot['avatar']?.toString();
            if (cachedAvatar != null && cachedAvatar.isNotEmpty) {
              contactAvatar = cachedAvatar;
            }
            final cachedRemark = snapshot['remark']?.toString();
            if (!s.isGroup &&
                cachedRemark != null &&
                cachedRemark.trim().isNotEmpty) {
              contactRemark = cachedRemark.trim();
            }
          }
          if (s.isGroup && contactFullName == contactId.toString()) {
            contactFullName = '群聊$contactId';
            contactUsername = contactFullName;
          }

          final resolvedFullName =
              contactFullName.isNotEmpty ? contactFullName : contactUsername;

          final contactKey = Storage.generateContactKey(
            isGroup: s.isGroup,
            id: contactId,
          );
          final doNotDisturb =
              await Storage.getDoNotDisturb(currentUserId, contactKey);

          return {
            'type': contactType,
            'user_id': contactId,
            'username': contactUsername,
            'full_name': resolvedFullName,
            'avatar': contactAvatar,
            'last_message_time': lastMessageTime,
            'last_message': formattedMessage,
            'last_message_status': lastMessageStatus,
            // Telegram 风格会话列表：自己发的最后一条消息显示单勾/双勾
            'last_message_from_me': isSender,
            'last_message_read': last?.isRead == true,
            'unread_count': s.unreadCount,
            'status': 'offline',
            'do_not_disturb': doNotDisturb,
            if (!s.isGroup && contactRemark != null) 'remark': contactRemark,
            if (s.isGroup) 'group_id': contactId,
            if (s.isGroup) 'group_name': resolvedFullName,
          };
        } catch (e) {
          logger.debug('❌ [RecentContacts] 处理会话失败: $e');
          return null;
        }
      });

      final contactsRaw = await Future.wait(contactsFutures);
      final contacts = contactsRaw.whereType<Map<String, dynamic>>().toList();

      return {
        'code': 0,
        'message': '成功',
        'data': {'contacts': contacts},
      };
    } catch (e) {
      logger.debug('获取最近联系人列表失败: $e');
      return {'code': -1, 'message': '获取失败: $e', 'data': null};
    }
  }


  // ============ 群聊消息 ============

  /// 获取群聊消息
  Future<List<MessageModel>> getGroupMessageList({
    required int groupId,
    int page = 1,
    int pageSize = 50,
    int? beforeId, // 🔴 新增：获取此ID之前的消息（用于加载更多历史）
  }) async {
    try {
      // 获取当前用户ID，用于过滤已删除的消息
      final currentUserId = await Storage.getUserId();

      // 从本地数据库获取消息
      final messages = await _localDb.getGroupMessages(
        groupId: groupId,
        userId: currentUserId, // 传入用户ID以过滤该用户已删除的消息
        limit: pageSize,
        beforeId: beforeId,
      );

      // 🔍 调试：查看数据库返回的原始数据
      if (messages.isNotEmpty) {
        final firstMsg = messages.first;
      }

      // 🔄 对于image、video、file、voice类型，替换content中的OSS域名前缀
      final processedMessages = <Map<String, dynamic>>[];
      for (final data in messages) {
        final messageType = data['message_type'] as String?;
        final messageId = data['id'];
        
        // 创建可修改的副本
        final mutableData = Map<String, dynamic>.from(data);
        
        // 替换消息内容
        if (messageType == 'image' || messageType == 'video' || messageType == 'file' || messageType == 'voice') {
          final content = mutableData['content'] as String?;
          
          if (content != null && content.isNotEmpty) {
            final replacedContent = await Storage.replaceOSSPrefixInUrl(content);
            if (replacedContent != content) {
              logger.debug('🔄 [GroupMessage] ID=$messageId, 类型=$messageType, 替换content: $content -> $replacedContent');
              mutableData['content'] = replacedContent;
            }
          }
        }
        
        // 🔄 替换引用消息内容（quoted_message_content）
        final quotedContent = mutableData['quoted_message_content'] as String?;
        if (quotedContent != null && quotedContent.isNotEmpty) {
          final replacedQuotedContent = await Storage.replaceOSSPrefixInUrl(quotedContent);
          if (replacedQuotedContent != quotedContent) {
            logger.debug('🔄 [GroupMessage] ID=$messageId, 替换quoted_content: $quotedContent -> $replacedQuotedContent');
            mutableData['quoted_message_content'] = replacedQuotedContent;
          }
        }
        
        // 🔄 替换发送者头像（sender_avatar）
        final senderAvatar = mutableData['sender_avatar'] as String?;
        if (senderAvatar != null && senderAvatar.isNotEmpty) {
          final replacedAvatar = await Storage.replaceOSSPrefixInUrl(senderAvatar);
          if (replacedAvatar != senderAvatar) {
            logger.debug('🔄 [GroupMessage] ID=$messageId, 替换sender_avatar: $senderAvatar -> $replacedAvatar');
            mutableData['sender_avatar'] = replacedAvatar;
          }
        }
        
        processedMessages.add(mutableData);
      }

      // 转换为MessageModel
      final messageList = processedMessages
          .map((json) => MessageModel.fromJson(json))
          .toList();
      
      // 🔍 调试：查看转换后的 MessageModel
      if (messageList.isNotEmpty) {
        final firstModel = messageList.first;
      }

      return messageList;
    } catch (e) {
      logger.debug('获取群聊消息失败: $e');
      return [];
    }
  }

  /// 获取群聊消息（兼容旧API）
  Future<Map<String, dynamic>> getGroupMessages({
    required int groupId,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final messages = await getGroupMessageList(
        groupId: groupId,
        page: page,
        pageSize: pageSize,
      );

      return {
        'code': 0,
        'message': '成功',
        'data': {
          'messages': messages.map((m) => m.toJson()).toList(),
          'page': page,
          'page_size': pageSize,
          'total': messages.length,
        },
      };
    } catch (e) {
      logger.debug('获取群聊消息失败: $e');
      return {'code': -1, 'message': '获取失败: $e', 'data': null};
    }
  }

  /// 保存群聊消息到本地数据库
  Future<int> saveGroupMessage(Map<String, dynamic> messageData) async {
    try {
      return await _localDb.insertGroupMessage(messageData);
    } catch (e) {
      logger.debug('保存群聊消息失败: $e');
      rethrow;
    }
  }

  /// 撤回群聊消息
  Future<void> recallGroupMessage(int messageId) async {
    try {
      await _localDb.recallGroupMessage(messageId);
    } catch (e) {
      logger.debug('撤回群聊消息失败: $e');
      rethrow;
    }
  }

  /// 删除群聊消息
  Future<void> deleteGroupMessage(int messageId, int userId) async {
    try {
      await _localDb.deleteGroupMessage(messageId, userId);
    } catch (e) {
      logger.debug('删除群聊消息失败: $e');
      rethrow;
    }
  }

  /// 标记群聊消息为已读
  Future<void> markGroupMessageAsRead(int groupMessageId, int userId) async {
    try {
      await _localDb.markGroupMessageAsRead(groupMessageId, userId);
    } catch (e) {
      logger.debug('标记群聊消息为已读失败: $e');
      rethrow;
    }
  }

  /// 🔴 通过服务器ID标记群聊消息为已读
  Future<void> markGroupMessageAsReadByServerId(int serverId, int userId) async {
    try {
      await _localDb.markGroupMessageAsReadByServerId(serverId, userId);
    } catch (e) {
      logger.debug('通过服务器ID标记群聊消息为已读失败: $e');
      rethrow;
    }
  }

  /// 批量标记群组消息为已读
  /// 同时更新本地数据库和服务器数据库
  Future<void> markGroupMessagesAsRead(int groupId) async {
    try {
      final userId = await Storage.getUserId();
      if (userId == null) return;

      // 1. 更新本地数据库
      await _localDb.markGroupMessagesAsRead(groupId, userId);
      logger.debug('✅ 本地数据库已标记群组消息为已读 - groupId: $groupId');

      // 2. 同步到服务器数据库（异步执行，不阻塞UI）
      _syncMarkGroupMessagesAsReadToServer(groupId);
    } catch (e) {
      logger.debug('批量标记群组消息为已读失败: $e');
      rethrow;
    }
  }

  /// 同步群组已读状态（迁移到 Agora Chat）
  ///
  /// 已读状态改由 Agora 会话已读回执承载（替代旧的 /api/messages/mark-group-read 写 group_message_reads 表）。
  /// 群聊 conversationId = Agora 群会话ID（由本地群ID映射还原）。
  Future<void> _syncMarkGroupMessagesAsReadToServer(int groupId) async {
    try {
      final agoraGroupId = AgoraChatService().agoraGroupIdFor(groupId);
      if (agoraGroupId == null || agoraGroupId.isEmpty) {
        logger.debug('⚠️ [Agora已读] 群 $groupId 缺少 Agora 群ID映射，跳过群已读同步');
        return;
      }
      await AgoraChatService().markConversationAllRead(
        conversationId: agoraGroupId,
        isGroup: true,
      );
      await AgoraChatService().sendConversationReadAck(agoraGroupId);
      logger.debug('✅ [Agora已读] 群会话已读已同步 - groupId: $groupId, agoraGroupId: $agoraGroupId');
    } catch (e) {
      logger.error('❌ [Agora已读] 群会话已读同步异常 - groupId: $groupId, 错误: $e');
      // 不抛出异常，因为本地已经标记成功
    }
  }

  /// 获取群组未读消息数量
  Future<int> getGroupUnreadMessageCount(int groupId, int userId) async {
    try {
      return await _localDb.getGroupUnreadMessageCount(groupId, userId);
    } catch (e) {
      logger.debug('获取群组未读消息数量失败: $e');
      return 0;
    }
  }

  /// 获取群聊消息已读状态
  Future<List<Map<String, dynamic>>> getGroupMessageReads(
    int groupMessageId,
  ) async {
    try {
      return await _localDb.getGroupMessageReads(groupMessageId);
    } catch (e) {
      logger.debug('获取群聊消息已读状态失败: $e');
      return [];
    }
  }

  // ============ 数据库管理 ============

  /// 清空所有本地消息数据（退出登录时调用）
  Future<void> clearAllData() async {
    try {
      await _localDb.clearAllData();
      logger.debug('已清空所有本地消息数据');
    } catch (e) {
      logger.debug('清空本地消息数据失败: $e');
      rethrow;
    }
  }

  /// 关闭数据库连接
  Future<void> close() async {
    await _localDb.close();
  }
}
