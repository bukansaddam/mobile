import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_polygon_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('JagaTanahPolygonUtils', () {
    test('mengembalikan 0 jika titik kurang dari 3', () {
      expect(JagaTanahPolygonUtils.calculateAreaSquareMeters(const []), 0);
      expect(
        JagaTanahPolygonUtils.calculateAreaSquareMeters(const [
          LatLng(-7.56, 112.63),
          LatLng(-7.56, 112.631),
        ]),
        0,
      );
    });

    test('menghitung luas bidang persegi sekitar 100m x 100m', () {
      // 0.0008983 derajat lintang ≈ 100 meter; sesuaikan bujur dengan cos(-7.56°)
      const lat0 = -7.560000;
      const lng0 = 112.630000;
      const dLat = 0.000898315;
      const dLng = 0.000906196;
      const square = [
        LatLng(lat0, lng0),
        LatLng(lat0, lng0 + dLng),
        LatLng(lat0 + dLat, lng0 + dLng),
        LatLng(lat0 + dLat, lng0),
      ];

      final area = JagaTanahPolygonUtils.calculateAreaSquareMeters(square);
      expect(area, inInclusiveRange(9800, 10200));
    });

    test('memformat luas m² dan ha dengan pemisah lokal', () {
      expect(JagaTanahPolygonUtils.formatArea(0), '-');
      expect(JagaTanahPolygonUtils.formatArea(845.4), '± 845 m²');
      expect(JagaTanahPolygonUtils.formatArea(1250), '± 1.250 m²');
      expect(JagaTanahPolygonUtils.formatArea(12500), '± 1,25 ha');
    });

    test('menghitung centroid dan format koordinat 6 desimal', () {
      expect(JagaTanahPolygonUtils.centroidOf(const []), isNull);
      final center = JagaTanahPolygonUtils.centroidOf(const [
        LatLng(-7.0, 112.0),
        LatLng(-7.0, 114.0),
        LatLng(-9.0, 114.0),
        LatLng(-9.0, 112.0),
      ]);
      expect(center, const LatLng(-8.0, 113.0));
      expect(
        JagaTanahPolygonUtils.formatCoordinate(const LatLng(-7.5612, 112.634)),
        '-7.561200, 112.634000',
      );
    });

    test('menghitung LatLngBounds dan mengembalikan null bila degenerat', () {
      expect(JagaTanahPolygonUtils.boundsOf(const []), isNull);
      expect(
        JagaTanahPolygonUtils.boundsOf(const [
          LatLng(-7.5, 112.6),
          LatLng(-7.5, 112.6),
        ]),
        isNull,
      );
      final bounds = JagaTanahPolygonUtils.boundsOf(const [
        LatLng(-7.56, 112.63),
        LatLng(-7.55, 112.65),
        LatLng(-7.57, 112.62),
      ]);
      expect(bounds, isNotNull);
      expect(bounds!.southwest, const LatLng(-7.57, 112.62));
      expect(bounds.northeast, const LatLng(-7.55, 112.65));
    });

    test('geometryId berubah ketika koordinat titik diubah', () {
      const before = [
        LatLng(-6.2000, 106.8160),
        LatLng(-6.2000, 106.8170),
        LatLng(-6.2010, 106.8170),
      ];
      const after = [
        LatLng(-6.2005, 106.8160),
        LatLng(-6.2000, 106.8170),
        LatLng(-6.2010, 106.8170),
      ];

      expect(
        JagaTanahPolygonUtils.geometryId('preview', before),
        JagaTanahPolygonUtils.geometryId('preview', List<LatLng>.of(before)),
      );
      expect(
        JagaTanahPolygonUtils.geometryId('preview', before),
        isNot(JagaTanahPolygonUtils.geometryId('preview', after)),
      );
    });

    test('toBoundaryGeoJson menghasilkan GeoJSON Polygon [lng, lat] tertutup untuk >= 3 titik', () {
      expect(JagaTanahPolygonUtils.toBoundaryGeoJson(const []), isNull);
      expect(
        JagaTanahPolygonUtils.toBoundaryGeoJson(const [
          LatLng(-6.1719736, 106.8477468),
          LatLng(-6.1719736, 106.8483068),
        ]),
        isNull,
      );

      const points = [
        LatLng(-6.1719736, 106.8477468),
        LatLng(-6.1719736, 106.8483068),
        LatLng(-6.1715336, 106.8483068),
        LatLng(-6.1715336, 106.8477468),
      ];
      expect(JagaTanahPolygonUtils.toBoundaryGeoJson(points), {
        'type': 'Polygon',
        'coordinates': [
          [
            [106.8477468, -6.1719736],
            [106.8483068, -6.1719736],
            [106.8483068, -6.1715336],
            [106.8477468, -6.1715336],
            [106.8477468, -6.1719736],
          ],
        ],
      });

      // Jika sudah tertutup, jangan gandakan titik akhir
      final alreadyClosed = [...points, points.first];
      final closedGeoJson =
          JagaTanahPolygonUtils.toBoundaryGeoJson(alreadyClosed)!;
      final ring = (closedGeoJson['coordinates'] as List).first as List;
      expect(ring, hasLength(5));
    });
  });
}
