import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import 'package:telegram/services/api_service.dart';
import 'package:telegram/services/websocket_service.dart';
import 'package:telegram/services/auth_state_service.dart';
import 'package:telegram/utils/storage.dart';
import 'package:telegram/utils/app_localizations.dart';
import '../utils/logger.dart';
import '../services/theme_service.dart';
import 'mobile_chat_page.dart';
import 'mobile_contacts_page.dart';
import 'mobile_home_page.dart';
import '../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  final bool clearCredentials; // 是否清空保存的账号密码
  final String? prefillAccount; // 预填充的账号（用于切换账号时）
  
  const LoginPage({super.key, this.clearCredentials = false, this.prefillAccount});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // PC端保留记住密码和自动登录选项
  bool _rememberPassword = false;
  bool _autoLogin = false;
  bool _obscurePassword = true;
  String _selectedLanguage = '简体中文'; // 当前选择的语言
  bool _canLogin = false;
  bool _isLoading = false; // 登录加载状态

  // PC端扫码登录状态
  Timer? _qrPollTimer;
  String? _qrId;
  // loading:生成中 / pending:等待扫描 / scanned:已扫描待手机确认
  // cancelled:手机取消 / expired:二维码失效 / error:生成失败
  String _qrStatus = 'loading';
  String _scannedNickname = '';

  // 检测是否是PC端
  bool get _isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_checkCanLogin);
    _passwordController.addListener(_checkCanLogin);

    if (_isDesktop) {
      // 🔴 PC端只允许扫码登录：进入登录页即生成二维码
      _createQRLoginSession();
    } else {
      // 移动端：加载保存的登录信息
      _loadSavedCredentials();
    }


    // 🔴 页面加载完成后清除之前的 SnackBar 提示（如"您的账号已在其他设备登录"）
    // 🔴 同时清除 WebSocket 的 onForcedLogout 回调，防止旧连接继续触发提示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        
        // 🔴 清除 WebSocket 回调，防止旧连接继续触发登出提示
        WebSocketService().onForcedLogout = null;
        
        // 🔴 确保 WebSocket 完全断开
        WebSocketService().disconnect(sendOfflineStatus: false);
        
        // 🔴 重置认证状态服务
        AuthStateService().reset();
      }
    });
  }

  // 加载保存的登录配置和账号密码信息
  Future<void> _loadSavedCredentials() async {
    logger.debug('🔍 开始加载保存的登录配置...');
    
    // 如果是切换账号进入，清空输入框
    if (widget.clearCredentials) {
      logger.debug('🗑️ 切换账号模式，清空输入框');
      if (!mounted) return;
      setState(() {
        _accountController.clear();
        _passwordController.clear();
      });
      return;
    }
    
    // 如果有预填充的账号，先填充
    if (widget.prefillAccount != null && widget.prefillAccount!.isNotEmpty) {
      logger.debug('📝 预填充账号: ${widget.prefillAccount}');
      if (!mounted) return;
      setState(() {
        _accountController.text = widget.prefillAccount!;
      });
    }
    
    // 获取最近一次登录的用户ID
    final lastUserId = await Storage.getLastLoggedInUserId();
    if (!mounted) return;
    
    if (lastUserId != null) {
      if (_isDesktop) {
        // PC端：加载记住密码和自动登录配置
        final rememberPassword = await Storage.getRememberPassword(lastUserId);
        final autoLogin = await Storage.getAutoLogin(lastUserId);
        
        logger.debug('📋 PC端加载的配置: rememberPassword=$rememberPassword, autoLogin=$autoLogin');
        
        if (!mounted) return;
        setState(() {
          _rememberPassword = rememberPassword;
          _autoLogin = autoLogin;
        });
        
        // 如果勾选了记住密码，加载账号密码
        if (rememberPassword) {
          final savedAccount = await Storage.getSavedAccountForLastUser();
          final savedPassword = await Storage.getSavedPasswordForLastUser();

          logger.debug(
            '📋 加载的账号密码: account=${savedAccount != null ? "已保存" : "未保存"}, password=${savedPassword != null ? "已保存" : "未保存"}',
          );

          if (!mounted) return;
          if (savedAccount != null && savedPassword != null) {
            setState(() {
              _accountController.text = savedAccount;
              _passwordController.text = savedPassword;
            });
            logger.debug('✅ 已填充账号密码到输入框');
          }
        }
      } else {
        // 移动端：直接加载最近一次登录的账号密码（简化逻辑）
        final savedAccount = await Storage.getSavedAccountForLastUser();
        final savedPassword = await Storage.getSavedPasswordForLastUser();

        logger.debug(
          '📋 移动端加载的账号密码: account=${savedAccount != null ? "已保存" : "未保存"}, password=${savedPassword != null ? "已保存" : "未保存"}',
        );

        if (!mounted) return;
        if (savedAccount != null && savedPassword != null) {
          setState(() {
            _accountController.text = savedAccount;
            _passwordController.text = savedPassword;
          });
          logger.debug('✅ 已填充账号密码到输入框');
        }
      }
    } else {
      logger.debug('ℹ️ 没有最近登录的用户ID');
    }
  }

  void _checkCanLogin() {
    setState(() {
      // 账号登录：账号和密码都有内容
      _canLogin =
          _accountController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  // 处理账号密码登录
  Future<void> _handleAccountLogin() async {
    // 🔴 清除之前的 SnackBar 提示（如"您的账号已在其他设备登录"）
    ScaffoldMessenger.of(context).clearSnackBars();

    // 设置加载状态
    setState(() {
      _isLoading = true;
    });

    final username = _accountController.text.trim();
    final password = _passwordController.text;

    try {
      final result = await ApiService.login(
        username: username,
        password: password,
      );

      if (result['code'] == 0) {
        // 登录成功
        final token = result['data']['token'];
        final user = result['data']['user'];

        // 保存登录配置和账号密码（根据平台和用户选择）
        await _saveCredentials(user['id'], username, password);

        // 完成登录（保存token、拉取配置、清缓存、跳转主页）
        await _completeLogin(token, user);
      } else {
        // 登录失败，重置加载状态
        setState(() {
          _isLoading = false;
        });

        // 显示错误消息（服务器会自动踢掉已登录的设备，不需要特殊处理）
        final message = result['message'] ?? '登录失败';
        _showError(message);
      }
    } catch (e) {
      // 出错时重置加载状态
      setState(() {
        _isLoading = false;
      });
      _showError('登录失败: $e');
    }
  }

  // 登录成功后的公共流程：保存token、拉取OSS配置、清缓存、跳转主页
  // （移动端账号密码登录和PC端扫码登录共用）
  Future<void> _completeLogin(String token, Map<String, dynamic> user) async {
    // 🔴 重置 WebSocket 强制登出状态，允许重新建立连接
    WebSocketService().resetForcedLogoutState();

    // 保存token和用户信息
    await Storage.saveLoginInfo(
      token: token,
      userId: user['id'],
      username: user['username'],
      fullName: user['full_name'],
      avatar: user['avatar'],
    );

    // 🔄 获取并保存OSS前缀域名配置
    logger.info('🔄 [OSS配置] 开始获取OSS前缀域名配置...');
    logger.debug('🔄 [OSS配置] Token: ${token.substring(0, 20)}...');
    try {
      logger.debug('🔄 [OSS配置] 调用 ApiService.getOSSPrefixConfig...');
      final ossConfigResult = await ApiService.getOSSPrefixConfig(token: token);
      logger.debug('🔄 [OSS配置] API返回结果: $ossConfigResult');

      if (ossConfigResult['code'] == 0) {
        final ossData = ossConfigResult['data'];
        logger.debug('🔄 [OSS配置] 解析数据: $ossData');

        await Storage.saveOSSPrefixConfig(
          oldPrefixDomain: ossData['old_prefix_domain'],
          newPrefixDomain: ossData['new_prefix_domain'],
        );
        logger.info('✅ [OSS配置] OSS前缀域名配置已保存: ${ossData['old_prefix_domain']} -> ${ossData['new_prefix_domain']}');
      } else {
        logger.debug('⚠️ [OSS配置] 获取OSS前缀域名配置失败: ${ossConfigResult['message']}');
      }
    } catch (e, stackTrace) {
      logger.debug('⚠️ [OSS配置] 获取OSS前缀域名配置异常: $e');
      logger.debug('⚠️ [OSS配置] 堆栈跟踪: $stackTrace');
    }

    // 重新初始化日志系统（使用用户ID）
    await logger.init(userId: user['id'].toString());
    logger.info('📝 日志系统已重新初始化，用户ID: ${user['id']}');

    // 注意：用户状态已在后端登录接口中自动设置为 online，无需前端再次设置
    logger.debug('✅ 用户登录成功，状态: ${user['status']}');

    // 🔵 阶段6：离线消息改由 Agora Chat 投递，不再清除后端同步记账记录。

    // 🔴 登录成功后清除所有本地缓存
    logger.info('🗑️ 登录成功，开始清除所有本地缓存...');
    MobileChatPage.clearAllCache();
    MobileContactsPage.clearAllCache();
    MobileHomePage.clearAllCache();

    // 🔴 清除Flutter图片缓存（避免切换账号后显示旧头像）
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    logger.info('🖼️ Flutter图片缓存已清除');

    logger.info('✅ 所有本地缓存已清除，即将重新加载数据');

    if (!mounted) return;
    _showSuccess('登录成功');

    // 跳转到主页
    Navigator.pushReplacementNamed(context, '/home');
  }

  // ==================== PC端扫码登录 ====================

  /// 创建扫码登录会话并开始轮询
  Future<void> _createQRLoginSession() async {
    _qrPollTimer?.cancel();
    setState(() {
      _qrStatus = 'loading';
      _qrId = null;
      _scannedNickname = '';
    });

    try {
      final result = await ApiService.createQRLoginSession();
      if (!mounted) return;

      if (result['code'] == 0 && result['data']?['qr_id'] != null) {
        setState(() {
          _qrId = result['data']['qr_id'];
          _qrStatus = 'pending';
        });
        _startQRPolling();
      } else {
        setState(() => _qrStatus = 'error');
      }
    } catch (e) {
      logger.debug('❌ [扫码登录] 创建二维码失败: $e');
      if (mounted) {
        setState(() => _qrStatus = 'error');
      }
    }
  }

  void _startQRPolling() {
    _qrPollTimer?.cancel();
    _qrPollTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _pollQRLoginStatus(),
    );
  }

  /// 轮询二维码状态；确认登录后走公共登录流程
  Future<void> _pollQRLoginStatus() async {
    final qrId = _qrId;
    if (qrId == null || _isLoading) return;

    try {
      final result = await ApiService.getQRLoginStatus(qrId);
      // 页面已销毁或二维码已刷新，丢弃本次结果
      if (!mounted || qrId != _qrId) return;
      if (result['code'] != 0) return;

      final data = result['data'];
      final status = data?['status'] as String? ?? '';
      switch (status) {
        case 'scanned':
          if (_qrStatus != 'scanned') {
            setState(() {
              _qrStatus = 'scanned';
              _scannedNickname = data?['user']?['nickname'] ?? '';
            });
          }
          break;
        case 'confirmed':
          _qrPollTimer?.cancel();
          setState(() => _isLoading = true);
          logger.info('✅ [扫码登录] 手机已确认，完成PC端登录');
          await _completeLogin(data['token'], data['user']);
          break;
        case 'cancelled':
          _qrPollTimer?.cancel();
          setState(() => _qrStatus = 'cancelled');
          break;
        case 'expired':
          _qrPollTimer?.cancel();
          setState(() => _qrStatus = 'expired');
          break;
        default:
          break; // pending：继续等待
      }
    } catch (e) {
      logger.debug('⚠️ [扫码登录] 轮询状态失败: $e');
    }
  }

  // 根据平台和用户选择保存登录配置
  Future<void> _saveCredentials(
    int userId,
    String username,
    String password,
  ) async {
    if (_isDesktop) {
      // PC端：根据用户选择保存配置
      logger.debug('💾 PC端保存登录配置: userId=$userId, rememberPassword=$_rememberPassword, autoLogin=$_autoLogin');
      
      // 保存记住密码和自动登录配置
      await Storage.saveRememberPassword(userId, _rememberPassword);
      await Storage.saveAutoLogin(userId, _autoLogin);
      
      // 如果勾选了记住密码，保存账号密码
      if (_rememberPassword) {
        await Storage.saveSavedAccount(userId, username);
        await Storage.saveSavedPassword(userId, password);
        logger.debug('✅ PC端已保存账号密码');
      } else {
        // 如果没有勾选记住密码，清除之前保存的账号密码
        // 注意：这里只清除账号密码，不清除配置选项本身
        await Storage.saveSavedAccount(userId, '');
        await Storage.saveSavedPassword(userId, '');
        logger.debug('🗑️ PC端已清除账号密码');
      }
      
      logger.debug('✅ PC端登录配置已保存');
    } else {
      // 移动端：自动保存账号密码和登录配置（简化逻辑）
      logger.debug('💾 移动端自动保存登录配置: userId=$userId, username=$username');
      
      // 自动启用记住密码和自动登录
      await Storage.saveRememberPassword(userId, true);
      await Storage.saveAutoLogin(userId, true);
      
      // 保存账号密码
      await Storage.saveSavedAccount(userId, username);
      await Storage.saveSavedPassword(userId, password);
      
      logger.debug('✅ 移动端登录配置已自动保存（记住密码: true, 自动登录: true）');
    }
  }

  // 显示错误提示
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 显示成功提示
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  void dispose() {
    _qrPollTimer?.cancel();
    _accountController.removeListener(_checkCanLogin);
    _passwordController.removeListener(_checkCanLogin);
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 切换 亮色 / 暗黑 模式
  void _toggleTheme() {
    final isDark = ThemeService.instance.isDark(context);
    ThemeService.instance.toggle(currentlyDark: isDark);
  }

  /// 右上角 暗黑/浅色 切换按钮（与引导页一致）
  Widget _buildThemeToggleButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
          child: IconButton(
            tooltip: isDark ? '切换到浅色模式' : '切换到暗黑模式',
            onPressed: _toggleTheme,
            icon: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
              color: const Color(0xFF54A9EB),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 移动端：Telegram 风格登录页（用户名/密码）
    if (!_isDesktop) {
      return _buildMobileLayout();
    }
    // 桌面端：保留原白卡片登录布局
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/登录/背景图.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(child: _buildLoginForm()),
          ),
          // 右上角主题切换按钮
          Positioned(
            top: 0,
            right: 0,
            child: _buildThemeToggleButton(),
          ),
        ],
      ),
    );
  }

  // 移动端 Telegram 风格登录布局
  Widget _buildMobileLayout() {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    const primaryBlue = Color(0xFF54A9EB);
    return Scaffold(
      backgroundColor: c.scaffold,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  // 标题
                  Text(
                    l10n.translate('login'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: c.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 副标题
                  Text(
                    l10n.translate('login_subtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: c.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 44),
                  // 用户名输入框
                  TextField(
                    controller: _accountController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.translate('account'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: c.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 密码输入框
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (_canLogin && !_isLoading) _handleAccountLogin();
                    },
                    decoration: InputDecoration(
                      labelText: l10n.translate('password'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: c.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: primaryBlue, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: c.secondaryText,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 悬浮箭头按钮（登录）
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildMobileSubmitButton(primaryBlue),
                  ),
                  const Spacer(),
                  // 忘记密码 & 注册
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            l10n.translate('forgot_password_question'),
                            style: TextStyle(
                              fontSize: 14,
                              color: c.secondaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            l10n.translate('go_to_register'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
          // 右上角主题切换按钮
          Positioned(
            top: 0,
            right: 0,
            child: _buildThemeToggleButton(),
          ),
        ],
      ),
    );
  }

  // 移动端登录圆形提交按钮
  Widget _buildMobileSubmitButton(Color primaryBlue) {
    final bool enabled = _canLogin && !_isLoading;
    return Material(
      color: enabled ? primaryBlue : const Color(0xFFCCCCCC),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? _handleAccountLogin : null,
        child: SizedBox(
          width: 64,
          height: 64,
          child: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 28,
                ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: 400,
      height: 580,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部区域 - logo左对齐，语言设置右对齐
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 30,
                right: 30,
                bottom: 35,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo/app_icon.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Telegram',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2AABEE),
                        ),
                      ),
                    ],
                  ),
                  _buildLanguageDropdown(),
                ],
              ),
            ),
            // 🔴 PC端只允许扫码登录：展示二维码，由手机APP扫一扫确认
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildQRLoginView(),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== PC端扫码登录视图 ====================

  Widget _buildQRLoginView() {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: 6),
        Text(
          '扫码登录',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: c.primaryText,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '请使用手机APP的"扫一扫"扫描二维码',
          style: TextStyle(fontSize: 13, color: c.secondaryText),
        ),
        const SizedBox(height: 28),
        Center(child: _buildQRCodeArea()),
        const SizedBox(height: 24),
        _buildQRStatusHint(),
        const SizedBox(height: 12),
        // 注册入口（注册完成后回到本页用手机APP扫码登录）
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: Text(
            l10n.translate('go_to_register'),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A90E2),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  // 二维码区域：白底二维码 + 状态遮罩（扫描成功/失效刷新/加载中）
  Widget _buildQRCodeArea() {
    const double size = 220;

    Widget content;
    if (_qrId != null) {
      content = Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: QrImageView(
          data: 'youdu://qrlogin/$_qrId',
          version: QrVersions.auto,
          size: size - 20,
          backgroundColor: Colors.white,
        ),
      );
    } else {
      content = Container(color: Colors.white);
    }

    Widget? overlay;
    if (_isLoading) {
      // 手机已确认，正在完成登录
      overlay = _buildQROverlay(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 12),
            Text('登录中...', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
          ],
        ),
      );
    } else {
      switch (_qrStatus) {
        case 'loading':
          overlay = _buildQROverlay(
            child: const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          );
          break;
        case 'scanned':
          overlay = _buildQROverlay(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF07C160), size: 44),
                const SizedBox(height: 12),
                Text(
                  _scannedNickname.isNotEmpty ? '$_scannedNickname 扫描成功' : '扫描成功',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '请在手机上确认登录',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          );
          break;
        case 'cancelled':
        case 'expired':
        case 'error':
          final tip = _qrStatus == 'cancelled'
              ? '已取消登录'
              : (_qrStatus == 'error' ? '二维码生成失败' : '二维码已失效');
          overlay = GestureDetector(
            onTap: _createQRLoginSession,
            child: _buildQROverlay(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh, color: Color(0xFF4A90E2), size: 44),
                  const SizedBox(height: 12),
                  Text(
                    tip,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '点击刷新二维码',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
          break;
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.of(context).divider),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          if (overlay != null) overlay,
        ],
      ),
    );
  }

  // 二维码状态遮罩底板
  Widget _buildQROverlay({required Widget child}) {
    return Container(
      color: Colors.white.withValues(alpha: 0.96),
      child: child,
    );
  }

  // 二维码下方的操作提示
  Widget _buildQRStatusHint() {
    final c = AppColors.of(context);
    return Text(
      '打开手机APP → 首页右上角"+" → 扫一扫',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13, color: c.secondaryText),
    );
  }

  Widget _buildLanguageDropdown() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      tooltip: '',
      color: AppColors.of(context).surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: AppColors.of(context).divider, width: 1),
      ),
      padding: EdgeInsets.zero,
      onSelected: (String value) {
        setState(() {
          _selectedLanguage = value;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '简体中文',
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: const Text('简体中文', style: TextStyle(fontSize: 14)),
        ),
        PopupMenuItem<String>(
          value: 'English',
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: const Text('English', style: TextStyle(fontSize: 14)),
        ),
        PopupMenuItem<String>(
          value: '繁體中文',
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: const Text('繁體中文', style: TextStyle(fontSize: 14)),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/登录/语言设置.svg', width: 20, height: 20),
            const SizedBox(width: 6),
            Text(
              _selectedLanguage,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.of(context).secondaryText,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: AppColors.of(context).secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
