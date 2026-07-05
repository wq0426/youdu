import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:window_manager/window_manager.dart';
import 'package:telegram/utils/storage.dart';
import 'package:telegram/utils/app_localizations.dart';
import 'package:telegram/main.dart';
import '../utils/logger.dart';
import '../services/update_service.dart';
import 'update_dialog.dart';

// 全局标志：设置对话框是否正在显示
bool _isSettingsDialogShowing = false;

// Getter 函数：获取设置对话框状态
bool isSettingsDialogShowing() => _isSettingsDialogShowing;

/// 设置对话
class SettingsDialog extends StatefulWidget {
  final VoidCallback? onIdleSettingsChanged; // 空闲设置变更回调

  const SettingsDialog({super.key, this.onIdleSettingsChanged});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();

  /// 显示设置对话
  static void show(
    BuildContext context, {
    VoidCallback? onIdleSettingsChanged,
  }) {
    _isSettingsDialogShowing = true;
    showDialog(
      context: context,
      builder: (context) =>
          SettingsDialog(onIdleSettingsChanged: onIdleSettingsChanged),
    ).whenComplete(() {
      _isSettingsDialogShowing = false;
    });
  }
}

class _SettingsDialogState extends State<SettingsDialog> {
  int _selectedMenuIndex = 0; // 0: 通用, 1: 消息通知, 2: 快捷键, 3: 关于

  // 通用设置状态
  final TextEditingController _messagePathController = TextEditingController(
    text: 'C:\\Users\\WIN10\\Documents\\telegram-files',
  );
  final TextEditingController _filePathController = TextEditingController(
    text: 'C:\\Users\\WIN10\\Documents\\telegram-files\\16119908-100022\\files',
  );
  final TextEditingController _autoDownloadSizeController =
      TextEditingController(text: '30');
  final TextEditingController _idleMinutesController = TextEditingController(
    text: '5',
  );
  bool _autoDownloadEnabled = true;
  bool _idleStatusEnabled = true;
  String _selectedLanguage = '简体中文';
  
  // 版本信息
  String _versionInfo = '加载中...';
  String _selectedZoom = '75%（默认）';

  // 消息通知设置状态
  bool _newMessageSoundEnabled = false;
  bool _newMessagePopupEnabled = true;

  // 快捷键设置状态
  Map<String, String> _shortcuts = {
    'sendMessage': 'Enter',
    'toggleWindow': 'Alt+1',
    'screenshot': 'Alt+2',
  };

  // 默认快捷键
  final Map<String, String> _defaultShortcuts = {
    'sendMessage': 'Enter',
    'toggleWindow': 'Alt+1',
    'screenshot': 'Alt+2',
  };

  // 当前正在编辑的快捷键
  String? _editingShortcut;

