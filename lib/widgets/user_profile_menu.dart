import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telegram/utils/storage.dart';
import 'package:telegram/services/api_service.dart';
import 'package:telegram/services/websocket_service.dart';
import 'package:telegram/utils/app_localizations.dart';
import 'user_info_dialog.dart';
import 'change_password_dialog.dart';
import 'customer_service_dialog.dart';
import 'settings_dialog.dart';
import 'favorites_dialog.dart';
import '../utils/logger.dart';
import '../pages/login_page.dart';
import '../services/update_checker.dart';

/// 个人信息弹窗菜单
class UserProfileMenu extends StatefulWidget {
  final String username;
  final String userId;
  final String organization;
  final String status;
  final String token; // 添加token参数，避免从Storage读取被其他窗口覆盖的token
  final String? fullName;
  final String? gender;
  final String? workSignature;
  final String? landline;
  final String? shortNumber;
  final String? email;
  final String? department;
  final String? position;
  final String? region;
  final String? avatar;
  final String? inviteCode; // 用户邀请码
  final VoidCallback? onClose;
  final Function(String)? onStatusChanged;
  final VoidCallback? onProfileUpdated;
  final VoidCallback? onFileAssistantTap;

  const UserProfileMenu({
    super.key,
    required this.username,
    required this.userId,
    required this.organization,
    required this.token, // token必须传入
    this.status = 'online',
    this.fullName,
    this.gender,
    this.workSignature,
    this.landline,
    this.shortNumber,
    this.email,
    this.department,
    this.position,
    this.region,
    this.avatar,
    this.inviteCode, // 用户邀请码
    this.onClose,
    this.onStatusChanged,
    this.onProfileUpdated,
    this.onFileAssistantTap,
  });

  @override
  State<UserProfileMenu> createState() => _UserProfileMenuState();

