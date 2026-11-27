import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;

import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image_compress_plus/image_compress_plus.dart';
import 'package:path_provider/path_provider.dart';

typedef _GeoMeta = ({
  DateTime timestamp,
  double? latitude,
  double? longitude,
  String address,
});

class ImageCompressHelper {
  static const double defaultWatermarkSizeRatio = 0.50;
  static const double defaultWatermarkOpacity = 0.20;

  static const List<String> _monthsShortId = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static int _tempFileCounter = 0;
  static Uint8List? _cachedWatermarkBytes;

  /// Memvalidasi daftar lampiran media (foto/video) sebelum dikirim ke server,
  /// mengompres gambar ke `.webp`, serta menyematkan watermark logo & geo-stamp.
  static Future<List<File>> prepareMediaFiles(
    List<File> attachments, {
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? address,
    bool includeGeoStamp = true,
    bool resolveDeviceLocationIfMissing = false,
  }) async {
    if (attachments.isEmpty) return const [];

    final hasImage = attachments.any(
      (f) => !FileSecurityUtils.isVideoPath(f.path),
    );
    final _GeoMeta? resolvedGeo = hasImage && includeGeoStamp
        ? await _resolveGeoMetadata(
            timestamp: timestamp,
            latitude: latitude,
            longitude: longitude,
            address: address,
            resolveDeviceLocationIfMissing: resolveDeviceLocationIfMissing,
          )
        : null;

    final prepared = <File>[];
    for (final file in attachments) {
      if (FileSecurityUtils.isVideoPath(file.path)) {
        FileSecurityUtils.validateVideoFile(file);
        prepared.add(file);
      } else {
        FileSecurityUtils.validateImageFile(file);
        prepared.add(
          await compressToWebp(
            file,
            includeGeoStamp: includeGeoStamp,
            stampTimestamp: resolvedGeo?.timestamp,
            stampLatitude: resolvedGeo?.latitude,
            stampLongitude: resolvedGeo?.longitude,
            stampAddress: resolvedGeo?.address,
            resolveDeviceLocationIfMissing: false,
          ),
        );
      }
    }
    return prepared;
  }

