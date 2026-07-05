import 'package:flutter/material.dart';

/// 🔴 Telegram 风格气泡小尾巴：贴在气泡底部内侧角外，尖端指向外下方
/// 上缘用凹曲线扫出去，形成 Telegram 那种尖尖的效果。
/// 移动端(mobile_chat_page)与 PC 端(home_page)共用。
class BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isMe;

  const BubbleTailPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    final path = Path();
    if (isMe) {
      // 尾巴在右侧，尖端在右下角
      path.moveTo(0, 0);
      path.quadraticBezierTo(w * 0.28, h * 0.78, w, h);
      path.quadraticBezierTo(w * 0.45, h, 0, h);
      path.close();
    } else {
      // 尾巴在左侧，尖端在左下角
      path.moveTo(w, 0);
      path.quadraticBezierTo(w * 0.72, h * 0.78, 0, h);
      path.quadraticBezierTo(w * 0.55, h, w, h);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BubbleTailPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isMe != isMe;
}
