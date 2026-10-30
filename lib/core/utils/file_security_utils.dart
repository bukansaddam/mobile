import 'dart:io';

class FileSecurityException implements Exception {
  final String message;
  const FileSecurityException(this.message);

  @override
  String toString() => message;
}

class FileSecurityUtils {
  FileSecurityUtils._();

  /// Batas ukuran maksimal berkas default: 10 MB
  static const int defaultMaxSizeBytes = 10 * 1024 * 1024;

  /// Batas backend untuk unggahan video.
  static const int defaultMaxVideoSizeBytes = 100 * 1024 * 1024;

  /// Daftar ekstensi gambar yang diizinkan untuk diunggah
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'heic',
  ];

  static const List<String> allowedVideoExtensions = ['mp4', 'mov', 'webm'];

  static bool isVideoPath(String path) =>
      allowedVideoExtensions.contains(_extensionOf(path));

  /// Memvalidasi keamanan berkas sebelum diproses atau diunggah:
  /// 1. Berkas harus ada secara fisik di storage.
  /// 2. Ukuran berkas tidak boleh melebihi [maxSizeBytes].
  /// 3. Ekstensi berkas harus termasuk dalam format gambar yang diizinkan.
  static void validateImageFile(
    File file, {
    int maxSizeBytes = defaultMaxSizeBytes,
  }) {
    _validateFile(file, maxSizeBytes);
    final extension = _extensionOf(file.path);
    if (!allowedImageExtensions.contains(extension)) {
      throw FileSecurityException(
        'Format berkas .$extension tidak didukung. Harap pilih gambar format JPG, PNG, atau WEBP.',
      );
    }
  }

  static void validateVideoFile(
    File file, {
    int maxSizeBytes = defaultMaxVideoSizeBytes,
  }) {
    _validateFile(file, maxSizeBytes);
    final extension = _extensionOf(file.path);
    if (!allowedVideoExtensions.contains(extension)) {
      throw FileSecurityException(
        'Format berkas .$extension tidak didukung. Harap pilih video format MP4, MOV, atau WEBM.',
      );
    }
  }

  static void _validateFile(File file, int maxSizeBytes) {
    if (!file.existsSync()) {
      throw const FileSecurityException(
        'Berkas tidak ditemukan pada perangkat.',
      );
    }

    final fileSize = file.lengthSync();
    if (fileSize == 0) {
      throw const FileSecurityException('Berkas kosong (0 bytes).');
    }

    if (fileSize > maxSizeBytes) {
      final maxMb = (maxSizeBytes / (1024 * 1024)).toStringAsFixed(1);
      final currentMb = (fileSize / (1024 * 1024)).toStringAsFixed(1);
      throw FileSecurityException(
        'Ukuran berkas (${currentMb}MB) melebihi batas maksimal yang diizinkan (${maxMb}MB).',
      );
    }
  }

  static String _extensionOf(String path) => path.split('.').last.toLowerCase();

  /// Memeriksa apakah berkas valid tanpa melempar Exception
  static bool isValidImage(
    File file, {
    int maxSizeBytes = defaultMaxSizeBytes,
  }) {
    try {
      validateImageFile(file, maxSizeBytes: maxSizeBytes);
      return true;
    } catch (_) {
      return false;
    }
  }
}
