// 移动端录音实现 - 使用 record 包
// 统一 iOS/Android 都使用 record 包进行录音

import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/logger.dart';

/// OSS上传信息
class OssUploadInfo {
  final String uploadUrl;
  final String fileUrl;
  final String contentType;

  OssUploadInfo({
    required this.uploadUrl,
    required this.fileUrl,
    required this.contentType,
  });

  factory OssUploadInfo.fromJson(Map<String, dynamic> json) {
    return OssUploadInfo(
      uploadUrl: json['uploadUrl'] as String,
      fileUrl: json['fileUrl'] as String,
      contentType: json['contentType'] as String? ?? 'audio/mp4',
    );
  }
}

/// 语音录制服务（移动端实现）
///
/// 功能：
/// - 支持最长60秒录音
/// - 使用AAC编码格式（M4A容器）
/// - 上传到OSS存储
/// - 返回语音URL和时长
class VoiceRecordService {
  static final VoiceRecordService _instance = VoiceRecordService._internal();
  factory VoiceRecordService() => _instance;
  VoiceRecordService._internal();

  final AudioRecorder _recorder = AudioRecorder();
  final Dio _dio = Dio();

  // 录音状态
  bool _isRecording = false;
  String? _currentRecordPath;

  // 最大录音时长（秒）
  static const int maxDurationSeconds = 60;

  // 录音状态回调
  Function(int seconds)? onDurationUpdate;
  Function()? onMaxDurationReached;
  Function(String error)? onError;

  // 录音时长
  int _currentDuration = 0;
  StreamSubscription<RecordState>? _stateSubscription;
  Timer? _durationTimer;

  /// 是否正在录音
  bool get isRecording => _isRecording;

  /// 当前录音时长（秒）
  int get currentDuration => _currentDuration;

  /// 是否已初始化（record 包无需显式初始化）
  bool get isInited => true;

  /// 初始化（record 包无需显式初始化，保留接口兼容）
  Future<void> init() async {}

  /// 检查麦克风权限
  Future<bool> checkPermission() async {
    try {
      final status = await Permission.microphone.status;
      return status.isGranted;
    } catch (e) {
      logger.error('检查麦克风权限失败', error: e);
      return false;
    }
  }

  /// 开始录音
  Future<bool> startRecording() async {
    if (_isRecording) {
      logger.debug('⚠️ 已经在录音中');
      return false;
    }

    try {
      // 检查权限
      if (!await _recorder.hasPermission()) {
        final status = await Permission.microphone.request();
        if (!status.isGranted) {
          throw Exception('麦克风权限未授予');
        }
      }

      // 获取临时目录
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordPath = '${tempDir.path}/voice_$timestamp.m4a';

      logger.debug('🎤 开始录音: $_currentRecordPath');

      // 重置时长
      _currentDuration = 0;

      // 开始录制
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 16000,
        ),
        path: _currentRecordPath!,
      );

      _isRecording = true;
      final startTime = DateTime.now();

      // 使用定时器更新时长
      _durationTimer?.cancel();
      _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _currentDuration = DateTime.now().difference(startTime).inSeconds;
        if (_currentDuration > maxDurationSeconds) {
          _currentDuration = maxDurationSeconds;
        }
        onDurationUpdate?.call(_currentDuration);

