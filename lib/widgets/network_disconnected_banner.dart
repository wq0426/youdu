import 'package:flutter/material.dart';
import '../services/auth_state_service.dart';

/// 网络断开提示横幅（页面顶部、红色背景）
///
/// 由 WebSocketService 在连续多次重连失败后调用 show()，
/// 重连成功后调用 hide()。通过全局 navigatorKey 的 Overlay 插入，
/// 因此在任意页面顶部都能显示。
class NetworkDisconnectedBanner {
  NetworkDisconnectedBanner._();

  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  /// 显示横幅。[onRetry] 为"重试"按钮的回调（点击后横幅先隐藏再执行回调）
  static void show({
    String message = '网络已断开，请检查网络',
    VoidCallback? onRetry,
  }) {
    if (_entry != null) return; // 已在显示，避免重复插入

    final overlay = AuthStateService.navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.red,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (onRetry != null)
                      GestureDetector(
                        onTap: () {
                          hide();
                          onRetry();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '重试',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: hide,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child:
                            Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
