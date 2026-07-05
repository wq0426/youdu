import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/logger.dart';
import 'chunk_download_service.dart';

/// 媒体缓存服务：语音/视频文件的本地持久缓存。
///
/// 核心设计（KV 映射）：
/// - key = 归一化 URL（**仅取 path，丢弃 OSS 签名等 query 参数**）的 sha1。
///   同一资源每次签名不同的 URL 也能命中同一份缓存。
/// - value = 本地文件路径 + 大小 + 类型 + 最后访问时间（LRU 淘汰依据）。
/// - 索引持久化为缓存目录下的 index.json（写入防抖 + tmp+rename 原子替换）。
///
/// 策略：
/// - 语音（几十 KB）：[cacheVoice] 阻塞下载后播放本地文件，感知不到延迟。
/// - 视频（可能很大）：首播用 networkUrl 流式秒开，同时 [prefetchVideo] 在后台
///   经 ChunkDownloadService（分片/断点续传）落盘；再次播放命中本地文件零流量。
///   预取串行执行：ChunkDownloadService 是共享状态单例，且避免抢占首播带宽。
/// - 分类型容量上限（语音 50MB / 视频 500MB），超限按最后访问时间 LRU 淘汰。
/// - 存储在应用支持目录（非 temp），不会被系统随意清空；读取时校验文件存在，
///   防止外部清理后索引悬空。
class MediaCacheService {
  static final MediaCacheService _instance = MediaCacheService._internal();
  factory MediaCacheService() => _instance;
  MediaCacheService._internal();

  static const int _voiceMaxBytes = 50 * 1024 * 1024; // 语音缓存上限 50MB
  static const int _videoMaxBytes = 500 * 1024 * 1024; // 视频缓存上限 500MB

  Directory? _cacheDir;
  Map<String, _CacheEntry> _index = {};
  Future<void>? _initFuture;
  Timer? _indexSaveDebounce;

  final Dio _dio = Dio();

  // 下载中去重：同一资源的并发请求共享同一个 Future
  final Map<String, Future<File?>> _voiceDownloads = {};
  final Set<String> _videoPrefetching = {};
  // 视频预取串行队列
  Future<void> _videoQueue = Future.value();

  /// 归一化缓存 key：仅取 URL path（丢弃签名 query）做 sha1
  static String cacheKeyFor(String url) {
    final path = Uri.tryParse(url)?.path ?? url;
    return sha1.convert(utf8.encode(path)).toString();
  }

  /// 从 URL path 提取文件扩展名（无法识别时返回空串）
  static String _extensionFor(String url) {
    final path = Uri.tryParse(url)?.path ?? url;
    final name = path.split('/').last;
    if (name.contains('.')) {
      final ext = name.split('.').last.toLowerCase();
      // 防御异常超长"扩展名"
      if (ext.isNotEmpty && ext.length <= 8) return '.$ext';
    }
    return '';
  }

  Future<void> _ensureInit() {
    return _initFuture ??= _init();
  }

  Future<void> _init() async {
    try {
      final base = await getApplicationSupportDirectory();
      _cacheDir = Directory('${base.path}/media_cache');
      await _cacheDir!.create(recursive: true);

      final indexFile = File('${_cacheDir!.path}/index.json');
      if (await indexFile.exists()) {
        final raw = json.decode(await indexFile.readAsString());
        if (raw is Map<String, dynamic>) {
          _index = raw.map((k, v) =>
              MapEntry(k, _CacheEntry.fromJson(v as Map<String, dynamic>)));
        }
      }
      logger.debug('📦 [媒体缓存] 初始化完成，索引 ${_index.length} 条');
    } catch (e) {
      logger.error('📦 [媒体缓存] 初始化失败: $e');
      _index = {};
    }
  }

