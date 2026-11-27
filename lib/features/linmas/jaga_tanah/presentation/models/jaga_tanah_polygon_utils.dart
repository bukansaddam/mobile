import 'dart:math';
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Helper geometri ringan untuk menghitung luas dan titik tengah polygon bidang tanah.
class JagaTanahPolygonUtils {
  JagaTanahPolygonUtils._();

  static const double _earthRadiusMeters = 6378137.0;
  static const double _degToRad = pi / 180.0;
  static final Map<String, BitmapDescriptor> _markerIconCache = {};

  /// Style JSON Google Maps polos tanpa ikon/label POI (bisnis, kafe, penginapan) dan transit.
  static const String cleanMapStyle =
      '[{"featureType":"poi","stylers":[{"visibility":"off"}]},'
      '{"featureType":"transit","stylers":[{"visibility":"off"}]}]';

  /// Menghitung perkiraan luas polygon dalam meter persegi (proyeksi lokal + shoelace).
  static double calculateAreaSquareMeters(List<LatLng> points) {
    if (points.length < 3) return 0;

    final avgLatRad =
        (points.fold<double>(0, (sum, p) => sum + p.latitude) / points.length) *
        _degToRad;
    final cosLat = cos(avgLatRad);

    var doubleArea = 0.0;
    for (var i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];
      final x1 = current.longitude * _degToRad * _earthRadiusMeters * cosLat;
      final y1 = current.latitude * _degToRad * _earthRadiusMeters;
      final x2 = next.longitude * _degToRad * _earthRadiusMeters * cosLat;
      final y2 = next.latitude * _degToRad * _earthRadiusMeters;
      doubleArea += (x1 * y2) - (x2 * y1);
    }

    return doubleArea.abs() * 0.5;
  }

  /// Memformat luas menjadi teks ringkas (`m²` di bawah 1 ha, `ha` mulai 10.000 m²).
  static String formatArea(double squareMeters) {
    if (squareMeters <= 0) return '-';
    if (squareMeters >= 10000) {
      final hectares = (squareMeters / 10000)
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      return '± $hectares ha';
    }
    return '± ${_formatThousands(squareMeters.round())} m²';
  }

  /// Mengubah daftar titik bidang tanah menjadi GeoJSON Polygon (RFC 7946: `[lng, lat]`, cincin tertutup).
  /// Mengembalikan `null` apabila titik kurang dari 3.
  static Map<String, dynamic>? toBoundaryGeoJson(List<LatLng> points) {
    if (points.length < 3) return null;
    final ring = points
        .map((point) => <double>[point.longitude, point.latitude])
        .toList();
    if (points.first.longitude != points.last.longitude ||
        points.first.latitude != points.last.latitude) {
      ring.add(<double>[points.first.longitude, points.first.latitude]);
    }
    return <String, dynamic>{
      'type': 'Polygon',
      'coordinates': <List<List<double>>>[ring],
    };
  }

  /// Titik tengah rata-rata dari daftar koordinat polygon.
  static LatLng? centroidOf(List<LatLng> points) {
    if (points.isEmpty) return null;
    var sumLat = 0.0;
    var sumLng = 0.0;
    for (final point in points) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }
    return LatLng(sumLat / points.length, sumLng / points.length);
  }

  /// Memformat koordinat menjadi 6 angka di belakang koma.
  static String formatCoordinate(LatLng point) =>
      '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';

  /// ID berbasis isi koordinat agar overlay native GoogleMap selalu tergambar ulang saat titik berubah.
  static String geometryId(String prefix, List<LatLng> points) {
    final hash = Object.hashAll(
      points.map((p) => Object.hash(p.latitude, p.longitude)),
    );
    return '${prefix}_${points.length}_$hash';
  }

  /// Batas koordinat untuk membingkai seluruh titik polygon di kamera peta.
  static LatLngBounds? boundsOf(List<LatLng> points) {
    if (points.length < 2) return null;
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points.skip(1)) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    if ((maxLat - minLat).abs() < 1e-7 && (maxLng - minLng).abs() < 1e-7) {
      return null;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Membuat ikon marker lingkaran bernomor (`1`, `2`, `3`, ...) dengan cache.
  static Future<BitmapDescriptor> createNumberedMarkerIcon(
    int number, {
    required Color fillColor,
    required Color textColor,
    required Color borderColor,
  }) async {
    final key =
        '$number:${fillColor.toARGB32()}:${textColor.toARGB32()}:${borderColor.toARGB32()}';
    final cached = _markerIconCache[key];
    if (cached != null) return cached;

    const double size = 76;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));
    const center = Offset(size / 2, size / 2);

    canvas.drawCircle(
      center,
      32,
      Paint()
        ..color = borderColor
        ..isAntiAlias = true,
    );
    canvas.drawCircle(
      center,
      26,
      Paint()
        ..color = fillColor
        ..isAntiAlias = true,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          color: textColor,
          fontSize: number >= 10 ? 24 : 28,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (byteData == null) return BitmapDescriptor.defaultMarker;

    final descriptor = BitmapDescriptor.bytes(
      byteData.buffer.asUint8List(),
      width: 28,
      height: 28,
    );
    _markerIconCache[key] = descriptor;
    return descriptor;
  }

  static String _formatThousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      if (i > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
