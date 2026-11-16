import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;

import 'package:akar/core/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageCompressHelper {
  static const double defaultWatermarkSizeRatio = 0.30;
  static const double defaultWatermarkOpacity = 0.20;

  static int _tempFileCounter = 0;
  static Uint8List? _cachedWatermarkBytes;

  /// Mengompres gambar input (JPEG, PNG, HEIC, WEBP, dll.) menjadi `.webp`,
  /// serta menambahkan watermark logo general di tengah secara default.
  static Future<File> compressToWebp(
    File file, {
    int quality = 80,
    int minWidth = 1080,
    int minHeight = 1080,
    bool watermark = true,
    double watermarkSizeRatio = defaultWatermarkSizeRatio,
    double watermarkOpacity = defaultWatermarkOpacity,
    Uint8List? watermarkBytes,
  }) async {
    try {
      if (!file.existsSync()) return file;

      final compressedBase = await _compressRawToWebp(
        file,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      if (!watermark) return compressedBase;

      final logoBytes = await _loadWatermarkBytes(watermarkBytes);
      if (logoBytes == null || logoBytes.isEmpty) {
        return compressedBase;
      }

      final watermarkedPng = await _applyWatermark(
        compressedBase,
        logoBytes: logoBytes,
        sizeRatio: watermarkSizeRatio,
        opacity: watermarkOpacity,
      );
      if (watermarkedPng == null) {
        return compressedBase;
      }

      final finalWebp = await _compressRawToWebp(
        watermarkedPng,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      if (finalWebp.path != watermarkedPng.path) {
        _deleteSafely(watermarkedPng);
      }
      if (compressedBase.path != file.path &&
          compressedBase.path != finalWebp.path) {
        _deleteSafely(compressedBase);
      }

      return finalWebp;
    } catch (_) {
      return file;
    }
  }

  static Future<File> _compressRawToWebp(
    File file, {
    required int quality,
    required int minWidth,
    required int minHeight,
  }) async {
    try {
      final tempDir = await _resolveTempDir();
      final targetPath = _nextTempPath(
        tempDir,
        prefix: 'compressed',
        ext: 'webp',
      );

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        format: CompressFormat.webp,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      if (result != null) {
        final compressedFile = File(result.path);
        if (compressedFile.existsSync() && compressedFile.lengthSync() > 0) {
          return compressedFile;
        }
      }
      return file;
    } catch (_) {
      return file;
    }
  }

  static Future<File?> _applyWatermark(
    File sourceFile, {
    required Uint8List logoBytes,
    required double sizeRatio,
    required double opacity,
  }) async {
    try {
      final sourceBytes = await sourceFile.readAsBytes();
      final outputBytes = await Isolate.run(
        () => _compositeWatermarkBytes(
          sourceBytes: sourceBytes,
          logoBytes: logoBytes,
          sizeRatio: sizeRatio,
          opacity: opacity,
        ),
      );
      if (outputBytes == null || outputBytes.isEmpty) return null;

      final tempDir = await _resolveTempDir();
      final outFile = File(
        _nextTempPath(tempDir, prefix: 'watermarked', ext: 'png'),
      );
      await outFile.writeAsBytes(outputBytes, flush: true);
      return outFile;
    } catch (_) {
      return null;
    }
  }

  static Uint8List? _compositeWatermarkBytes({
    required Uint8List sourceBytes,
    required Uint8List logoBytes,
    required double sizeRatio,
    required double opacity,
  }) {
    final decodedSource = img.decodeImage(sourceBytes);
    final decodedLogo = img.decodeImage(logoBytes);
    if (decodedSource == null || decodedLogo == null) return null;

    var base = img.bakeOrientation(decodedSource);
    if (base.numChannels < 3 || base.hasPalette) {
      base = base.convert(numChannels: 4);
    }

    final shorterSide = math.min(base.width, base.height);
    if (shorterSide <= 0) return null;

    final clampedRatio = sizeRatio.clamp(0.05, 1.0);
    final targetLogoSize = (shorterSide * clampedRatio).round().clamp(
      1,
      shorterSide,
    );
    final clampedOpacity = opacity.clamp(0.0, 1.0);

    var resizedLogo = img.copyResize(
      decodedLogo,
      width: targetLogoSize,
      height: targetLogoSize,
      interpolation: img.Interpolation.average,
    );
    if (resizedLogo.numChannels != 4) {
      resizedLogo = resizedLogo.convert(numChannels: 4);
    }
    for (final pixel in resizedLogo) {
      if (pixel.a > 0) {
        pixel.a = (pixel.a * clampedOpacity).round();
      }
    }

    img.compositeImage(
      base,
      resizedLogo,
      dstX: (base.width - targetLogoSize) ~/ 2,
      dstY: (base.height - targetLogoSize) ~/ 2,
    );

    return Uint8List.fromList(img.encodePng(base, level: 1));
  }

  static Future<Uint8List?> _loadWatermarkBytes(
    Uint8List? overrideBytes,
  ) async {
    if (overrideBytes != null) return overrideBytes;
    if (_cachedWatermarkBytes != null) return _cachedWatermarkBytes;

    try {
      final data = await rootBundle.load(AppConstants.logoGeneralAsset);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      _cachedWatermarkBytes = bytes;
      return bytes;
    } catch (_) {
      return null;
    }
  }

  static Future<Directory> _resolveTempDir() async {
    try {
      return await getTemporaryDirectory();
    } catch (_) {
      return Directory.systemTemp;
    }
  }

  static String _nextTempPath(
    Directory dir, {
    required String prefix,
    required String ext,
  }) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final seq = ++_tempFileCounter;
    return '${dir.path}/${prefix}_${ts}_$seq.$ext';
  }

  static void _deleteSafely(File file) {
    try {
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {}
  }
}