        if (_currentDuration >= maxDurationSeconds) {
          logger.debug('⏱️ 达到最大录音时长，自动停止');
          _durationTimer?.cancel();
          _durationTimer = null;
          onMaxDurationReached?.call();
        }
      });

      logger.debug('🎤 录音已开始');
      return true;
    } catch (e) {
      logger.error('开始录音失败', error: e);
      onError?.call('开始录音失败: $e');
      _cleanup();
      return false;
    }
  }

  /// 停止录音
  Future<Map<String, dynamic>?> stopRecording() async {
    if (!_isRecording) {
      logger.debug('⚠️ 没有正在进行的录音');
      return null;
    }

    try {
      final duration = _currentDuration;

      _durationTimer?.cancel();
      _durationTimer = null;
      _isRecording = false;

      final path = await _recorder.stop();

      logger.debug('🎤 停止录音: path=$path, duration=${duration}秒');

      if (path == null || path.isEmpty) {
        logger.debug('❌ 录音文件路径为空');
        return null;
      }

      final file = File(path);
      if (!await file.exists()) {
        logger.debug('❌ 录音文件不存在: $path');
        return null;
      }

      final fileSize = await file.length();
      logger.debug('📁 录音文件大小: $fileSize bytes');

      if (duration < 1) {
        logger.debug('⚠️ 录音时长太短，不保存');
        await file.delete();
        return null;
      }

      return {
        'path': path,
        'duration': duration,
        'size': fileSize,
      };
    } catch (e) {
      logger.error('停止录音失败', error: e);
      _cleanup();
      return null;
    }
  }

  /// 取消录音
  Future<void> cancelRecording() async {
    if (!_isRecording) return;

    try {
      await _recorder.stop();

      if (_currentRecordPath != null) {
        final file = File(_currentRecordPath!);
        if (await file.exists()) {
          await file.delete();
          logger.debug('🗑️ 已删除取消的录音文件');
        }
      }
    } catch (e) {
      logger.error('取消录音失败', error: e);
    } finally {
      _cleanup();
    }
  }

  /// 获取上传URL
  Future<OssUploadInfo> _getOpusUploadUrl({
    required String token,
    required String fileName,
  }) async {
    try {
      final url = ApiConfig.getApiUrl(ApiConfig.ossGetOpusUploadUrl);
      final response = await _dio.post(
        url,
        data: {'fileName': fileName},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['code'] == 0 || data['code'] == 200) {
          return OssUploadInfo.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          throw Exception(data['message'] ?? '获取上传URL失败');
        }
      } else {
        throw Exception('获取上传URL失败: ${response.statusCode}');
      }
    } catch (e) {
      logger.error('获取语音上传URL失败', error: e);
      rethrow;
    }
  }

  /// 上传语音文件到OSS
  static Future<Map<String, dynamic>> uploadVoice({
    required String token,
    required String filePath,
    Function(int uploaded, int total)? onProgress,
  }) async {
    final service = VoiceRecordService();
    return service._uploadVoiceInternal(
      token: token,
      filePath: filePath,
      onProgress: onProgress,
    );
  }

  Future<Map<String, dynamic>> _uploadVoiceInternal({
    required String token,
    required String filePath,
    Function(int uploaded, int total)? onProgress,
  }) async {
    try {
      logger.debug('📤 开始上传语音文件: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('语音文件不存在: $filePath');
      }

      final fileName = filePath.split('/').last;
      final fileLength = await file.length();
      logger.debug('📁 准备上传文件大小: $fileLength bytes');

      if (fileLength == 0) {
        throw Exception('语音文件为空，无法上传');
      }

      // 1. 向后端请求 OSS 上传 URL
      final uploadInfo = await _getOpusUploadUrl(
        token: token,
        fileName: fileName,
      );

      logger.debug('✅ 获取上传URL成功:');
      logger.debug('   uploadUrl: ${uploadInfo.uploadUrl}');
      logger.debug('   fileUrl: ${uploadInfo.fileUrl}');

      // 2. 上传到 OSS
      final fileBytes = await file.readAsBytes();

      final request = http.Request('PUT', Uri.parse(uploadInfo.uploadUrl));
      request.bodyBytes = fileBytes;
      request.headers['Content-Type'] = uploadInfo.contentType;
      request.headers['Content-Length'] = fileBytes.length.toString();

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('上传到OSS失败: ${response.statusCode}');
      }

      onProgress?.call(fileBytes.length, fileBytes.length);

      logger.debug('✅ 语音文件上传成功: ${uploadInfo.fileUrl}');

      return {
        'url': uploadInfo.fileUrl,
        'file_name': fileName,
      };
    } catch (e) {
      logger.error('上传语音文件失败', error: e);
      rethrow;
    }
  }

  /// 清理资源
  void _cleanup() {
    _isRecording = false;
    _currentRecordPath = null;
    _currentDuration = 0;
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  /// 释放资源
  Future<void> dispose() async {
    _cleanup();
    await _recorder.dispose();
  }
}
