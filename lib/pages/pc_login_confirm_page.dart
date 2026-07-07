import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/storage.dart';
import '../utils/logger.dart';
import '../theme/app_theme.dart';

/// PC端登录确认页
/// 手机扫一扫识别到 youdu://qrlogin/{qrId} 后进入本页：
/// 进入即调用 scan 接口（PC端显示"已扫描"），用户点"登录"调用 confirm 完成PC登录，
/// 点"取消登录"或返回则调用 cancel。
class PCLoginConfirmPage extends StatefulWidget {
  final String qrId;

  const PCLoginConfirmPage({super.key, required this.qrId});

  @override
  State<PCLoginConfirmPage> createState() => _PCLoginConfirmPageState();
}

class _PCLoginConfirmPageState extends State<PCLoginConfirmPage> {
  static const _primaryBlue = Color(0xFF54A9EB);

  String? _token;
  bool _scanning = true; // 正在上报扫描
  bool _confirming = false; // 正在确认登录
  bool _finished = false; // 已确认/取消，返回时不再重复调 cancel
  String? _error; // 二维码失效等错误提示

  @override
  void initState() {
    super.initState();
    _reportScan();
  }

  /// 上报扫描，PC端二维码变为"已扫描，请在手机上确认"
  Future<void> _reportScan() async {
    try {
      final token = await Storage.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _scanning = false;
          _error = '登录状态失效，请重新登录后再试';
        });
        return;
      }
      _token = token;

      final result =
          await ApiService.scanQRLogin(qrId: widget.qrId, token: token);
      if (!mounted) return;

      if (result['code'] == 0) {
        setState(() => _scanning = false);
      } else {
        setState(() {
          _scanning = false;
          _error = result['message'] ?? '二维码已失效，请刷新后重新扫描';
        });
      }
    } catch (e) {
      logger.debug('❌ [扫码登录] 上报扫描失败: $e');
      if (!mounted) return;
      setState(() {
        _scanning = false;
        _error = '网络异常，请稍后重试';
      });
    }
  }

  /// 确认PC端登录
  Future<void> _confirmLogin() async {
    final token = _token;
    if (token == null || _confirming) return;

    setState(() => _confirming = true);
    try {
      final result =
          await ApiService.confirmQRLogin(qrId: widget.qrId, token: token);
      if (!mounted) return;

      if (result['code'] == 0) {
        _finished = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已在PC端登录')),
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          _confirming = false;
          _error = result['message'] ?? '确认登录失败，请重新扫描';
        });
      }
    } catch (e) {
      logger.debug('❌ [扫码登录] 确认登录失败: $e');
      if (!mounted) return;
      setState(() {
        _confirming = false;
        _error = '网络异常，请稍后重试';
      });
    }
  }

  /// 取消PC端登录（点取消按钮或返回时调用）
  Future<void> _cancelLogin() async {
    if (_finished) return;
    _finished = true;

    final token = _token;
    if (token != null) {
      try {
        await ApiService.cancelQRLogin(qrId: widget.qrId, token: token);
      } catch (e) {
        logger.debug('⚠️ [扫码登录] 取消登录失败: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return PopScope(
      // 返回时通知服务端取消，PC端二维码显示"已取消"
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _cancelLogin();
      },
      child: Scaffold(
        backgroundColor: c.scaffold,
        appBar: AppBar(
          backgroundColor: c.scaffold,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: c.primaryText),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: _error != null ? _buildErrorView(c) : _buildConfirmView(c),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmView(AppColors c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        Icon(Icons.computer, size: 88, color: c.secondaryText),
        const SizedBox(height: 32),
        Text(
          'PC端登录确认',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: c.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '即将在电脑上登录你的账号\n请确认是本人操作',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, height: 1.5, color: c.secondaryText),
        ),
        const Spacer(),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: (_scanning || _confirming) ? null : _confirmLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _primaryBlue.withValues(alpha: 0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _confirming
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('登录', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: _confirming
                ? null
                : () async {
                    await _cancelLogin();
                    if (mounted) Navigator.of(context).pop();
                  },
            child: Text(
              '取消登录',
              style: TextStyle(fontSize: 15, color: c.secondaryText),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildErrorView(AppColors c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        Icon(Icons.error_outline, size: 88, color: c.secondaryText),
        const SizedBox(height: 32),
        Text(
          _error ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, height: 1.5, color: c.primaryText),
        ),
        const Spacer(),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              _finished = true; // 二维码已失效，返回时无需再调 cancel
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('返回', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
