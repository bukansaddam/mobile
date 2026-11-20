import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_reverse_geocoder.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('JagaTanahReverseGeocoder', () {
    test('parses Nominatim payload for DKI Jakarta accurately', () {
      final parsed = JagaTanahReverseGeocoder.parseNominatimResponse({
        'address': {
          'road': 'Jalan Tebet Barat Raya',
          'city_block': 'RW 08',
          'village': 'Tebet Barat',
          'suburb': 'Tebet',
          'city_district': 'Jakarta Selatan',
          'city': 'Daerah Khusus Ibukota Jakarta',
          'ISO3166-2-lvl4': 'ID-JK',
        },
      });

      expect(parsed.province, equals('Daerah Khusus Ibukota Jakarta'));
      expect(parsed.regency, equals('Jakarta Selatan'));
      expect(parsed.district, equals('Tebet'));
      expect(parsed.village, equals('Tebet Barat'));
      expect(
        parsed.landmarkAddress,
        equals('Jalan Tebet Barat Raya, Tebet Barat'),
      );
    });

    test('parses Nominatim payload for Kabupaten and Desa', () {
      final parsed = JagaTanahReverseGeocoder.parseNominatimResponse({
        'address': {
          'road': 'Gang Mawar V',
          'town': 'Ngoro',
          'village': 'Sukomulyo',
          'county': 'Mojokerto',
          'state': 'Jawa Timur',
          'ISO3166-2-lvl4': 'ID-JI',
        },
      });

      expect(parsed.province, equals('Jawa Timur'));
      expect(parsed.regency, equals('Mojokerto'));
      expect(parsed.district, equals('Ngoro'));
      expect(parsed.village, equals('Sukomulyo'));
      expect(parsed.landmarkAddress, equals('Gang Mawar V, Sukomulyo'));
    });

    test('parses Nominatim payload for non-DKI Kota', () {
      final parsed = JagaTanahReverseGeocoder.parseNominatimResponse({
        'address': {
          'suburb': 'Kebon Pisang',
          'district': 'Sumur Bandung',
          'city': 'Kota Bandung',
          'state': 'Jawa Barat',
        },
      });

      expect(parsed.province, equals('Jawa Barat'));
      expect(parsed.regency, equals('Kota Bandung'));
      expect(parsed.district, equals('Sumur Bandung'));
      expect(parsed.village, equals('Kebon Pisang'));
    });

    test('normalizes iOS Placemark when subAdministrativeArea is empty', () {
      final parsed = JagaTanahReverseGeocoder.parsePlacemark(
        const Placemark(
          administrativeArea: 'Jakarta',
          subAdministrativeArea: '',
          locality: 'South Jakarta',
          subLocality: 'Tebet',
          street: 'Jalan Keselamatan II No. 8',
        ),
      );

      expect(parsed.province, equals('Jakarta'));
      expect(parsed.regency, equals('South Jakarta'));
      expect(parsed.district, equals('Tebet'));
      expect(parsed.village, equals('Tebet'));
      expect(
        parsed.landmarkAddress,
        equals('Jalan Keselamatan II No. 8, Tebet'),
      );
    });

    test('falls back to Placemark when Nominatim request fails', () async {
      final failingDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
              ),
            ),
          ),
        );

      final result = await JagaTanahReverseGeocoder.resolve(
        const LatLng(-7.56, 112.61),
        dio: failingDio,
        placemarkResolver: (_) async => const [
          Placemark(
            administrativeArea: 'Jawa Timur',
            subAdministrativeArea: 'Kab. Mojokerto',
            locality: 'Ngoro',
            subLocality: 'Sukomulyo',
            street: 'Jl. Raya Sukomulyo',
          ),
        ],
      );

      expect(result.province, equals('Jawa Timur'));
      expect(result.regency, equals('Kab. Mojokerto'));
      expect(result.district, equals('Ngoro'));
      expect(result.village, equals('Sukomulyo'));
      expect(result.landmarkAddress, equals('Jl. Raya Sukomulyo, Sukomulyo'));
    });
  });
}
