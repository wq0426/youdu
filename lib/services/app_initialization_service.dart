import 'dart:async';

import '../utils/logger.dart';
import '../utils/storage.dart';
import '../pages/mobile_chat_page.dart';
import '../pages/mobile_home_page.dart';
import 'database_repair_service.dart';
import 'favorite_service.dart';
import 'agora_chat_service.dart';
import 'local_database_service.dart';

/// 同步状态回调类型
typedef SyncStatusCallback = void Function(bool isSyncing, String? message);

/// 应用初始化服务
/// 负责应用启动时的各种初始化和修复工作
class AppInitializationService {
  static final AppInitializationService _instance = AppInitializationService._internal();
  factory AppInitializationService() => _instance;
  AppInitializationService._internal();

  final _repairService = DatabaseRepairService();
  final _favoriteService = FavoriteService();
  final _localDb = LocalDatabaseService();

  /// 执行应用初始化
  /// [onSyncStatusChanged] 同步状态变化回调，用于UI显示加载状态
  Future<void> initialize({SyncStatusCallback? onSyncStatusChanged}) async {
    try {
      logger.debug('═══════════════════════════════════════════════════════════');
      logger.debug('🚀 [应用初始化] 开始应用初始化...');
      logger.debug('═══════════════════════════════════════════════════════════');
      
      // 检查用户是否已登录
      final isLoggedIn = await Storage.isLoggedIn();
      logger.debug('🔍 [应用初始化] 用户登录状态: ${isLoggedIn ? "已登录" : "未登录"}');
      if (!isLoggedIn) {
        logger.debug('⚠️ [应用初始化] 用户未登录，跳过数据库修复和同步');
        return;
      }

      // 登录 Agora Chat（即时通讯），用于消息收发。失败不阻塞其余初始化。
      await _loginAgoraChat();

      // 检查是否需要进行数据库修复
      logger.debug('🔧 [应用初始化] 检查数据库修复需求...');
      await _checkAndRepairDatabase();
      
      // 检查是否是首次安装（本地数据库为空）
      logger.debug('🔍 [应用初始化] 检查是否首次安装...');
      final isFirstInstall = await _checkIsFirstInstall();
      logger.debug('🔍 [应用初始化] 首次安装检查结果: ${isFirstInstall ? "是" : "否"}');
      
      if (isFirstInstall) {
        logger.debug('═══════════════════════════════════════════════════════════');
        logger.debug('📱 [应用初始化] 首次安装/数据库迁移 —— 历史消息改由 Agora Chat 提供，跳过旧后端历史回填');
        logger.debug('═══════════════════════════════════════════════════════════');

        // 🔵 阶段6：旧的“从后端 messages/group_messages 表回填本地 SQLite”链路已移除。
        // 历史消息由 Agora Chat 承载（_loginAgoraChat 已预热会话/群缓存，进会话时按需拉取）。
        onSyncStatusChanged?.call(true, '初始化中...');

        // 仅同步收藏数据
        await _syncFavorites();

        onSyncStatusChanged?.call(false, null);

        // 直接标记首次同步完成，避免每次启动重复进入该分支
        await Storage.saveFirstSyncCompleted(true);
      } else {
        // 非首次安装，只同步收藏数据（增量同步）
        await _syncFavorites();
      }
    } catch (e) {
      // 发生错误时也要通知UI停止显示加载状态
      onSyncStatusChanged?.call(false, null);
      logger.debug('❌ [应用初始化] 应用初始化失败: $e');
    }
  }
  
  /// 登录 Agora Chat（即时通讯）
  Future<void> _loginAgoraChat() async {
    try {
      final token = await Storage.getToken();
      final userId = await Storage.getUserId();
      if (token == null || token.isEmpty || userId == null) {
        logger.debug('💬 [应用初始化] 缺少 token/userId，跳过 Agora Chat 登录');
        return;
      }
      logger.debug('💬 [应用初始化] 开始登录 Agora Chat... userId=$userId');
      final ok = await AgoraChatService().loginFromBackend(
        userId: userId,
        authToken: token,
      );
      logger.debug('💬 [应用初始化] Agora Chat 登录${ok ? "成功" : "失败"}');

      if (ok) {
        // 阶段4：发布在线状态（Presence）
        unawaited(AgoraChatService().publishPresence('online'));
        // 启动全局消息→内存缓存同步（任何会话有新消息都同步进缓存，SDK 自动落本地库）
        MobileChatPage.startGlobalCacheSync(currentUserId: userId);
        // 🔵 登录成功后立即刷新一次会话列表（此时 Agora 已登录，1:1 会话可拉到）。
        MobileChatListPage.needRefresh();
        // 🚀 优化：先只做轻量的群ID映射登记（会话列表显示群会话所必需），
        // 逐会话/逐群拉历史的重预热延后 5 秒执行，不与首屏加载争抢网络/DB。
        unawaited(
          MobileChatPage.preloadGroupsCache(
            currentUserId: userId,
            token: token,
            preloadMessages: false, // 仅登记映射
          )
              // 🔵 群映射登记后刷新会话列表，确保群会话(依赖本地群ID映射)能正确显示。
              .then((_) => MobileChatListPage.needRefresh()),
        );
        // 🚀 重预热延迟启动：预加载所有会话/群组最新 30 条到内存（进会话即从内存读）
        unawaited(Future.delayed(const Duration(seconds: 5), () async {
          await MobileChatPage.preloadAgoraConversationsCache(
              currentUserId: userId);
          await MobileChatPage.preloadGroupsCache(
            currentUserId: userId,
            token: token,
          );
          // 预热完成后再刷新一次，补全最后一条消息预览。
          MobileChatListPage.needRefresh();
        }));
      }
    } catch (e) {
      logger.debug('💬 [应用初始化] Agora Chat 登录异常: $e');
    }
  }

