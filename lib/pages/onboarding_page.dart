import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// 引导页（Telegram 风格的 6 屏轮播）
///
/// 登录前展示，底部"Start Messaging"按钮跳转到账号密码登录页。
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

/// 单个引导屏的数据
class _Slide {
  final String image;
  final String title;
  // 副标题由多个片段组成，bold 为 true 的片段加粗
  final List<_SubtitleSpan> subtitle;

  const _Slide({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class _SubtitleSpan {
  final String text;
  final bool bold;
  const _SubtitleSpan(this.text, {this.bold = false});
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const Color _primaryBlue = Color(0xFF54A9EB);

  static const List<_Slide> _slides = [
    _Slide(
      image: 'assets/引导/001.png',
      title: 'Telegram',
      subtitle: [
        _SubtitleSpan("The world's "),
        _SubtitleSpan('fastest', bold: true),
        _SubtitleSpan(' messaging app.\nIt is '),
        _SubtitleSpan('free', bold: true),
        _SubtitleSpan(' and '),
        _SubtitleSpan('secure', bold: true),
        _SubtitleSpan('.'),
      ],
    ),
    _Slide(
      image: 'assets/引导/002.png',
      title: 'Fast',
      subtitle: [
        _SubtitleSpan('Telegram', bold: true),
        _SubtitleSpan(' delivers messages\nfaster than any other application.'),
      ],
    ),
    _Slide(
      image: 'assets/引导/003.png',
      title: 'Free',
      subtitle: [
        _SubtitleSpan('Telegram', bold: true),
        _SubtitleSpan(' provides free unlimited\ncloud storage for chats and media.'),
      ],
    ),
    _Slide(
      image: 'assets/引导/004.png',
      title: 'Powerful',
      subtitle: [
        _SubtitleSpan('Telegram', bold: true),
        _SubtitleSpan(' has no limits on\nthe size of your media and chats.'),
      ],
    ),
    _Slide(
      image: 'assets/引导/005.png',
      title: 'Secure',
      subtitle: [
        _SubtitleSpan('Telegram', bold: true),
        _SubtitleSpan(' keeps your messages safe\nfrom hacker attacks.'),
      ],
    ),
    _Slide(
      image: 'assets/引导/006.png',
      title: 'Cloud-Based',
      subtitle: [
        _SubtitleSpan('Telegram', bold: true),
        _SubtitleSpan(' lets you access your\nmessages from multiple devices.'),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startMessaging() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  /// 切换 亮色 / 暗黑 模式
  void _toggleTheme() {
    final isDark = ThemeService.instance.isDark(context);
    ThemeService.instance.toggle(currentlyDark: isDark);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部：右上角 暗黑/浅色 切换按钮
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                child: IconButton(
                  tooltip: isDark ? '切换到浅色模式' : '切换到暗黑模式',
                  onPressed: _toggleTheme,
                  icon: Icon(
                    isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                    color: _primaryBlue,
                    size: 26,
                  ),
                ),
              ),
            ),
            // 轮播内容
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) => _buildSlide(_slides[index]),
              ),
            ),
            // 底部按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startMessaging,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Start Messaging',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(_Slide slide) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF000000);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 插图
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Image.asset(
            slide.image,
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 40),
        // 标题
        Text(
          slide.title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 16),
        // 副标题（部分加粗）
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text.rich(
            TextSpan(
              children: slide.subtitle
                  .map((s) => TextSpan(
                        text: s.text,
                        style: TextStyle(
                          fontWeight:
                              s.bold ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ))
                  .toList(),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.4,
              color: Color(0xFF808080),
            ),
          ),
        ),
        const SizedBox(height: 28),
        // 页面指示点
        _buildDots(),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final bool active = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 9 : 7,
          height: active ? 9 : 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? _primaryBlue : const Color(0xFFD9D9D9),
          ),
        );
      }),
    );
  }
}
