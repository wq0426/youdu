import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../models/contact_model.dart';
import '../models/group_model.dart';
import '../services/api_service.dart';
import '../services/agora_chat_service.dart';
import '../utils/logger.dart';
import '../utils/storage.dart';
import 'mobile_home_page.dart';

/// 转发消息页面 - 用于选择转发目标
class ForwardMessagePage extends StatefulWidget {
  final MessageModel message;

  const ForwardMessagePage({super.key, required this.message});

  @override
  State<ForwardMessagePage> createState() => _ForwardMessagePageState();
}

class _ForwardMessagePageState extends State<ForwardMessagePage> {
  // 控制器
  final TextEditingController _searchController = TextEditingController();

  // 数据列表
  List<ContactModel> _contacts = [];
  List<GroupModel> _groups = [];
  List<dynamic> _searchResults = []; // 搜索结果（包含联系人和群组）

  // 选中的目标
  final Set<String> _selectedTargets = {}; // 格式: "user_123" 或 "group_456"

  // 状态
  bool _isLoading = true;
  bool _isSending = false;
  bool _isSearching = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _token = await Storage.getToken();

    if (_token == null) {
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 并行加载联系人和群组
      final results = await Future.wait([
        ApiService.getContacts(token: _token!),
        ApiService.getUserGroups(token: _token!),
      ]);

      final contactsResponse = results[0];
      final groupsResponse = results[1];

      if (mounted) {
        setState(() {
          if (contactsResponse['code'] == 0 &&
              contactsResponse['data'] != null) {
            // getContacts 返回 { code, data: { contacts: [...], total } }
            final contactsData =
                (contactsResponse['data']['contacts'] as List?) ?? const [];
            _contacts = contactsData
                .map((json) => ContactModel.fromJson(json as Map<String, dynamic>))
                .where((c) => c.isApproved && !c.isDeleted)
                .toList();
          }

          if (groupsResponse['code'] == 0 &&
              groupsResponse['data'] != null) {
            final groupsData = groupsResponse['data']['groups'] as List?;
            _groups = (groupsData ?? [])
                .map((json) => GroupModel.fromJson(json))
                .toList();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      logger.error('加载数据失败', error: e);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载数据失败: $e')));
      }
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = [];

      // 搜索联系人
      _searchResults.addAll(
        _contacts.where((contact) {
          final name = contact.displayName;
          return name.toLowerCase().contains(query.toLowerCase());
        }),
      );

      // 搜索群组
      _searchResults.addAll(
        _groups.where((group) {
          final name = group.nickname ?? group.name;
          return name.toLowerCase().contains(query.toLowerCase());
        }),
      );
    });
  }

  Future<void> _forwardMessage() async {
    if (_selectedTargets.isEmpty || _token == null) return;

    setState(() => _isSending = true);

    try {
      int successCount = 0;
      int totalCount = _selectedTargets.length;

      // 发送者信息（用于 ext 透传，接收端还原昵称/头像）
      final userName = await Storage.getUsername() ?? '';
      final userAvatar = await Storage.getAvatar() ?? '';
      final userFullName = await Storage.getFullName() ?? '';
      final msgType = widget.message.messageType;
      final content = widget.message.content;
      final fileName = widget.message.fileName;
      final isTextLike = msgType == 'text' || msgType == 'quoted';

      for (final target in _selectedTargets) {
        final isGroup = target.startsWith('group_');
        final targetId = int.parse(target.split('_')[1]);

        bool success = false;

        // 🔵 阶段5：转发统一走 Agora Chat
        if (isGroup) {
          // 群组：需要 Agora 群会话ID（登录预热已登记映射，缺失则现取群详情补登记）
          var agoraGid = AgoraChatService().agoraGroupIdFor(targetId);
          if ((agoraGid == null || agoraGid.isEmpty) && _token != null) {
            try {
              final resp = await ApiService.getGroupDetail(
                token: _token!,
                groupId: targetId,
              );
              final gid = resp['data']?['group']?['agora_group_id'] as String?;
              if (gid != null && gid.isNotEmpty) {
                AgoraChatService().registerGroupMapping(targetId, gid);
                agoraGid = gid;
              }
            } catch (_) {}
          }
          if (agoraGid != null && agoraGid.isNotEmpty) {
            final sent = isTextLike
                ? await AgoraChatService().sendGroupText(
                    agoraGroupId: agoraGid,
                    content: content,
                    ext: {
                      AgoraChatService.extSenderName: userName,
                      AgoraChatService.extSenderAvatar: userAvatar,
                      if (userFullName.isNotEmpty)
                        AgoraChatService.extSenderFullName: userFullName,
                      AgoraChatService.extMessageType: msgType,
                    },
                  )
                : await AgoraChatService().sendGroupMedia(
                    agoraGroupId: agoraGid,
                    url: content,
                    messageType: msgType,
                    senderName: userName,
                    senderAvatar: userAvatar,
                    senderFullName: userFullName.isEmpty ? null : userFullName,
                    fileName: fileName,
                  );
            success = sent != null;
          }
        } else {
          // 私聊
          final sent = isTextLike
              ? await AgoraChatService().sendText(
                  toUserId: targetId,
                  content: content,
                  ext: {
                    AgoraChatService.extSenderName: userName,
                    AgoraChatService.extSenderAvatar: userAvatar,
                    AgoraChatService.extMessageType: msgType,
                  },
                )
              : await AgoraChatService().sendMedia(
                  toUserId: targetId,
                  url: content,
                  messageType: msgType,
                  senderName: userName,
                  senderAvatar: userAvatar,
                  fileName: fileName,
                );
          success = sent != null;
        }

        if (success) {
          successCount++;
          // 🔵 转发成功后更新发送方会话列表：自己发出的消息不会回流到 messageStream
          // （messagesReceiveCallbackIncludeSend=false）。复用退出聊天页时验证可靠的
          // _updateSingleContact（读 Agora 最新消息）：已存在→更新最新消息并置顶，
          // 不存在→重新加载以新建；markRead=false 不清我对该会话的未读。收发双方都会有该会话。
          MobileHomePage.updateConversationOnOutgoing(
            targetId,
            isGroup: isGroup,
          );
        }

        // 添加小延迟，避免发送过快
        if (_selectedTargets.length > 1) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      if (mounted) {
        if (successCount == totalCount) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('成功转发到 $successCount 个目标')));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('部分转发成功 ($successCount/$totalCount)')),
          );
        }
      }
    } catch (e) {
      logger.error('转发消息失败', error: e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('转发失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择转发目标'),
        actions: [
          if (_selectedTargets.isNotEmpty)
            TextButton(
              onPressed: _isSending ? null : _forwardMessage,
              child: Text(
                _isSending ? '发送中...' : '发送(${_selectedTargets.length})',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索联系人或群组',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _performSearch,
            ),
          ),
          // 内容列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      // 显示搜索结果
      if (_searchResults.isEmpty) {
        return const Center(child: Text('未找到匹配的联系人或群组'));
      }

      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final item = _searchResults[index];
          if (item is ContactModel) {
            return _buildContactItem(item);
          } else if (item is GroupModel) {
            return _buildGroupItem(item);
          }
          return const SizedBox();
        },
      );
    }

    // 显示所有联系人和群组
    return ListView(
      children: [
        // 联系人部分
        if (_contacts.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Text(
              '联系人',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ..._contacts.map((contact) => _buildContactItem(contact)),
        ],

        // 群组部分
        if (_groups.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Text(
              '群组',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ..._groups.map((group) => _buildGroupItem(group)),
        ],
      ],
    );
  }

  Widget _buildContactItem(ContactModel contact) {
    final targetKey = 'user_${contact.friendId}';
    final isSelected = _selectedTargets.contains(targetKey);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(contact.displayName[0].toUpperCase()),
      ),
      title: Text(contact.displayName),
      subtitle: null,
      trailing: Checkbox(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedTargets.add(targetKey);
            } else {
              _selectedTargets.remove(targetKey);
            }
          });
        },
      ),
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTargets.remove(targetKey);
          } else {
            _selectedTargets.add(targetKey);
          }
        });
      },
    );
  }

  Widget _buildGroupItem(GroupModel group) {
    final targetKey = 'group_${group.id}';
    final isSelected = _selectedTargets.contains(targetKey);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: const Icon(Icons.group, color: Colors.white),
      ),
      title: Text(group.nickname ?? group.name),
      subtitle: group.nickname != null
          ? Text(group.name)
          : Text('${group.memberIds.length}人'),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedTargets.add(targetKey);
            } else {
              _selectedTargets.remove(targetKey);
            }
          });
        },
      ),
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTargets.remove(targetKey);
          } else {
            _selectedTargets.add(targetKey);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