  /// 检查是否是首次安装（本地数据库为空）
  Future<bool> _checkIsFirstInstall() async {
    try {
      logger.debug('───────────────────────────────────────────────────────────');
      logger.debug('📱 [首次安装检查] 开始检查...');
      
      // 检查本地消息表是否为空
      final userId = await Storage.getUserId();
      logger.debug('📱 [首次安装检查] 当前用户ID: $userId');
      if (userId == null) {
        logger.debug('📱 [首次安装检查] 用户ID为空，返回false');
        return false;
      }
      
      logger.debug('📱 [首次安装检查] 查询本地数据库是否有消息...');
      final hasMessages = await _localDb.hasAnyMessages(userId);
      logger.debug('📱 [首次安装检查] 本地消息数据: ${hasMessages ? "✅ 有数据" : "❌ 为空"}');
      
      // 检查是否已完成首次同步
      final firstSyncCompleted = await Storage.getFirstSyncCompleted();
      logger.debug('📱 [首次安装检查] 首次同步标记(first_sync_completed): ${firstSyncCompleted ? "✅ 已完成" : "❌ 未完成"}');
      
      // 如果标记为已完成但本地数据库为空，说明之前同步失败了，需要重新同步
      if (firstSyncCompleted && !hasMessages) {
        logger.debug('⚠️ [首次安装检查] 异常状态：同步标记为完成但本地数据库为空');
        logger.debug('⚠️ [首次安装检查] 清除标记并重新同步...');
        await Storage.clearFirstSyncCompleted();
        logger.debug('📱 [首次安装检查] 结果: 需要重新同步');
        logger.debug('───────────────────────────────────────────────────────────');
        return true;
      }
      
      if (firstSyncCompleted) {
        logger.debug('📱 [首次安装检查] 已完成首次同步，跳过历史数据同步');
        logger.debug('───────────────────────────────────────────────────────────');
        return false;
      }
      
      final isFirstInstall = !hasMessages;
      logger.debug('📱 [首次安装检查] 最终结果: ${isFirstInstall ? "✅ 是首次安装/需要同步" : "❌ 不是首次安装"}');
      logger.debug('───────────────────────────────────────────────────────────');
      return isFirstInstall;
    } catch (e) {
      logger.debug('❌ [首次安装检查] 检查失败: $e');
      logger.debug('───────────────────────────────────────────────────────────');
      return false;
    }
  }
  
  // 🔵 阶段6：旧的“从后端 messages/group_messages 历史回填本地 SQLite”方法
  // (_syncHistoryMessages/_syncPrivateMessages/_syncGroupMessages/_convertServerMessageToLocal)
  // 已删除——历史消息改由 Agora Chat 承载，不再读取已下线的消息表。

  /// 同步收藏数据
  Future<void> _syncFavorites() async {
    try {
      await _favoriteService.syncFromServer();
    } catch (e) {
      logger.debug('❌ 收藏数据同步失败: $e');
      // 同步失败不影响应用启动
    }
  }

  /// 检查并修复数据库
  Future<void> _checkAndRepairDatabase() async {
    try {
      // 检查是否已经执行过修复
      final lastRepairTime = await Storage.getLastDatabaseRepairTime();
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      
      // 如果距离上次修复超过7天，或者从未修复过，则执行修复
      if (lastRepairTime == null || (currentTime - lastRepairTime) > 7 * 24 * 60 * 60 * 1000) {
        logger.debug('🔧 检查数据库修复需求...');
        
        final needRepairCount = await _repairService.checkRepairNeeded();
        if (needRepairCount > 0) {
          logger.debug('🔧 发现 $needRepairCount 条记录需要修复用户昵称，开始修复...');
          await _repairService.repairMissingUserNames();
          
          // 记录修复时间
          await Storage.saveLastDatabaseRepairTime(currentTime);
          logger.debug('✅ 数据库修复完成，已记录修复时间');
        } else {
          logger.debug('✅ 数据库无需修复');
          // 即使无需修复，也更新修复时间，避免频繁检查
          await Storage.saveLastDatabaseRepairTime(currentTime);
        }
      } else {
        logger.debug('⏭️ 距离上次数据库修复时间较短，跳过检查');
      }
    } catch (e) {
      logger.debug('❌ 数据库修复检查失败: $e');
    }
  }

  /// 手动触发数据库修复（用于调试或用户手动触发）
  Future<bool> manualRepairDatabase() async {
    try {
      logger.debug('🔧 手动触发数据库修复...');
      
      final needRepairCount = await _repairService.checkRepairNeeded();
      if (needRepairCount > 0) {
        logger.debug('🔧 发现 $needRepairCount 条记录需要修复，开始修复...');
        await _repairService.repairMissingUserNames();
        
        // 记录修复时间
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        await Storage.saveLastDatabaseRepairTime(currentTime);
        
        logger.debug('✅ 手动数据库修复完成');
        return true;
      } else {
        logger.debug('✅ 数据库无需修复');
        return false;
      }
    } catch (e) {
      logger.debug('❌ 手动数据库修复失败: $e');
      return false;
    }
  }
}