  // Focus node for keyboard listening
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedPaths();
    _loadSavedLanguage();
    _loadSavedZoom();
    _loadNotificationSettings();
    _loadVersionInfo();
  }
  
  /// 加载版本信息
  Future<void> _loadVersionInfo() async {
    try {
      final versionData = await UpdateService.getCurrentVersion();
      final version = versionData['version'] ?? '未知';
      final versionCode = versionData['versionCode'] ?? version;
      
      // 格式化版本号：v1.0.4-1765520149
      String formattedVersion;
      if (version != versionCode && versionCode.isNotEmpty) {
        formattedVersion = 'v$version-$versionCode';
      } else {
        formattedVersion = 'v$version';
      }
      
      if (mounted) {
        setState(() {
          _versionInfo = formattedVersion;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _versionInfo = 'v1.0.0';
        });
      }
    }
  }

  /// 检查新版本
  Future<void> _checkForUpdate() async {
    final i18n = AppLocalizations.of(context);
    
    // 显示检查中的对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Text(i18n.translate('checking_update')),
          ],
        ),
      ),
    );

    try {
      final updateService = UpdateService();
      final updateInfo = await updateService.checkUpdate();

      // 关闭检查中的对话框
      if (mounted) {
        Navigator.pop(context);
      }

      if (updateInfo != null && mounted) {
        // 有新版本，显示更新对话框
        await UpdateDialog.show(
          context,
          updateInfo,
          onUpdateComplete: () {
            // 更新完成回调
          },
        );
      } else if (mounted) {
        // 没有新版本，显示提示
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(i18n.translate('check_update')),
              ],
            ),
            content: Text(i18n.translate('no_update')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(i18n.translate('confirm')),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // 关闭检查中的对话框
      if (mounted) {
        Navigator.pop(context);
      }
      
      // 显示错误提示
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Text(i18n.translate('check_update')),
              ],
            ),
            content: Text(i18n.translate('update_check_failed')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(i18n.translate('confirm')),
              ),
            ],
          ),
        );
      }
    }
  }

  /// 加载保存的语言设置
  Future<void> _loadSavedLanguage() async {
    final languageCode = await Storage.getLanguage();
    setState(() {
      _selectedLanguage = AppLocalizations.getLanguageName(languageCode);
    });
  }

  /// 加载保存的窗口缩放设置
  Future<void> _loadSavedZoom() async {
    final zoomFactor = await Storage.getWindowZoom();
    setState(() {
      _selectedZoom = _getZoomLabel(zoomFactor);
    });
  }

  /// 加载保存的消息通知设置
  Future<void> _loadNotificationSettings() async {
    final soundEnabled = await Storage.getNewMessageSoundEnabled();
    final popupEnabled = await Storage.getNewMessagePopupEnabled();
    setState(() {
      _newMessageSoundEnabled = soundEnabled;
      _newMessagePopupEnabled = popupEnabled;
    });
  }

  /// 将缩放比例转换为标签
  String _getZoomLabel(double factor) {
    final i18n = AppLocalizations.of(context);
    if (factor == 0.75) return i18n.translate('window_zoom_default');
    if (factor == 1.0) return '100%';
    if (factor == 1.25) return '125%';
    if (factor == 1.5) return '150%';
    if (factor == 1.75) return '175%';
    if (factor == 2.0) return '200%';
    return i18n.translate('window_zoom_default');
  }

  /// 将标签转换为缩放比例
  double _getZoomFactor(String label) {
    final i18n = AppLocalizations.of(context);
    if (label == i18n.translate('window_zoom_default') || label == '75%（默认）' || label == '75%') return 0.75;
    if (label == '100%') return 1.0;
    if (label == '125%') return 1.25;
    if (label == '150%') return 1.5;
    if (label == '175%') return 1.75;
    if (label == '200%') return 2.0;
    return 0.75;
  }

  @override
  void dispose() {
    _messagePathController.dispose();
    _filePathController.dispose();
    _autoDownloadSizeController.dispose();
    _idleMinutesController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 加载保存的路径设置
  Future<void> _loadSavedPaths() async {
    final filePath = await Storage.getFileStoragePath();
    final messagePath = await Storage.getMessageStoragePath();
    final autoDownloadEnabled = await Storage.getAutoDownloadEnabled();
    final autoDownloadSize = await Storage.getAutoDownloadSizeMB();

    setState(() {
      if (filePath != null) {
        _filePathController.text = filePath;
      }

      if (messagePath != null) {
        _messagePathController.text = messagePath;
      }

      _autoDownloadEnabled = autoDownloadEnabled;
      _autoDownloadSizeController.text = autoDownloadSize.toString();
    });

    // 加载闲置状态设置
    final idleStatusEnabled = await Storage.getIdleStatusEnabled();
    final idleMinutes = await Storage.getIdleMinutes();

    setState(() {
      _idleStatusEnabled = idleStatusEnabled;
      _idleMinutesController.text = idleMinutes.toString();
    });
  }

  // 处理键盘事件
  void _handleKeyEvent(KeyEvent event) {
    if (_editingShortcut == null) return;
    if (event is! KeyDownEvent) return;

    // Escape 键取消编码
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      setState(() {
        _editingShortcut = null;
      });
      return;
    }

    final List<String> keys = [];

    // 检查修饰键
    if (HardwareKeyboard.instance.isControlPressed) keys.add('Ctrl');
    if (HardwareKeyboard.instance.isAltPressed) keys.add('Alt');
    if (HardwareKeyboard.instance.isShiftPressed) keys.add('Shift');
    if (HardwareKeyboard.instance.isMetaPressed) keys.add('Win');

    // 获取按键标签
    final label = event.logicalKey.keyLabel;

    // 排除单独的修饰键
    if (label.isNotEmpty &&
        !['Control', 'Alt', 'Shift', 'Meta'].contains(label)) {
      // 处理特殊键名
      String keyName = label;
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        keyName = 'Enter';
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        keyName = 'Space';
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        keyName = 'Tab';
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        keyName = 'Backspace';
      } else if (event.logicalKey == LogicalKeyboardKey.delete) {
        keyName = 'Delete';
      }

      keys.add(keyName);
    }

    if (keys.isNotEmpty) {
      setState(() {
        _shortcuts[_editingShortcut!] = keys.join('+');
        _editingShortcut = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SizedBox(
          width: 850,
          height: 900,
          child: Row(
            children: [
              // 左侧菜单
              _buildLeftMenu(),
              // 右侧内容
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  // 左侧菜单
  Widget _buildLeftMenu() {
    final i18n = AppLocalizations.of(context);
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border(right: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              i18n.translate('settings_title'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
          // 菜单项
          _buildMenuItem(0, Icons.settings_outlined, i18n.translate('general')),
          _buildMenuItem(
            1,
            Icons.notifications_outlined,
            i18n.translate('message_notification'),
          ),
          _buildMenuItem(
            2,
            Icons.keyboard_outlined,
            i18n.translate('shortcuts'),
          ),
          _buildMenuItem(3, Icons.info_outline, i18n.translate('about')),
        ],
      ),
    );
  }

  // 菜单项
  Widget _buildMenuItem(int index, IconData icon, String title) {
    final isSelected = _selectedMenuIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMenuIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 右侧内容
  Widget _buildContent() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 标题
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getContentTitle(context),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: _buildContentByIndex(),
            ),
          ),
        ],
      ),
    );
  }

  String _getContentTitle(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    switch (_selectedMenuIndex) {
      case 0:
        return i18n.translate('general');
      case 1:
        return i18n.translate('message_notification');
      case 2:
        return i18n.translate('shortcuts');
      case 3:
        return i18n.translate('about');
      default:
        return i18n.translate('general');
    }
  }

  Widget _buildContentByIndex() {
    switch (_selectedMenuIndex) {
      case 0:
        return _buildGeneralSettings();
      case 1:
        return _buildNotificationSettings();
      case 2:
        return _buildShortcutSettings();
      case 3:
        return _buildAboutSettings();
      default:
        return _buildGeneralSettings();
    }
  }

  // 通用设置
  Widget _buildGeneralSettings() {
    final i18n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 消息存储路径
        Text(
          i18n.translate('message_storage_path'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          i18n.translate('message_storage_hint'),
          style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
        ),
        const SizedBox(height: 12),
        _buildPathInput(_messagePathController, showButton: false),
        const SizedBox(height: 32),

        // 文件存储路径
        Text(
          i18n.translate('file_storage_path'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          i18n.translate('file_storage_hint'),
          style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
        ),
        const SizedBox(height: 12),
        _buildPathInput(_filePathController, showButton: true),
        const SizedBox(height: 32),

        // 自动下载设置
        _buildSwitchSetting(
          title: i18n.translate('auto_download'),
          controller: _autoDownloadSizeController,
          suffix: i18n.translate('auto_download_hint'),
          value: _autoDownloadEnabled,
          onChanged: (value) async {
            setState(() {
              _autoDownloadEnabled = value;
            });
            // 保存开关状态
            await Storage.saveAutoDownloadEnabled(value);

            // 如果开关打开，也保存大小设置
            if (value) {
              final sizeMB =
                  int.tryParse(_autoDownloadSizeController.text) ?? 30;
              await Storage.saveAutoDownloadSizeMB(sizeMB);
            }

            logger.debug('  自动下载设置已保存: enabled=$value');
          },
          onTextChanged: (text) async {
            // 输入框文本变化时，如果开关打开则保存
            if (_autoDownloadEnabled) {
              final sizeMB = int.tryParse(text);
              if (sizeMB != null && sizeMB >= 0 && sizeMB <= 1024) {
                await Storage.saveAutoDownloadSizeMB(sizeMB);
                logger.debug('  自动下载大小限制已保存: ${sizeMB}MB');
              }
            }
          },
        ),
        const SizedBox(height: 24),

        // 闲置状态设置
        _buildSwitchSetting(
          title: i18n.translate('mouse_keyboard_idle'),
          controller: _idleMinutesController,
          suffix: i18n.translate('auto_offline_hint'),
          value: _idleStatusEnabled,
          onChanged: (value) async {
            setState(() {
              _idleStatusEnabled = value;
            });
            // 保存开关状态
            await Storage.saveIdleStatusEnabled(value);

            // 如果开关打开，也保存分钟设置
            if (value) {
              final minutes = int.tryParse(_idleMinutesController.text) ?? 5;
              await Storage.saveIdleMinutes(minutes);
            }

            logger.debug('  自动离线设置已保存: enabled=$value');

            // 通知 HomePage 重新初始化定时器
            widget.onIdleSettingsChanged?.call();
          },
          onTextChanged: (text) async {
            // 输入框文本变化时，如果开关打开则保存
            if (_idleStatusEnabled) {
              final minutes = int.tryParse(text);
              if (minutes != null && minutes > 0 && minutes <= 120) {
                await Storage.saveIdleMinutes(minutes);
                logger.debug('  自动离线时间已保存: $minutes分钟');

                // 通知 HomePage 重新初始化定时器
                widget.onIdleSettingsChanged?.call();
              }
            }
          },
        ),
        const SizedBox(height: 48),

        // 语言设置
        _buildDropdownSetting(
          title: i18n.translate('language_setting'),
          value: _selectedLanguage,
          items: ['简体中文', 'English', '繁體中文'],
          onChanged: (value) async {
            if (value == null) return;

            setState(() {
              _selectedLanguage = value;
            });

            // 将语言名称转换为语言代码
            final languageCode = AppLocalizations.getLanguageCode(value);

            // 保存到本地存储
            await Storage.saveLanguage(languageCode);
            logger.debug('  语言设置已保存: $value ($languageCode)');

            // 立即切换应用语言
            final locale = AppLocalizations.getLocaleFromCode(languageCode);
            if (mounted) {
              MyApp.setLocale(context, locale);
              logger.debug('语言已切换，界面将立即更新');
            }
          },
        ),
        const SizedBox(height: 32),

        // 窗口缩放
        _buildDropdownSetting(
          title: i18n.translate('window_zoom'),
          value: _selectedZoom,
          items: [i18n.translate('window_zoom_default'), '100%', '125%', '150%', '175%', '200%'],
          onChanged: (value) async {
            if (value == null) return;

            setState(() {
              _selectedZoom = value;
            });

            // 获取缩放比例
            final zoomFactor = _getZoomFactor(value);

            // 保存到本地存储
            await Storage.saveWindowZoom(zoomFactor);
            logger.debug('  窗口缩放设置已保存: $value (${zoomFactor}x)');

            // 仅在桌面平台应用窗口缩放
            if (!Platform.isAndroid && !Platform.isIOS) {
              try {
                // 获取当前窗口大小
                final currentSize = await windowManager.getSize();
                logger.debug(
                  '📐 当前窗口大小: ${currentSize.width} x ${currentSize.height}',
                );

                // 计算新的窗口大小（基准：1280x900）
                const baseWidth = 1280.0;
                const baseHeight = 900.0;
                final newWidth = baseWidth * zoomFactor;
                final newHeight = baseHeight * zoomFactor;

                logger.debug('🎯 目标窗口大小: $newWidth x $newHeight');

                // 确保窗口可以调整大小
                await windowManager.setResizable(true);

                // 临时设置最小和最大尺寸为目标尺寸，确保窗口能够调整到这个大小
                await windowManager.setMinimumSize(Size(newWidth, newHeight));
                await windowManager.setMaximumSize(Size(newWidth, newHeight));

                // 应用新的窗口大小
                await windowManager.setSize(Size(newWidth, newHeight));
                logger.debug('  窗口已调整为: $newWidth x $newHeight');

                // 窗口居中
                await windowManager.center();

                // 恢复最小尺寸限制，移除最大尺寸限制
                await Future.delayed(const Duration(milliseconds: 100));
                await windowManager.setMinimumSize(const Size(800, 600));
                await windowManager.setMaximumSize(const Size(9999, 9999));

                // 验证新的窗口大小
                final verifySize = await windowManager.getSize();
                logger.debug(
                  '🔍 验证窗口大小: ${verifySize.width} x ${verifySize.height}',
                );

                // 显示提示
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${i18n.translate('window_zoom_applied')} $value'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                logger.debug('  设置窗口大小失败: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${i18n.translate('window_resize_failed')}: $e'),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
    );
  }

  // 路径输入
  Widget _buildPathInput(
    TextEditingController controller, {
    required bool showButton,
  }) {
    final i18n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder, size: 20, color: Color(0xFF4A90E2)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: false,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showButton) ...[
          const SizedBox(width: 12),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () async {
                // 打开文件夹选择
                String? selectedDirectory = await FilePicker.platform
                    .getDirectoryPath();
                if (selectedDirectory != null) {
                  setState(() {
                    controller.text = selectedDirectory;
                  });

                  // 立即保存到持久化存储
                  if (controller == _filePathController) {
                    await Storage.saveFileStoragePath(selectedDirectory);
                    logger.debug('文件存储路径已保存: $selectedDirectory');
                  } else if (controller == _messagePathController) {
                    await Storage.saveMessageStoragePath(selectedDirectory);
                    logger.debug('  消息存储路径已保存: $selectedDirectory');
                  }

                  // 显示保存成功提示
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(i18n.translate('path_saved')),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                i18n.translate('change'),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // 带开关的设置
  Widget _buildSwitchSetting({
    required String title,
    required TextEditingController controller,
    required String suffix,
    required bool value,
    required ValueChanged<bool> onChanged,
    ValueChanged<String>? onTextChanged,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          height: 36,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onTextChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF4A90E2)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          suffix,
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: const Color(0xFF4A90E2),
        ),
      ],
    );
  }

  // 下拉框设置项
  Widget _buildDropdownSetting({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 24),
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 消息通知设置
  Widget _buildNotificationSettings() {
    final i18n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 新消息提示音
        _buildNotificationSwitch(
          title: i18n.translate('new_message_sound'),
          value: _newMessageSoundEnabled,
          onChanged: (value) async {
            setState(() {
              _newMessageSoundEnabled = value;
            });
            // 保存到本地存储
            await Storage.saveNewMessageSoundEnabled(value);
            logger.debug('💾 新消息提示音设置已保存: $value');
          },
        ),
        const SizedBox(height: 24),
        // 新消息弹窗显示（系统通知）
        _buildNotificationSwitch(
          title: i18n.translate('new_message_popup'),
          value: _newMessagePopupEnabled,
          onChanged: (value) async {
            setState(() {
              _newMessagePopupEnabled = value;
            });
            // 保存到本地存储
            await Storage.saveNewMessagePopupEnabled(value);
            logger.debug('💾 新消息弹窗显示设置已保存: $value');
          },
        ),
      ],
    );
  }

  // 消息通知开关项
  Widget _buildNotificationSwitch({
    required String title,
    required bool value,
    required Future<void> Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
        ),
        Switch(
          value: value,
          onChanged: (bool newValue) => onChanged(newValue),
          activeTrackColor: const Color(0xFF4A90E2),
        ),
      ],
    );
  }

  // 快捷键设置
  Widget _buildShortcutSettings() {
    final i18n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 发送消息
        _buildShortcutItem(label: i18n.translate('send_message_shortcut'), shortcutKey: 'sendMessage'),
        const SizedBox(height: 24),
        // 显示/隐藏主窗
        _buildShortcutItem(label: i18n.translate('toggle_window_shortcut'), shortcutKey: 'toggleWindow'),
        const SizedBox(height: 24),
        // 截屏
        _buildShortcutItem(label: i18n.translate('screenshot_shortcut'), shortcutKey: 'screenshot'),
        const SizedBox(height: 48),
        // 恢复默认按钮
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            onPressed: _restoreDefaultShortcuts,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              side: const BorderSide(color: Color(0xFFDDDDDD)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              i18n.translate('restore_default'),
              style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
            ),
          ),
        ),
      ],
    );
  }

  // 快捷键项
  Widget _buildShortcutItem({
    required String label,
    required String shortcutKey,
  }) {
    final i18n = AppLocalizations.of(context);
    final shortcutValue = _shortcuts[shortcutKey] ?? '';
    final isEditing = _editingShortcut == shortcutKey;

    return Row(
      children: [
        // 标签
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
          ),
        ),
        const SizedBox(width: 24),
        // 快捷键显示框
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _editingShortcut = shortcutKey;
              });
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isEditing ? const Color(0xFFFFF9E6) : Colors.white,
                border: Border.all(
                  color: isEditing
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFFDDDDDD),
                  width: isEditing ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? i18n.translate('press_shortcut_key') : shortcutValue,
                      style: TextStyle(
                        fontSize: 14,
                        color: isEditing
                            ? const Color(0xFF999999)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  // 清除按钮
                  if (shortcutValue.isNotEmpty && !isEditing)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _shortcuts[shortcutKey] = '';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 下拉箭头
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDDDDD)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.arrow_drop_down, color: Color(0xFF999999)),
        ),
      ],
    );
  }

  // 恢复默认快捷键
  void _restoreDefaultShortcuts() {
    setState(() {
      _shortcuts = Map.from(_defaultShortcuts);
      _editingShortcut = null;
    });
  }

  // 关于设置
  Widget _buildAboutSettings() {
    final i18n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 应用信息区域
        Row(
          children: [
            // 应用图标
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chat_bubble,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            // 版本信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i18n.translate('app_version'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        i18n.translate('version_number'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      Text(
                        _versionInfo,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _versionInfo));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(i18n.translate('copied')),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          i18n.translate('copy'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 检查新版本按钮
            SizedBox(
              height: 36,
              child: OutlinedButton(
                onPressed: _checkForUpdate,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4A90E2)),
                  foregroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Text(i18n.translate('check_update'), style: const TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
        // 版权信息
        Center(
          child: Text(
            i18n.translate('copyright'),
            style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ),
      ],
    );
  }
}
