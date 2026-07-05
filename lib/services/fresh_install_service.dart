import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/logger.dart';

/// 全新安装检测服务
/// 用于检测应用是否是全新安装（卸载后重装），如果是则清理残留的 Keychain 数据
class FreshInstallService {
  static const String _installMarkerKey = 'app_install_marker';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    // macOS 无开发者证书(ad-hoc 签名)时数据保护钥匙串会报 -34018，改用传统登录钥匙串
    mOptions: MacOsOptions(useDataProtectionKeyChain: false),
  );
  
  /// 检测并处理全新安装
  /// 返回 true 表示是全新安装并已清理数据
  static Future<bool> checkAndHandleFreshInstall() async {
    // 仅在 iOS 上执行此检查（Android 卸载时会清理所有数据）
    if (!Platform.isIOS) {
      return false;
    }
    
    try {
      logger.debug('🔍 [全新安装检测] 开始检测...');
      
      // 1. 检查数据库文件是否存在（新旧文件名都检查）
      final dbPath = await getDatabasesPath();
      final newDbFilePath = '$dbPath/telegram_local_storage.db';
      final oldDbFilePath1 = '$dbPath/youdu_storage.db';
      final oldDbFilePath2 = '$dbPath/youdu_messages.db';
      final newDbFile = File(newDbFilePath);
      final oldDbFile1 = File(oldDbFilePath1);
      final oldDbFile2 = File(oldDbFilePath2);
      final newDbExists = newDbFile.existsSync();
      final oldDbExists = oldDbFile1.existsSync() || oldDbFile2.existsSync();
      
      logger.debug('🔍 [全新安装检测] 新数据库文件(telegram_local_storage.db)存在: $newDbExists');
      logger.debug('🔍 [全新安装检测] 旧数据库文件存在: $oldDbExists');
      
      // 2. 检查 Keychain 中是否有数据
      final hasKeychainData = await _hasKeychainData();
      logger.debug('🔍 [全新安装检测] Keychain 有数据: $hasKeychainData');
      
      // 3. 检查 SharedPreferences 中的安装标记
      final prefs = await SharedPreferences.getInstance();
      final hasInstallMarker = prefs.containsKey(_installMarkerKey);
      logger.debug('🔍 [全新安装检测] 安装标记存在: $hasInstallMarker');
      
      // 判断是否是全新安装：
      // - 新数据库文件不存在
      // - 但 Keychain 中有数据（说明之前安装过）
      // - 或者安装标记不存在（SharedPreferences 被清空了）
      final isFreshInstall = !newDbExists && (hasKeychainData || !hasInstallMarker);
      
      // 判断是否需要清理（全新安装或有旧数据库文件）
      final needsCleanup = isFreshInstall || oldDbExists;
      
      if (needsCleanup) {
        logger.debug('🧹 [全新安装检测] 检测到需要清理数据...');
        
        // 清理数据库目录下所有可能的残留文件（包括旧数据库）
        await _cleanupDatabaseDirectory(dbPath);
        
        // 清理 Keychain 数据
        if (hasKeychainData) {
          logger.debug('🧹 [全新安装检测] 清理残留的应用相关 Keychain 数据...');
          await _clearAppSecureStorage();
          logger.debug('✅ [全新安装检测] 应用相关 Keychain 数据已清理');
        }
      }
      
      // 4. 设置安装标记（如果不存在）
      if (!hasInstallMarker) {
        await prefs.setBool(_installMarkerKey, true);
        logger.debug('✅ [全新安装检测] 已设置安装标记');
      }
      
      return isFreshInstall && hasKeychainData;
    } catch (e) {
      logger.error('❌ [全新安装检测] 检测失败: $e');
      return false;
    }
  }
  
  /// 检查 Keychain 中是否有应用相关的数据
  static Future<bool> _hasKeychainData() async {
    try {
      // 检查数据库加密密钥 UUID 是否存在（这是最关键的标识）
      final uuid = await _secureStorage.read(key: 'ydkey_uuid');
      if (uuid != null && uuid.isNotEmpty) {
        logger.debug('🔍 [Keychain检查] 发现数据库密钥 UUID');
        return true;
      }
      
      // 尝试读取所有数据来检查是否有任何残留
      try {
        final allData = await _secureStorage.readAll();
        if (allData.isNotEmpty) {
          logger.debug('🔍 [Keychain检查] 发现 ${allData.length} 个残留数据项');
          for (final key in allData.keys) {
            logger.debug('🔍 [Keychain检查] 残留 key: $key');
          }
          return true;
        }
      } catch (e) {
        logger.debug('⚠️ [Keychain检查] readAll 失败: $e');
      }
      
      return false;
    } catch (e) {
      logger.debug('⚠️ [Keychain检查] 检查失败: $e');
      return false;
    }
  }
  
  /// 清理应用相关的 FlutterSecureStorage 数据（不清理其他应用的数据）
  static Future<void> _clearAppSecureStorage() async {
    // 应用相关的固定 key
    final fixedKeysToDelete = [
      'ydkey_uuid',      // 数据库加密密钥 UUID
      'ydkey',           // 数据库加密密钥
    ];
    
    // 删除固定 key
    for (final key in fixedKeysToDelete) {
      try {
        await _secureStorage.delete(key: key);
        logger.debug('✅ [Keychain清理] 已删除: $key');
      } catch (e) {
        logger.debug('⚠️ [Keychain清理] 删除 $key 失败: $e');
      }
    }
    
    // 读取所有数据，删除应用相关的 key（带特定前缀的）
    try {
      final allData = await _secureStorage.readAll();
      for (final key in allData.keys) {
        // 删除带有应用特定前缀的 key
        if (_isAppRelatedKey(key)) {
          try {
            await _secureStorage.delete(key: key);
            logger.debug('✅ [Keychain清理] 已删除应用相关 key: $key');
          } catch (e) {
            logger.debug('⚠️ [Keychain清理] 删除 $key 失败: $e');
          }
        }
      }
    } catch (e) {
      logger.debug('⚠️ [Keychain清理] 读取所有数据失败: $e');
    }
  }
  
  /// 判断 key 是否是应用相关的
  static bool _isAppRelatedKey(String key) {
    // 应用相关的 key 前缀和模式
    final appPrefixes = [
      'ydkey',           // 数据库密钥相关
      'user_',           // 用户相关数据
      'auth_',           // 认证相关
      '_auth_token',     // Token（带进程ID前缀）
      '_user_id',        // 用户ID（带进程ID前缀）
      '_username',       // 用户名（带进程ID前缀）
      '_full_name',      // 全名（带进程ID前缀）
      'saved_account',   // 保存的账号
      'saved_password',  // 保存的密码
    ];
    
    for (final prefix in appPrefixes) {
      if (key.contains(prefix)) {
        return true;
      }
    }
    
    return false;
  }
  
  /// 手动清理应用相关的安全存储数据（用于调试或用户主动清理）
  static Future<void> clearAllData() async {
    try {
      logger.debug('🧹 [手动清理] 开始清理应用相关的安全存储数据...');
      
      // 清理应用相关的 FlutterSecureStorage 数据
      await _clearAppSecureStorage();
      
      // 清理安装标记
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_installMarkerKey);
      
      logger.debug('✅ [手动清理] 应用相关的安全存储数据已清理');
    } catch (e) {
      logger.error('❌ [手动清理] 清理失败: $e');
    }
  }
  
  /// 清理数据库目录下所有可能的残留文件（iCloud 可能恢复的）
  static Future<void> _cleanupDatabaseDirectory(String dbPath) async {
    try {
      final dbDir = Directory(dbPath);
      if (!dbDir.existsSync()) {
        logger.debug('🔍 [数据库清理] 数据库目录不存在，跳过清理');
        return;
      }
      
      logger.debug('🔍 [数据库清理] 扫描数据库目录: $dbPath');
      
      // 列出目录下所有文件
      final files = dbDir.listSync();
      for (final file in files) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          logger.debug('🔍 [数据库清理] 发现文件: $fileName');
          
          // 删除所有 telegram/youdu(旧名) 相关的数据库文件
          if ((fileName.startsWith('telegram') || fileName.startsWith('youdu')) && fileName.endsWith('.db')) {
            logger.debug('🧹 [数据库清理] 删除残留数据库文件: $fileName');
            try {
              await file.delete();
              logger.debug('✅ [数据库清理] 已删除: $fileName');
            } catch (e) {
              logger.debug('⚠️ [数据库清理] 删除失败: $e');
            }
          }
          
          // 同时删除 SQLite 的 journal 和 wal 文件
          if ((fileName.contains('telegram') || fileName.contains('youdu')) &&
              (fileName.endsWith('-journal') || fileName.endsWith('-wal') || fileName.endsWith('-shm'))) {
            logger.debug('🧹 [数据库清理] 删除残留临时文件: $fileName');
            try {
              await file.delete();
              logger.debug('✅ [数据库清理] 已删除: $fileName');
            } catch (e) {
              logger.debug('⚠️ [数据库清理] 删除失败: $e');
            }
          }
        }
      }
      
      logger.debug('✅ [数据库清理] 数据库目录清理完成');
    } catch (e) {
      logger.debug('⚠️ [数据库清理] 清理数据库目录失败: $e');
    }
  }
}
