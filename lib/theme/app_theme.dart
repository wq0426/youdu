import 'package:flutter/material.dart';

/// 应用主题（亮色 / Telegram 风格暗黑）
///
/// - [lightTheme] 保持应用原有的浅色外观（白底蓝色调）。
/// - [darkTheme] 采用 Telegram 风格的纯黑暗黑主题。
///
/// 页面应尽量通过 `Theme.of(context)` 读取颜色，而不是硬编码：
///   - 背景：`Theme.of(context).scaffoldBackgroundColor`
///   - 卡片/弹层：`Theme.of(context).cardColor`
///   - 主文字：`Theme.of(context).colorScheme.onSurface`
///   - 次要文字：`Theme.of(context).colorScheme.onSurfaceVariant`
///   - 分隔线：`Theme.of(context).dividerColor`
/// 聊天相关的语义色（气泡、输入栏等）通过 [AppColors] 扩展读取：
///   `Theme.of(context).extension<AppColors>()!`
class AppTheme {
  AppTheme._();

  /// 应用主色（保持原有蓝色）
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color accentBlue = Color(0xFF54A9EB);

  // ===================== 浅色主题 =====================
  static final ThemeData lightTheme = _buildLight();

  static ThemeData _buildLight() {
    const scaffold = Color(0xFFF7F7F7);
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      dividerColor: const Color(0xFFE5E5E5),
      cardColor: Colors.white,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Color(0xFF8E8E93),
        type: BottomNavigationBarType.fixed,
      ),
      extensions: const [
        AppColors(
          scaffold: Colors.white,
          appBar: Colors.white,
          surface: Colors.white,
          surfaceVariant: scaffold,
          primaryText: Color(0xFF1A1A1A),
          secondaryText: Color(0xFF8E8E93),
          divider: Color(0xFFE5E5E5),
          chatBackground: Color(0xFFEDEDED),
          sentBubble: Color(0xFFE5F8C9),
          receivedBubble: Colors.white,
          sentBubbleText: Color(0xFF000000),
          receivedBubbleText: Color(0xFF000000),
          inputBar: Colors.white,
          inputField: Color(0xFFF2F2F2),
          accent: primaryBlue,
          icon: Color(0xFF1A1A1A),
        ),
      ],
    );
  }

  // ===================== 暗黑主题（Telegram 风格） =====================
  static final ThemeData darkTheme = _buildDark();

  static ThemeData _buildDark() {
    const black = Color(0xFF000000); // 纯黑背景
    const surface = Color(0xFF1C1C1E); // 顶栏/卡片/弹层
    const surfaceVariant = Color(0xFF2C2C2E); // 次级表面/分隔
    const primaryText = Color(0xFFFFFFFF);
    const secondaryText = Color(0xFF8E8E93);

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
      ).copyWith(
        surface: black,
        onSurface: primaryText,
        onSurfaceVariant: secondaryText,
        primary: accentBlue,
      ),
      scaffoldBackgroundColor: black,
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: primaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryText),
      ),
      dividerColor: surfaceVariant,
      cardColor: surface,
      dialogTheme: const DialogThemeData(backgroundColor: surface),
      canvasColor: surface,
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: surface),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accentBlue,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: primaryText,
        iconColor: primaryText,
      ),
      iconTheme: const IconThemeData(color: primaryText),
      extensions: const [
        AppColors(
          scaffold: black,
          appBar: surface,
          surface: surface,
          surfaceVariant: surfaceVariant,
          primaryText: primaryText,
          secondaryText: secondaryText,
          divider: surfaceVariant,
          chatBackground: black,
          sentBubble: Color(0xFF3390EC), // Telegram 蓝
          receivedBubble: Color(0xFF1F1F22),
          sentBubbleText: Color(0xFFFFFFFF),
          receivedBubbleText: Color(0xFFFFFFFF),
          inputBar: surface,
          inputField: Color(0xFF2C2C2E),
          accent: accentBlue,
          icon: primaryText,
        ),
      ],
    );
  }
}

/// 语义化颜色扩展，供页面（尤其是聊天页）读取主题相关颜色。
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color scaffold;
  final Color appBar;
  final Color surface;
  final Color surfaceVariant;
  final Color primaryText;
  final Color secondaryText;
  final Color divider;
  final Color chatBackground;
  final Color sentBubble;
  final Color receivedBubble;
  final Color sentBubbleText;
  final Color receivedBubbleText;
  final Color inputBar;
  final Color inputField;
  final Color accent;
  final Color icon;

  const AppColors({
    required this.scaffold,
    required this.appBar,
    required this.surface,
    required this.surfaceVariant,
    required this.primaryText,
    required this.secondaryText,
    required this.divider,
    required this.chatBackground,
    required this.sentBubble,
    required this.receivedBubble,
    required this.sentBubbleText,
    required this.receivedBubbleText,
    required this.inputBar,
    required this.inputField,
    required this.accent,
    required this.icon,
  });

  /// 便捷读取：`AppColors.of(context)`
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? AppTheme.lightTheme.extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? scaffold,
    Color? appBar,
    Color? surface,
    Color? surfaceVariant,
    Color? primaryText,
    Color? secondaryText,
    Color? divider,
    Color? chatBackground,
    Color? sentBubble,
    Color? receivedBubble,
    Color? sentBubbleText,
    Color? receivedBubbleText,
    Color? inputBar,
    Color? inputField,
    Color? accent,
    Color? icon,
  }) {
    return AppColors(
      scaffold: scaffold ?? this.scaffold,
      appBar: appBar ?? this.appBar,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      divider: divider ?? this.divider,
      chatBackground: chatBackground ?? this.chatBackground,
      sentBubble: sentBubble ?? this.sentBubble,
      receivedBubble: receivedBubble ?? this.receivedBubble,
      sentBubbleText: sentBubbleText ?? this.sentBubbleText,
      receivedBubbleText: receivedBubbleText ?? this.receivedBubbleText,
      inputBar: inputBar ?? this.inputBar,
      inputField: inputField ?? this.inputField,
      accent: accent ?? this.accent,
      icon: icon ?? this.icon,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      appBar: Color.lerp(appBar, other.appBar, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t)!,
      sentBubble: Color.lerp(sentBubble, other.sentBubble, t)!,
      receivedBubble: Color.lerp(receivedBubble, other.receivedBubble, t)!,
      sentBubbleText: Color.lerp(sentBubbleText, other.sentBubbleText, t)!,
      receivedBubbleText:
          Color.lerp(receivedBubbleText, other.receivedBubbleText, t)!,
      inputBar: Color.lerp(inputBar, other.inputBar, t)!,
      inputField: Color.lerp(inputField, other.inputField, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
    );
  }
}
