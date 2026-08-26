import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressHelper {
  /// Compresses any input image format (JPEG, PNG, HEIC, BMP, WEBP, etc.)
  /// into optimized `.webp` format.
  static Future<File> compressToWebp(
    File file, {
    int quality = 80,
    int minWidth = 1080,
    int minHeight = 1080,
  }) async {
    try {
      if (!file.existsSync()) return file;

      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.webp';

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
      // Fallback to original file if compression fails or format unsupported
      return file;
    }
  }
}
