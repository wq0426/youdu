import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/logger.dart';

/// 版本信息持久化服务
/// 将版本信息保存到应用目录外的位置，避免升级时被删除
class VersionPersistenceService {
  static final VersionPersistenceService _instance = VersionPersistenceService._internal();
  factory VersionPersistenceService() => _instance;
  VersionPersistenceService._internal();

  /// 获取版本信息文件路径
  /// PC端：用户文档目录/telegram/version.json
  /// 移动端：应用文档目录/version.json
  Future<String> _getVersionFilePath() async {
    String dirPath;
    
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // PC端：使用用户文档目录，不会被应用升级删除
      if (Platform.isWindows) {
        // Windows: C:\Users\<user>\Documents\telegram\version.json
        final userProfile = Platform.environment['USERPROFILE'] ?? '';
        dirPath = path.join(userProfile, 'Documents', 'telegram');
      } else if (Platform.isMacOS) {
        // macOS: ~/Library/Application Support/telegram/version.json
        final home = Platform.environment['HOME'] ?? '';
        dirPath = path.join(home, 'Library', 'Application Support', 'telegram');
      } else {
        // Linux: ~/.config/telegram/version.json
        final home = Platform.environment['HOME'] ?? '';
        dirPath = path.join(home, '.config', 'telegram');
      }
    } else {
      // 移动端：使用应用文档目录
      final appDocDir = await getApplicationDocumentsDirectory();
      dirPath = appDocDir.path;
    }
    
    // 确保目录存在
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    return path.join(dirPath, 'version.json');
  }

  /// 保存版本信息
  Future<void> saveVersion({
    required String version,
    required String versionCode,
    required String platform,
    int fileSize = 0,
    String? releaseNotes,
    String? releaseDate,
  }) async {
    try {
      final filePath = await _getVersionFilePath();
      final file = File(filePath);
      
      // 读取现有数据
      Map<String, dynamic> allVersions = {};
      if (await file.exists()) {
        try {
          final content = await file.readAsString();
          allVersions = jsonDecode(content) as Map<String, dynamic>;
        } catch (e) {
          logger.warning('⚠️ [版本持久化] 读取现有版本文件失败，将覆盖: $e');
        }
      }
      
      // 更新当前平台的版本信息
      allVersions[platform] = {
        'version': version,
        'version_code': versionCode,
        'file_size': fileSize,
        'release_notes': releaseNotes ?? '',
        'release_date': releaseDate ?? DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // 写入文件
      await file.writeAsString(jsonEncode(allVersions));
      
      logger.info('✅ [版本持久化] 已保存版本信息: $version ($platform)');
      logger.debug('📁 [版本持久化] 文件路径: $filePath');
    } catch (e) {
      logger.error('❌ [版本持久化] 保存版本信息失败: $e');
    }
  }

  /// 获取版本信息
  Future<Map<String, dynamic>?> getVersion(String platform) async {
    try {
      final filePath = await _getVersionFilePath();
      final file = File(filePath);
      
      if (!await file.exists()) {
        logger.debug('📁 [版本持久化] 版本文件不存在: $filePath');
        return null;
      }
      
      final content = await file.readAsString();
      final allVersions = jsonDecode(content) as Map<String, dynamic>;
      
      if (allVersions.containsKey(platform)) {
        final versionInfo = allVersions[platform] as Map<String, dynamic>;
        logger.debug('📦 [版本持久化] 读取版本信息: ${versionInfo['version']} ($platform)');
        return versionInfo;
      }
      
      logger.debug('📁 [版本持久化] 未找到平台 $platform 的版本信息');
      return null;
    } catch (e) {
      logger.error('❌ [版本持久化] 读取版本信息失败: $e');
      return null;
    }
  }

  /// 清除版本信息
  Future<void> clearVersion(String platform) async {
    try {
      final filePath = await _getVersionFilePath();
      final file = File(filePath);
      
      if (!await file.exists()) {
        return;
      }
      
      final content = await file.readAsString();
      final allVersions = jsonDecode(content) as Map<String, dynamic>;
      
      if (allVersions.containsKey(platform)) {
        allVersions.remove(platform);
        await file.writeAsString(jsonEncode(allVersions));
        logger.info('🗑️ [版本持久化] 已清除平台 $platform 的版本信息');
      }
    } catch (e) {
      logger.error('❌ [版本持久化] 清除版本信息失败: $e');
    }
  }
}
