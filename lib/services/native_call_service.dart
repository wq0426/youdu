import 'dart:io';
import 'package:flutter/services.dart';
import '../utils/logger.dart';

/// 原生来电服务
/// 用于在 Android 端显示系统级来电弹窗
class NativeCallService {
  static final NativeCallService _instance = NativeCallService._internal();
  factory NativeCallService() => _instance;
  NativeCallService._internal();

  static const MethodChannel _channel = MethodChannel('com.example.telegram/call');

  /// 初始化来电服务
  /// 设置来电回调监听器
  void initialize({
    required Function(Map<String, dynamic> callData) onIncomingCall,
    Function(int callerId, String callType)? onCallRejected,
    Function()? onStopAudio,
  }) {
    if (!Platform.isAndroid) {
      logger.debug('⚠️ 原生来电服务仅支持 Android 平台');
      return;
    }

    // 设置来电回调
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onIncomingCall') {
        final callData = Map<String, dynamic>.from(call.arguments as Map);
        logger.debug('📱 收到来电回调: $callData');
        onIncomingCall(callData);
      } else if (call.method == 'onCallRejected') {
        final callerId = call.arguments['callerId'] as int?;
        final callType = call.arguments['callType'] as String?;
        
        logger.debug('❌ 收到拒绝通话回调: callerId=$callerId, callType=$callType');
        
        if (callerId != null && callType != null && onCallRejected != null) {
          onCallRejected(callerId, callType);
        }
      } else if (call.method == 'stopCallAudio') {
        // 🔴 新增：接收停止音频的广播
        logger.debug('🔇 收到停止音频回调（锁屏拒绝/接听）');
        if (onStopAudio != null) {
          onStopAudio();
        }
      }
    });

    logger.debug('✅ 原生来电服务已初始化');
  }

  /// 启动来电前台服务
  Future<bool> startCallService() async {
    if (!Platform.isAndroid) {
      logger.debug('⚠️ 原生来电服务仅支持 Android 平台');
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('startCallService');
      logger.debug('🚀 来电前台服务已启动: $result');
      return result ?? false;
    } catch (e) {
      logger.debug('❌ 启动来电前台服务失败: $e');
      return false;
    }
  }

  /// 显示来电弹窗（系统级 Heads-up 通知）
  /// 
  /// [callerName] 来电者名称
  /// [callerId] 来电者 ID
  /// [callType] 通话类型 'voice' 或 'video'
  /// [channelName] 通话频道名称
  /// [isGroupCall] 是否是群组通话
  /// [groupId] 群组 ID（群组通话时提供）
  /// [members] 群组成员列表（群组通话时提供）
  Future<bool> showCallOverlay({
    required String callerName,
    required int callerId,
    required String callType,
    required String channelName,
    bool isGroupCall = false,
    int? groupId,
    List<Map<String, dynamic>>? members,
  }) async {
    if (!Platform.isAndroid) {
      logger.debug('⚠️ 原生来电服务仅支持 Android 平台');
      return false;
    }

    try {
      // 🔴 先启动前台服务（只在有来电时启动）
      logger.debug('🚀 启动前台服务以显示来电弹窗...');
      await startCallService();
      
      logger.debug('═══════════════════════════════════════');
      logger.debug('📲 [showCallOverlay] 准备显示来电弹窗');
      logger.debug('📲 参数信息:');
      logger.debug('   - callerName: $callerName');
      logger.debug('   - callerId: $callerId');
      logger.debug('   - callType: $callType');
      logger.debug('   - channelName: $channelName');
      logger.debug('   - isGroupCall: $isGroupCall');
      logger.debug('   - groupId: $groupId');
      logger.debug('   - members: ${members?.length ?? 0} 个成员');
      
      final params = {
        'callerName': callerName,
        'callerId': callerId,
        'callType': callType,
        'channelName': channelName,
        'isGroupCall': isGroupCall,
      };

      // 如果是群组通话，添加群组信息
      if (isGroupCall && groupId != null) {
        logger.debug('📲 [showCallOverlay] 添加群组信息到 params');
        params['groupId'] = groupId;
        logger.debug('📲 [showCallOverlay] 已添加 groupId: $groupId');
        if (members != null) {
          params['members'] = members;
          logger.debug('📲 [showCallOverlay] 已添加 members: ${members.length} 个');
          logger.debug('📲 [showCallOverlay] members 详情: $members');
        }
      }

      logger.debug('📲 [showCallOverlay] 最终 params: $params');
      logger.debug('═══════════════════════════════════════');

      final result = await _channel.invokeMethod<bool>('showCallOverlay', params);
      
      final callTypeStr = isGroupCall ? '群组${callType == 'video' ? '视频' : '语音'}通话' : '${callType == 'video' ? '视频' : '语音'}通话';
      logger.debug('📲 显示来电弹窗: $callerName, 类型: $callTypeStr, 结果: $result');
      return result ?? false;
    } catch (e) {
      logger.debug('❌ 显示来电弹窗失败: $e');
      logger.debug('❌ 错误堆栈: ${StackTrace.current}');
      return false;
    }
  }

  /// 关闭来电弹窗
  Future<bool> dismissCallOverlay() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('dismissCallOverlay');
      logger.debug('❌ 来电弹窗已关闭: $result');
      
      // 🔴 关闭弹窗后停止前台服务
      logger.debug('🛑 停止前台服务...');
      await stopCallService();
      
      return result ?? false;
    } catch (e) {
      logger.debug('❌ 关闭来电弹窗失败: $e');
      return false;
    }
  }

  /// 停止来电前台服务
  Future<bool> stopCallService() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('stopCallService');
      logger.debug('🛑 来电前台服务已停止: $result');
      return result ?? false;
    } catch (e) {
      logger.debug('❌ 停止来电前台服务失败: $e');
      return false;
    }
  }
}
