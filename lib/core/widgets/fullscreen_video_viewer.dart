import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideoViewer extends StatefulWidget {
  final String pathOrUrl;
  final String? title;
  final Map<String, String>? httpHeaders;

  const FullscreenVideoViewer({
    super.key,
    required this.pathOrUrl,
    this.title,
    this.httpHeaders,
  });

  static void show(
    BuildContext context, {
    required String pathOrUrl,
    String? title,
    Map<String, String>? httpHeaders,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => FullscreenVideoViewer(
          pathOrUrl: pathOrUrl,
          title: title,
          httpHeaders: httpHeaders,
        ),
      ),
    );
  }

  @override
  State<FullscreenVideoViewer> createState() => _FullscreenVideoViewerState();
}

class _FullscreenVideoViewerState extends State<FullscreenVideoViewer> {
  VideoPlayerController? _controller;
  String? _error;
  String _statusMessage = 'Memuat video...';
  final List<File> _temporaryFiles = [];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final url = widget.pathOrUrl;
      final isRemote = url.startsWith('http://') || url.startsWith('https://');
      final uri = Uri.tryParse(url);
      final apiHost = Uri.tryParse(ApiConstants.baseUrl)?.host;
      final isInternalApi = isRemote && uri != null && uri.host == apiHost;

      File? file;
      if (!isRemote) {
        file = File(url);
      } else if (isInternalApi) {
        file = await _downloadToFile(url);
      }

      VideoPlayerController controller = file != null
          ? VideoPlayerController.file(file)
          : VideoPlayerController.networkUrl(
              Uri.parse(url),
              httpHeaders: widget.httpHeaders ?? const {},
            );

      try {
        await controller.initialize();
      } catch (initError) {
        AppLogger.w(
          '[VIDEO_VIEWER] Inisialisasi awal video gagal: $initError. '
          'Mencoba transcode fallback...',
        );
        await controller.dispose();

        if (!mounted || _isDisposed) return;
        setState(() => _statusMessage = 'Menyesuaikan format video...');

        // URL eksternal belum punya berkas lokal; unduh sebelum transcode.
        file ??= await _downloadToFile(url);

        if (file.existsSync()) {
          final mediaInfo = await VideoCompress.compressVideo(
            file.path,
            quality: VideoQuality.HighestQuality,
            deleteOrigin: false,
          );

          if (!mounted || _isDisposed) return;

          final transcodedPath = mediaInfo?.file?.path ?? mediaInfo?.path;
          if (transcodedPath != null) {
            final transcodedFile = File(transcodedPath);
            if (transcodedFile.existsSync()) {
              _temporaryFiles.add(transcodedFile);
              controller = VideoPlayerController.file(transcodedFile);
              await controller.initialize();
            } else {
              rethrow;
            }
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      await controller.setLooping(true);
      await controller.play();

      if (!mounted || _isDisposed) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (e, s) {
      AppLogger.e('[VIDEO_VIEWER] Gagal memutar video', e, s);
      if (mounted && !_isDisposed) {
        setState(() => _error = 'Video tidak dapat diputar.');
      }
    }
  }

  Future<File> _downloadToFile(String url) async {
    final response = await DioClient.instance.get<ResponseBody>(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: widget.httpHeaders,
        receiveTimeout: const Duration(minutes: 5),
      ),
    );
    final contentType = response.headers.value(Headers.contentTypeHeader);
    final disposition = response.headers.value('content-disposition');
    final extension =
        _extensionFromContentType(contentType) ??
        _extensionFromDisposition(disposition) ??
        _extensionFromPath(Uri.tryParse(url)?.path ?? '') ??
        '.mp4';

    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/video_viewer_'
      '${DateTime.now().millisecondsSinceEpoch}$extension',
    );
    final sink = file.openWrite();
    await for (final chunk in response.data!.stream) {
      sink.add(chunk);
    }
    await sink.flush();
    await sink.close();
    AppLogger.i(
      '[VIDEO_VIEWER] $contentType -> ${file.path} '
      '(${file.lengthSync()} bytes)',
    );
    _temporaryFiles.add(file);
    return file;
  }

  String? _extensionFromContentType(String? contentType) {
    switch (contentType?.split(';').first.trim().toLowerCase()) {
      case 'video/quicktime':
        return '.mov';
      case 'video/mp4':
        return '.mp4';
      case 'video/webm':
        return '.webm';
      case 'video/x-m4v':
        return '.m4v';
      case 'video/3gpp':
      case 'video/3gp':
        return '.3gp';
      case 'video/x-msvideo':
      case 'video/avi':
        return '.avi';
      case 'video/x-matroska':
        return '.mkv';
    }
    return null;
  }

  String? _extensionFromDisposition(String? disposition) {
    if (disposition == null) return null;
    final match = RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);
    return _extensionFromPath(match?.group(1) ?? '');
  }

  String? _extensionFromPath(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == path.length - 1) return null;
    return path.substring(dotIndex).toLowerCase();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.dispose();
    VideoCompress.cancelCompression();
    for (final file in _temporaryFiles) {
      try {
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (_) {}
    }
    super.dispose();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title ?? 'Video Bukti',
          style: const TextStyle(fontSize: 16, color: AppColors.white),
        ),
      ),
      body: Center(
        child: _error != null
            ? Text(_error!, style: const TextStyle(color: AppColors.white))
            : controller == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.white),
                  const SizedBox(height: 12),
                  Text(
                    _statusMessage,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              )
            : GestureDetector(
                onTap: _togglePlay,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                    if (!controller.value.isPlaying)
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.white,
                        size: 72,
                      ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: controller == null
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppColors.primary,
                  bufferedColor: AppColors.grey600,
                  backgroundColor: AppColors.grey800,
                ),
              ),
            ),
    );
  }
}
