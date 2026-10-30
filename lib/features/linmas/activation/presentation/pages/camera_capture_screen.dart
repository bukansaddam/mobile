import 'dart:io';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

class CameraCaptureScreen {
  CameraCaptureScreen._();

  /// Membuka kamera perangkat HP secara langsung dan mengompres foto ke format WebP.
  static Future<String?> open(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        final compressedWebpFile = await ImageCompressHelper.compressToWebp(
          File(photo.path),
        );
        return compressedWebpFile.path;
      }
      return null;
    } catch (e) {
      if (context.mounted) _showError(context, e);
      return null;
    }
  }

  /// Merekam video lewat kamera; hasil .mov atau berkas besar dikompres ke MP4.
  static Future<String?> openVideo(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 1),
      );
      if (video == null) return null;

      final file = File(video.path);
      FileSecurityUtils.validateVideoFile(file);

      if (!context.mounted) return null;

      // .mov iOS membawa rotation matrix yang memicu OSStatus -12784 saat diputar.
      final isMov = file.path.toLowerCase().endsWith('.mov');
      final isLarge = file.lengthSync() > 10 * 1024 * 1024;

      if (isMov || isLarge) {
        final compressed = await _compressToLimit(context, file);
        if (compressed != null) {
          return compressed;
        }
      }

      if (file.lengthSync() <= FileSecurityUtils.defaultMaxVideoSizeBytes) {
        return video.path;
      }
      return null;
    } on FileSecurityException catch (e) {
      if (context.mounted) _showError(context, e.message);
      return null;
    } catch (e) {
      if (context.mounted) _showError(context, e);
      return null;
    }
  }

  static Future<String?> _compressToLimit(
    BuildContext context,
    File original,
  ) async {
    _showCompressingDialog(context);
    try {
      for (final quality in [
        VideoQuality.DefaultQuality,
        VideoQuality.LowQuality,
      ]) {
        final result = await VideoCompress.compressVideo(
          original.path,
          quality: quality,
          deleteOrigin: false,
        );
        final compressed = File(result?.path ?? '');
        if (!compressed.existsSync()) continue;

        if (compressed.lengthSync() <=
            FileSecurityUtils.defaultMaxVideoSizeBytes) {
          // video_compress menulis ke folder permanen, jadi salin ke cache.
          final tempDir = await getTemporaryDirectory();
          final target = await compressed.copy(
            '${tempDir.path}/compressed_'
            '${DateTime.now().millisecondsSinceEpoch}.mp4',
          );
          await compressed.delete();
          return target.path;
        }
        await compressed.delete();
      }

      if (context.mounted) {
        _showError(
          context,
          'Video masih melebihi 100 MB setelah dikompres. '
          'Rekam dengan durasi lebih pendek.',
        );
      }
      return null;
    } catch (e) {
      if (context.mounted) _showError(context, 'Gagal mengompres video.');
      return null;
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  static void _showCompressingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text('Mengompres video...')),
            ],
          ),
        ),
      ),
    );
  }

  static void _showError(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal membuka kamera perangkat: $error'),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