  /// 索引持久化（防抖 500ms，tmp+rename 原子替换）
  void _scheduleSaveIndex() {
    _indexSaveDebounce?.cancel();
    _indexSaveDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final dir = _cacheDir;
        if (dir == null) return;
        final tmp = File('${dir.path}/index.json.tmp');
        await tmp.writeAsString(json
            .encode(_index.map((k, v) => MapEntry(k, v.toJson()))));
        await tmp.rename('${dir.path}/index.json');
      } catch (e) {
        logger.debug('📦 [媒体缓存] 索引保存失败: $e');
      }
    });
  }

  /// 查询缓存：命中返回本地文件（并刷新 LRU 访问时间），未命中返回 null。
  /// 读取时校验文件存在，防止外部清理后索引悬空。
  Future<File?> lookup(String url) async {
    await _ensureInit();
    final key = cacheKeyFor(url);
    final entry = _index[key];
    if (entry == null) return null;
    final file = File(entry.localPath);
    if (!await file.exists()) {
      _index.remove(key);
      _scheduleSaveIndex();
      return null;
    }
    entry.lastAccessMs = DateTime.now().millisecondsSinceEpoch;
    _scheduleSaveIndex();
    return file;
  }

  /// 缓存语音文件（小文件，阻塞下载）。已缓存/下载中自动去重。
  /// 返回本地文件；失败返回 null（调用方回退到 URL 播放）。
  Future<File?> cacheVoice(String url) async {
    await _ensureInit();
    final cached = await lookup(url);
    if (cached != null) return cached;

    final key = cacheKeyFor(url);
    // 并发去重：同一资源共享一个下载 Future
    return _voiceDownloads[key] ??= _downloadVoice(url, key).whenComplete(() {
      _voiceDownloads.remove(key);
    });
  }

  Future<File?> _downloadVoice(String url, String key) async {
    try {
      final savePath = '${_cacheDir!.path}/voice_$key${_extensionFor(url)}';
      // dio 流式写盘，不经过内存整包
      await _dio.download(url, savePath);
      final file = File(savePath);
      final size = await file.length();
      _addEntry(key, url, savePath, size, 'voice');
      logger.debug('📦 [媒体缓存] 语音已缓存 ($size bytes): $url');
      unawaited(_evictIfNeeded('voice', _voiceMaxBytes));
      return file;
    } catch (e) {
      logger.error('📦 [媒体缓存] 语音下载失败: $e');
      return null;
    }
  }

  /// 后台预取视频（不阻塞播放）。已缓存/预取中自动去重；串行排队执行。
  void prefetchVideo(String url) {
    unawaited(_prefetchVideo(url));
  }

  Future<void> _prefetchVideo(String url) async {
    await _ensureInit();
    final key = cacheKeyFor(url);
    if (_index.containsKey(key) || _videoPrefetching.contains(key)) return;
    _videoPrefetching.add(key);

    _videoQueue = _videoQueue.then((_) async {
      try {
        // 排队期间可能已被缓存
        if (_index.containsKey(key)) return;
        final savePath = '${_cacheDir!.path}/video_$key${_extensionFor(url)}';
        logger.debug('📦 [媒体缓存] 开始后台预取视频: $url');
        // 分片下载（断点续传/重试）；OSS 支持 Range
        final result = await ChunkDownloadService().download(
          url: url,
          savePath: savePath,
        );
        if (result != null) {
          final size = await File(result).length();
          _addEntry(key, url, result, size, 'video');
          logger.debug('📦 [媒体缓存] 视频已缓存 ($size bytes): $url');
          await _evictIfNeeded('video', _videoMaxBytes);
        }
      } catch (e) {
        logger.error('📦 [媒体缓存] 视频预取失败: $e');
      } finally {
        _videoPrefetching.remove(key);
      }
    });
    await _videoQueue;
  }

  void _addEntry(
      String key, String url, String localPath, int size, String type) {
    _index[key] = _CacheEntry(
      urlPath: Uri.tryParse(url)?.path ?? url,
      localPath: localPath,
      fileSize: size,
      mediaType: type,
      lastAccessMs: DateTime.now().millisecondsSinceEpoch,
    );
    _scheduleSaveIndex();
  }

  /// 分类型容量上限 + LRU 淘汰（按最后访问时间从旧到新删除）
  Future<void> _evictIfNeeded(String type, int maxBytes) async {
    try {
      final entries = _index.entries
          .where((e) => e.value.mediaType == type)
          .toList()
        ..sort((a, b) => a.value.lastAccessMs.compareTo(b.value.lastAccessMs));
      var total = entries.fold<int>(0, (s, e) => s + e.value.fileSize);
      for (final e in entries) {
        if (total <= maxBytes) break;
        try {
          await File(e.value.localPath).delete();
        } catch (_) {}
        _index.remove(e.key);
        total -= e.value.fileSize;
        logger.debug('📦 [媒体缓存] LRU 淘汰 $type: ${e.value.urlPath}');
      }
      _scheduleSaveIndex();
    } catch (e) {
      logger.debug('📦 [媒体缓存] LRU 淘汰失败: $e');
    }
  }
}

class _CacheEntry {
  final String urlPath;
  final String localPath;
  final int fileSize;
  final String mediaType; // 'voice' | 'video'
  int lastAccessMs;

  _CacheEntry({
    required this.urlPath,
    required this.localPath,
    required this.fileSize,
    required this.mediaType,
    required this.lastAccessMs,
  });

  factory _CacheEntry.fromJson(Map<String, dynamic> j) => _CacheEntry(
        urlPath: j['url_path'] as String? ?? '',
        localPath: j['local_path'] as String? ?? '',
        fileSize: j['file_size'] as int? ?? 0,
        mediaType: j['media_type'] as String? ?? 'voice',
        lastAccessMs: j['last_access_ms'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'url_path': urlPath,
        'local_path': localPath,
        'file_size': fileSize,
        'media_type': mediaType,
        'last_access_ms': lastAccessMs,
      };
}