  /// 显示个人信息菜单
  static void show(
    BuildContext context, {
    required String username,
    required String userId,
    required String organization,
    required String token, // token必须传入
    String status = 'online',
    String? fullName,
    String? gender,
    String? workSignature,
    String? landline,
    String? shortNumber,
    String? email,
    String? department,
    String? position,
    String? region,
    String? avatar,
    String? inviteCode, // 用户邀请码
    Offset? offset,
    Function(String)? onStatusChanged,
    VoidCallback? onProfileUpdated,
    VoidCallback? onFileAssistantTap,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            // 点击背景关闭
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
            ),
            // 弹窗内容
            Positioned(
              left: offset?.dx ?? 72,
              top: offset?.dy ?? 72,
              child: Material(
                color: Colors.transparent,
                child: UserProfileMenu(
                  username: username,
                  userId: userId,
                  organization: organization,
                  token: token, // 传递token
                  status: status,
                  fullName: fullName,
                  gender: gender,
                  workSignature: workSignature,
                  landline: landline,
                  shortNumber: shortNumber,
                  email: email,
                  department: department,
                  position: position,
                  region: region,
                  avatar: avatar,
                  inviteCode: inviteCode, // 传递邀请码
                  onStatusChanged: onStatusChanged,
                  onProfileUpdated: onProfileUpdated,
                  onFileAssistantTap: onFileAssistantTap,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UserProfileMenuState extends State<UserProfileMenu> {
  late String _currentStatus;
  late String? _currentWorkSignature;
  String? _currentAvatar; // 当前头像URL
  String? _currentFullName; // 当前昵称
  String? _currentGender; // 当前性别
  String? _currentLandline; // 当前座机
  String? _currentShortNumber; // 当前短号
  String? _currentEmail; // 当前邮箱
  String? _currentDepartment; // 当前部门
  String? _currentPosition; // 当前职位
  String? _currentRegion; // 当前地区
  final _wsService = WebSocketService();

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.status;
    _currentWorkSignature = widget.workSignature;
    _currentAvatar = widget.avatar; // 初始化时使用传入的头像
    _currentFullName = widget.fullName; // 初始化时使用传入的昵称
    _currentGender = widget.gender; // 初始化时使用传入的性别
    _currentLandline = widget.landline;
    _currentShortNumber = widget.shortNumber;
    _currentEmail = widget.email;
    _currentDepartment = widget.department;
    _currentPosition = widget.position;
    _currentRegion = widget.region;
  }

  @override
  void didUpdateWidget(UserProfileMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果头像参数更新了，同步更新状态
    if (oldWidget.avatar != widget.avatar) {
      _currentAvatar = widget.avatar;
    }
  }

  // 辅助方法：截断显示名称，超过9个字符添加省略号
  String _truncateDisplayName(String name) {
    if (name.length > 9) {
      return '${name.substring(0, 9)}...';
    }
    return name;
  }

  // 获取显示的工作签名（限制70个字符）
  String _getDisplayWorkSignature(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_currentWorkSignature == null || _currentWorkSignature!.isEmpty) {
      return l10n.translate('add_work_signature');
    }
    
    if (_currentWorkSignature!.length > 70) {
      return '${_currentWorkSignature!.substring(0, 70)}...';
    }
    
    return _currentWorkSignature!;
  }

  // 获取状态对应的颜色
  Color _getStatusColor(String statusValue) {
    switch (statusValue) {
      case 'online':
        return const Color(0xFF52C41A); // 绿色
      case 'busy':
        return const Color(0xFFFF4D4F); // 红色
      case 'away':
        return const Color(0xFFFAAD14); // 黄色
      case 'offline':
        return const Color(0xFFBFBFBF); // 灰色
      default:
        return const Color(0xFF52C41A); // 默认绿色
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 用户信息头部
          _buildUserHeader(context),
          // 分隔
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          // 菜单项列表
          _buildMenuItems(context),
        ],
      ),
    );
  }

  // 用户信息头部
  Widget _buildUserHeader(BuildContext context) {
    // 获取显示的姓名（优先使用当前状态的fullName，如果没有或为空则使用username）
    final displayName = (_currentFullName != null && _currentFullName!.isNotEmpty)
        ? _currentFullName!
        : widget.username;
    final avatarText = displayName.length >= 2
        ? displayName.substring(displayName.length - 2)
        : displayName;

    return InkWell(
      onTap: () {
        // 显示个人基本信息弹窗
        UserInfoDialog.show(
          context,
          username: widget.username,
          userId: widget.userId,
          status: _currentStatus,
          token: widget.token, // 传递token
          fullName: _currentFullName,
          gender: _currentGender ?? widget.gender,
          workSignature: _currentWorkSignature,
          landline: _currentLandline,
          shortNumber: _currentShortNumber,
          email: _currentEmail,
          department: _currentDepartment,
          position: _currentPosition,
          region: _currentRegion,
          avatar: _currentAvatar ?? widget.avatar, // 使用当前头像状态
          inviteCode: widget.inviteCode, // 传递邀请码
          onEdit: () async {
            // 编辑完成后不关闭菜单，只刷新数据
            // 重新获取用户信息以更新所有字段
            try {
              final response = await ApiService.getUserProfile(
                token: widget.token,
              );
              if (response['code'] == 0 && response['data'] != null) {
                final userData = response['data']['user'];
                if (mounted) {
                  setState(() {
                    _currentAvatar = userData['avatar'] as String?;
                    _currentFullName = userData['full_name'] as String?;
                    _currentGender = userData['gender'] as String?;
                    _currentWorkSignature = userData['work_signature'] as String?;
                    _currentLandline = userData['landline'] as String?;
                    _currentShortNumber = userData['short_number'] as String?;
                    _currentEmail = userData['email'] as String?;
                    _currentDepartment = userData['department'] as String?;
                    _currentPosition = userData['position'] as String?;
                    _currentRegion = userData['region'] as String?;
                  });
                  logger.debug('✅ [个人资料更新] UserProfileMenu 所有字段已更新');
                }
              }
            } catch (e) {
              logger.debug('❌ [个人资料更新] 获取用户信息失败: $e');
            }
            // 通知外部更新用户信息（这会重新加载用户信息并更新主页面的头像）
            widget.onProfileUpdated?.call();
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 头像
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: _currentAvatar != null && _currentAvatar!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _currentAvatar!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                avatarText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          avatarText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                // 在线状态指示器
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: _getStatusColor(_currentStatus),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // 用户信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _truncateDisplayName(
                            (_currentFullName != null && _currentFullName!.isNotEmpty)
                                ? _currentFullName!
                                : widget.username,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Color(0xFF4A90E2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.organization,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 菜单项列
  Widget _buildMenuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.edit_outlined,
          title: _getDisplayWorkSignature(context),
          onTap: () {
            // 显示编辑工作签名对话
            _showEditWorkSignatureDialog(context);
          },
        ),
        _buildMenuItem(
          icon: Icons.folder_outlined,
          iconColor: const Color(0xFF52C41A),
          title: l10n.translate('file_transfer_assistant'),
          onTap: () {
            Navigator.pop(context);
            // 调用文件传输助手回调
            widget.onFileAssistantTap?.call();
          },
        ),
        _buildMenuItem(
          icon: Icons.access_time,
          title: l10n.translate('status'),
          hasArrow: true,
          onTap: () {
            // 显示状态选择对话
            _showStatusSelectionDialog(context);
          },
        ),
        _buildMenuItem(
          icon: Icons.star_outline,
          title: l10n.translate('favorites'),
          onTap: () {
            logger.debug('🌟 点击了收藏按钮');
            Navigator.pop(context);
            logger.debug('🌟 关闭个人信息菜单');
            // 显示收藏列表对话
            try {
              logger.debug('🌟 准备显示收藏对话');
              FavoritesDialog.show(context);
              logger.debug('🌟 收藏对话框显示成功');
            } catch (e) {
              logger.debug('显示收藏对话框失败: $e');
            }
          },
        ),
        // 分隔
        const Divider(
          height: 1,
          color: Color(0xFFE5E5E5),
          indent: 16,
          endIndent: 16,
        ),
        _buildMenuItem(
          icon: Icons.headset_mic_outlined,
          title: l10n.translate('customer_service'),
          onTap: () {
            Navigator.pop(context);
            // 显示客服与帮助对话框
            CustomerServiceDialog.show(context);
          },
        ),
        _buildMenuItem(
          icon: Icons.lock_outline,
          title: l10n.translate('change_password'),
          onTap: () {
            Navigator.pop(context);
            // 显示修改密码对话
            ChangePasswordDialog.show(context, token: widget.token);
          },
        ),
        _buildMenuItem(
          icon: Icons.settings_outlined,
          title: l10n.translate('settings'),
          onTap: () {
            Navigator.pop(context);
            // 显示设置对话
            SettingsDialog.show(context);
          },
        ),
        // 分隔
        const Divider(
          height: 1,
          color: Color(0xFFE5E5E5),
          indent: 16,
          endIndent: 16,
        ),
        _buildMenuItem(
          icon: Icons.swap_horiz,
          title: l10n.translate('switch_account'),
          onTap: () async {
            // 显示加载对话
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (loadingContext) =>
                  const Center(child: CircularProgressIndicator()),
            );

            // 先通过API设置用户状态为离线
            final token = await Storage.getToken();
            if (token != null) {
              try {
                await ApiService.updateStatus(token: token, status: 'offline');
                logger.debug('✅ 用户状态已设置为离线');
              } catch (e) {
                logger.debug('⚠️ 设置离线状态失败: $e');
              }
            }

            // 再通过WebSocket发送离线状态并断开连接
            try {
              await _wsService.disconnect(sendOfflineStatus: true);
              logger.debug('WebSocket已断开，离线状态已发送');
            } catch (e) {
              logger.debug('⚠️ 断开WebSocket失败: $e');
            }

            // 清除登录信息（token、userId、username）
            // 先获取当前用户ID，用于清除该用户的保存密码
            final currentUserId = await Storage.getUserId();
            await Storage.clearLoginInfo();

            // PC端：清除保存的账号密码，这样下次打开应用会进入登录页面
            if (currentUserId != null) {
              await Storage.clearSavedCredentials(currentUserId);
              logger.debug('✅ 已清除保存的账号密码');
            }

            // 重置升级检查器，以便新账号登录后重新检查更新
            UpdateChecker().reset();
            logger.debug('🔄 已重置升级检查器');

            // 导航到登录页面
            logger.info('🚪 切换账号，跳转到登录页面');
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage(clearCredentials: true)),
                (route) => false,
              );
            }
          },
        ),
        _buildMenuItem(
          icon: Icons.exit_to_app,
          title: l10n.translate('exit_telegram'),
          onTap: () {
            // 不要先关闭菜单，直接显示确认对话
            _showLogoutDialog(context);
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // 单个菜单项
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    bool hasArrow = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? const Color(0xFF666666)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
            ),
            if (hasArrow)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFFCCCCCC),
              ),
          ],
        ),
      ),
    );
  }

  // 显示编辑工作签名对话
  void _showEditWorkSignatureDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: _currentWorkSignature);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.translate('edit_work_signature')),
        content: TextField(
          controller: controller,
          maxLength: 500,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.translate('work_signature_hint'),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.translate('cancel')),
          ),
          TextButton(
            onPressed: () async {
              final newSignature = controller.text.trim();
              Navigator.pop(dialogContext); // 关闭编辑对话
              // 调用API保存工作签名
              await _updateWorkSignature(context, newSignature);
            },
            child: Text(l10n.translate('confirm')),
          ),
        ],
      ),
    );
  }

  // 更新工作签名
  Future<void> _updateWorkSignature(
    BuildContext context,
    String newSignature,
  ) async {
    final l10n = AppLocalizations.of(context);
    
    try {
      // 使用widget中的token，避免从Storage读取被其他窗口覆盖的token
      final token = widget.token;
      if (token.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.translate('please_login_first'))));
        }
        return;
      }

      // 显示加载
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // 调用API
      final response = await ApiService.updateWorkSignature(
        token: token,
        workSignature: newSignature,
      );

      // 关闭加载
      if (context.mounted) Navigator.pop(context);

      if (response['code'] == 0) {
        // 更新本地状态
        setState(() {
          _currentWorkSignature = newSignature;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.translate('work_signature_updated'))));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? l10n.translate('update_failed'))),
          );
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // 关闭加载
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.translate('update_failed')}: $e')));
      }
    }
  }

  // 显示状态选择对话
  void _showStatusSelectionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusOption(
                dialogContext,
                context,
                'online',
                l10n.translate('status_online'),
                const Color(0xFF52C41A),
              ),
              _buildStatusOption(
                dialogContext,
                context,
                'busy',
                l10n.translate('status_busy'),
                const Color(0xFFFF4D4F),
              ),
              _buildStatusOption(
                dialogContext,
                context,
                'away',
                l10n.translate('status_away'),
                const Color(0xFFFAAD14),
              ),
              _buildStatusOption(
                dialogContext,
                context,
                'offline',
                l10n.translate('status_offline'),
                const Color(0xFFBFBFBF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建状态选项
  Widget _buildStatusOption(
    BuildContext dialogContext,
    BuildContext menuContext,
    String statusValue,
    String statusLabel,
    Color statusColor,
  ) {
    final isSelected = _currentStatus == statusValue;

    return InkWell(
      onTap: () {
        Navigator.pop(dialogContext); // 关闭状态选择弹窗
        _updateStatus(menuContext, statusValue, widget.onStatusChanged);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                statusLabel,
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: 18, color: Color(0xFF52C41A)),
          ],
        ),
      ),
    );
  }

  // 更新状态
  Future<void> _updateStatus(
    BuildContext context,
    String newStatus,
    Function(String)? onStatusChanged,
  ) async {
    if (newStatus == _currentStatus) return;
    
    final l10n = AppLocalizations.of(context);

    try {
      // 使用widget中的token，避免从Storage读取被其他窗口覆盖的token
      final token = widget.token;
      if (token.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.translate('please_login_first'))));
        }
        return;
      }

      // 显示加载
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // 调用API
      final response = await ApiService.updateStatus(
        token: token,
        status: newStatus,
      );

      // 关闭加载
      if (context.mounted) Navigator.pop(context);

      if (response['code'] == 0) {
        // 更新本地状态
        setState(() {
          _currentStatus = newStatus;
        });

        // 调用回调通知状态已更新
        onStatusChanged?.call(newStatus);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.translate('status_updated')}: ${_getStatusText(context, newStatus)}')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? l10n.translate('update_status_failed'))),
          );
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // 关闭加载
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.translate('update_status_failed')} $e')));
      }
    }
  }

  // 获取状态文本
  String _getStatusText(BuildContext context, String statusValue) {
    final l10n = AppLocalizations.of(context);
    switch (statusValue) {
      case 'online':
        return l10n.translate('status_online');
      case 'busy':
        return l10n.translate('status_busy');
      case 'away':
        return l10n.translate('status_away');
      case 'offline':
        return l10n.translate('status_offline');
      default:
        return l10n.translate('status_online');
    }
  }

  // 显示退出登录确认对话框
  void _showLogoutDialog(BuildContext menuContext) {
    final l10n = AppLocalizations.of(menuContext);
    
    showDialog(
      context: menuContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.translate('exit_telegram_title')),
        content: Text(l10n.translate('confirm_logout')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.translate('cancel')),
          ),
          TextButton(
            onPressed: () async {
              // 关闭确认对话
              Navigator.pop(dialogContext);

              // 显示加载对话
              showDialog(
                context: menuContext,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              // 先通过API设置用户状态为离线
              final token = await Storage.getToken();
              if (token != null) {
                try {
                  await ApiService.updateStatus(
                    token: token,
                    status: 'offline',
                  );
                  logger.debug('✅ 用户状态已设置为离线');
                } catch (e) {
                  logger.debug('⚠️ 设置离线状态失败: $e');
                }
              }

              // 再通过WebSocket发送离线状态并断开连接
              try {
                await _wsService.disconnect(sendOfflineStatus: true);
                logger.debug('WebSocket已断开，离线状态已发送');
              } catch (e) {
                logger.debug('⚠️ 断开WebSocket失败: $e');
              }

              // 清除登录信息（token、userId、username）
              // 先获取当前用户ID，用于清除该用户的保存密码和最后页面路径
              final currentUserId = await Storage.getUserId();
              
              // 保存当前页面路径（退出登录前保存，方便下次自动登录后恢复）
              if (currentUserId != null && mounted) {
                final currentRoute = ModalRoute.of(context)?.settings.name ?? '/home';
                await Storage.saveLastPageRoute(currentUserId, currentRoute);
                logger.debug('📍 已保存最后页面路径: $currentRoute');
              }
              
              await Storage.clearLoginInfo();

              // PC端：清除保存的账号密码，这样下次打开应用会进入登录页面
              if (currentUserId != null) {
                await Storage.clearSavedCredentials(currentUserId);
                logger.debug('✅ 已清除保存的账号密码');
              }

              // 关闭应用
              logger.info('🚪 退出Telegram，退出应用');
              if (Platform.isAndroid || Platform.isIOS) {
                // 移动平台：使用 SystemNavigator.pop()
                SystemNavigator.pop();
              } else {
                // 桌面平台：使用 exit(0)
                exit(0);
              }
            },
            child: Text(l10n.translate('confirm')),
          ),
        ],
      ),
    );
  }
}