  /// Mengompres gambar input (JPEG, PNG, HEIC, WEBP, dll.) menjadi `.webp`,
  /// serta menyematkan watermark logo general di tengah dan geo-stamp di kiri bawah.
  static Future<File> compressToWebp(
    File file, {
    int quality = 80,
    int minWidth = 1080,
    int minHeight = 1080,
    bool watermark = true,
    double watermarkSizeRatio = defaultWatermarkSizeRatio,
    double watermarkOpacity = defaultWatermarkOpacity,
    Uint8List? watermarkBytes,
    bool includeGeoStamp = true,
    DateTime? stampTimestamp,
    double? stampLatitude,
    double? stampLongitude,
    String? stampAddress,
    bool resolveDeviceLocationIfMissing = false,
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

      final _GeoMeta? geo = includeGeoStamp
          ? await _resolveGeoMetadata(
              timestamp: stampTimestamp,
              latitude: stampLatitude,
              longitude: stampLongitude,
              address: stampAddress,
              resolveDeviceLocationIfMissing: resolveDeviceLocationIfMissing,
            )
          : null;

      final watermarkedPng = await _applyWatermark(
        compressedBase,
        logoBytes: logoBytes,
        sizeRatio: watermarkSizeRatio,
        opacity: watermarkOpacity,
        stampTextLines: geo == null ? const [] : _buildStampLines(geo),
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

      final XFile? result = await ImageCompressPlus.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: CompressFormat.webp,
      );

      if (result != null && result.path.isNotEmpty) {
        final compressedFile = File(result.path);
        if (compressedFile.existsSync()) {
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
    required List<({String text, int colorArgb, bool wrap})> stampTextLines,
  }) async {
    try {
      final sourceBytes = await sourceFile.readAsBytes();
      final outputBytes = await Isolate.run(
        () => _compositeWatermarkBytes(
          sourceBytes: sourceBytes,
          logoBytes: logoBytes,
          sizeRatio: sizeRatio,
          opacity: opacity,
          stampTextLines: stampTextLines,
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
    required List<({String text, int colorArgb, bool wrap})> stampTextLines,
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

    if (stampTextLines.isNotEmpty) {
      _drawGeoStamp(base, shorterSide: shorterSide, rawEntries: stampTextLines);
    }

    return Uint8List.fromList(img.encodePng(base, level: 1));
  }

  static void _drawGeoStamp(
    img.Image base, {
    required int shorterSide,
    required List<({String text, int colorArgb, bool wrap})> rawEntries,
  }) {
    final img.BitmapFont font = shorterSide >= 1700
        ? img.arial48
        : (shorterSide >= 450 ? img.arial24 : img.arial14);

    final padX = (font.lineHeight * 0.65).round().clamp(6, 30);
    final padY = (font.lineHeight * 0.45).round().clamp(5, 22);
    final margin = (shorterSide * 0.028).round().clamp(6, 40);
    final lineH = (font.lineHeight * 1.25).round();
    final radius = (font.lineHeight * 0.36).round().clamp(4, 16);

    final maxAvailableW = base.width - margin * 2 - padX * 2;
    if (maxAvailableW <= 32) return;
    final preferredW = (base.width * 0.72).round() - padX * 2;
    final maxTextW = math.max(80, math.min(maxAvailableW, preferredW));

    final renderLines = <({String text, int colorArgb})>[];
    for (final entry in rawEntries) {
      if (entry.text.isEmpty) continue;
      if (entry.wrap) {
        for (final wrapped in _wrapTextLines(font, entry.text, maxTextW, 3)) {
          renderLines.add((text: wrapped, colorArgb: entry.colorArgb));
        }
      } else {
        final single = _wrapTextLines(font, entry.text, maxTextW, 1).first;
        renderLines.add((text: single, colorArgb: entry.colorArgb));
      }
    }
    if (renderLines.isEmpty) return;

    final maxBoxH = base.height - margin * 2;
    while (renderLines.length > 1 &&
        padY * 2 + (renderLines.length - 1) * lineH + font.lineHeight >
            maxBoxH) {
      renderLines.removeLast();
    }

    final textBlockH = (renderLines.length - 1) * lineH + font.lineHeight;
    final boxH = padY * 2 + textBlockH;
    if (boxH > maxBoxH) return;

    var maxLineW = 0;
    for (final line in renderLines) {
      maxLineW = math.max(maxLineW, _measureTextWidth(font, line.text));
    }
    final boxW = math.min(base.width - margin * 2, maxLineW + padX * 2);
    final bx = margin;
    final by = math.max(margin, base.height - boxH - margin);

    img.fillRect(
      base,
      x1: bx,
      y1: by,
      x2: bx + boxW,
      y2: by + boxH,
      color: img.ColorRgba8(15, 23, 42, 184),
      radius: radius,
      alphaBlend: true,
    );

    var y = by + padY;
    for (final line in renderLines) {
      final a = (line.colorArgb >> 24) & 0xFF;
      final r = (line.colorArgb >> 16) & 0xFF;
      final g = (line.colorArgb >> 8) & 0xFF;
      final b = line.colorArgb & 0xFF;
      img.drawString(
        base,
        line.text,
        font: font,
        x: bx + padX,
        y: y,
        color: img.ColorRgba8(r, g, b, a),
      );
      y += lineH;
    }
  }

  static int _measureTextWidth(img.BitmapFont font, String text) {
    var width = 0;
    for (final code in text.codeUnits) {
      final glyph = font.characters[code];
      width += glyph != null ? glyph.xAdvance : (font.size ~/ 2);
    }
    return width;
  }

  static List<String> _wrapTextLines(
    img.BitmapFont font,
    String text,
    int maxWidth,
    int maxLines,
  ) {
    final words = text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return const [];

    final lines = <String>[];
    var current = words.first;

    for (var i = 1; i < words.length; i++) {
      final candidate = '$current ${words[i]}';
      if (_measureTextWidth(font, candidate) <= maxWidth) {
        current = candidate;
      } else {
        if (lines.length == maxLines - 1) {
          final rest = [current, ...words.sublist(i)].join(' ');
          lines.add(_truncateToWidth(font, rest, maxWidth));
          return lines;
        }
        lines.add(_truncateToWidth(font, current, maxWidth));
        current = words[i];
      }
    }

    lines.add(_truncateToWidth(font, current, maxWidth));
    return lines;
  }

  static String _truncateToWidth(
    img.BitmapFont font,
    String text,
    int maxWidth,
  ) {
    if (_measureTextWidth(font, text) <= maxWidth) return text;
    var trimmed = text;
    while (trimmed.length > 3 &&
        _measureTextWidth(font, '$trimmed...') > maxWidth) {
      trimmed = trimmed.substring(0, trimmed.length - 1).trimRight();
    }
    return '$trimmed...';
  }

  static List<({String text, int colorArgb, bool wrap})> _buildStampLines(
    _GeoMeta geo,
  ) {
    final lines = <({String text, int colorArgb, bool wrap})>[
      (
        text: _formatTimestamp(geo.timestamp),
        colorArgb: 0xFFFFFFFF,
        wrap: false,
      ),
    ];

    if (_hasValidCoordinates(geo.latitude, geo.longitude)) {
      lines.add((
        text:
            '${geo.latitude!.toStringAsFixed(6)}, ${geo.longitude!.toStringAsFixed(6)}',
        colorArgb: 0xFFCBD5E1,
        wrap: false,
      ));
    }

    if (geo.address.isNotEmpty) {
      lines.add((text: geo.address, colorArgb: 0xFFF1F5F9, wrap: true));
    }

    return lines;
  }

  static Future<_GeoMeta> _resolveGeoMetadata({
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? address,
    required bool resolveDeviceLocationIfMissing,
  }) async {
    final resolvedTime = timestamp ?? DateTime.now();
    var lat = _hasValidCoordinates(latitude, longitude) ? latitude : null;
    var lng = _hasValidCoordinates(latitude, longitude) ? longitude : null;
    var resolvedAddress = _normalizeStampText(address ?? '');

    if (resolveDeviceLocationIfMissing && (lat == null || lng == null)) {
      final pos = await _tryGetAuthorizedPosition();
      if (pos != null && _hasValidCoordinates(pos.latitude, pos.longitude)) {
        lat = pos.latitude;
        lng = pos.longitude;
      }
    }

    if (resolveDeviceLocationIfMissing &&
        resolvedAddress.isEmpty &&
        lat != null &&
        lng != null) {
      resolvedAddress = await _tryReverseGeocode(lat, lng);
    }

    return (
      timestamp: resolvedTime,
      latitude: lat,
      longitude: lng,
      address: resolvedAddress,
    );
  }

  static bool _hasValidCoordinates(double? lat, double? lng) =>
      lat != null &&
      lng != null &&
      lat.isFinite &&
      lng.isFinite &&
      (lat.abs() > 0.0001 || lng.abs() > 0.0001);

  static Future<Position?> _tryGetAuthorizedPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return null;
      }

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 3),
          ),
        );
      } catch (_) {
        return await Geolocator.getLastKnownPosition();
      }
    } catch (_) {
      return null;
    }
  }

  static Future<String> _tryReverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await Geocoding()
          .placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 3));
      if (placemarks.isEmpty) return '';

      final place = placemarks.first;
      final parts = <String>[];
      void addPart(String? raw, {String prefix = ''}) {
        final clean = _normalizeStampText(raw ?? '');
        if (clean.isEmpty) return;
        final formatted = '$prefix$clean';
        if (!parts.contains(formatted)) parts.add(formatted);
      }

      addPart(place.street);
      if (place.subLocality != place.street) {
        addPart(place.subLocality, prefix: 'Kel. ');
      }
      if (place.locality != place.subLocality) {
        addPart(place.locality, prefix: 'Kec. ');
      }
      if ((place.subAdministrativeArea ?? '').trim().isNotEmpty) {
        addPart(place.subAdministrativeArea);
      } else {
        addPart(place.administrativeArea);
      }
      addPart(place.postalCode);
      return parts.join(', ');
    } catch (_) {
      return '';
    }
  }

  static String _formatTimestamp(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = _monthsShortId[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final offsetHours = dt.timeZoneOffset.inHours;
    final tz = switch (offsetHours) {
      7 => 'WIB',
      8 => 'WITA',
      9 => 'WIT',
      _ => _normalizeStampText(dt.timeZoneName),
    };
    return tz.isEmpty
        ? '$day $month $year, $hour:$minute'
        : '$day $month $year, $hour:$minute $tz';
  }

  static String _normalizeStampText(String input) {
    final cleaned = input
        .replaceAll('\u00A0', ' ')
        .replaceAll('—', '-')
        .replaceAll('–', '-')
        .replaceAll('’', "'")
        .replaceAll('‘', "'")
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll(RegExp(r'[^\x20-\x7E]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return cleaned;
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
