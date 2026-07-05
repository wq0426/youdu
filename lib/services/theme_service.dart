import 'package:flutter/material.dart';
import '../utils/storage.dart';
import '../utils/logger.dart';

/// 全局主题模式管理（亮色 / 暗黑 / 跟随系统）
///
/// 通过单例 [ThemeService.instance] 访问，[mode] 是一个 [ValueListenable]，
/// 在 `MaterialApp` 外层用 `ValueListenableBuilder` 监听即可实现全局切换。
/// 选择会持久化到 [Storage]，下次启动自动恢复。
class ThemeService {
  ThemeService._();
  static final ThemeService instance = ThemeService._();

  /// 当前主题模式，默认跟随系统
  final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(ThemeMode.system);

  bool _initialized = false;

  /// 从持久化存储加载主题模式（在 runApp 之前调用）
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      final saved = await Storage.getThemeMode();
      mode.value = _parse(saved);
      logger.info('🎨 [主题] 已加载主题模式: $saved');
    } catch (e) {
      logger.error('❌ [主题] 加载主题模式失败: $e');
    }
  }

  /// 是否处于暗黑模式（system 时根据平台亮度判断）
  bool isDark(BuildContext context) {
    switch (mode.value) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  /// 设置并持久化主题模式
  Future<void> setMode(ThemeMode newMode) async {
    if (mode.value == newMode) return;
    mode.value = newMode;
    await Storage.saveThemeMode(_toCode(newMode));
    logger.info('🎨 [主题] 切换主题模式: ${_toCode(newMode)}');
  }

  /// 在 亮色 / 暗黑 之间切换（用于引导页的切换按钮）。
  /// 当前为 system 时，按传入的 [currentlyDark] 决定切到相反模式。
  Future<void> toggle({required bool currentlyDark}) async {
    await setMode(currentlyDark ? ThemeMode.light : ThemeMode.dark);
  }

  ThemeMode _parse(String code) {
    switch (code) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  String _toCode(ThemeMode m) {
    switch (m) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}
