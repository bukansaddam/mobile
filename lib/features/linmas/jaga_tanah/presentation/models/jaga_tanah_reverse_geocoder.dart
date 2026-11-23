import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef JagaTanahAdminAddress = ({
  String? province,
  String? regency,
  String? district,
  String? village,
  String? landmarkAddress,
});

/// Reverse geocoder wilayah administratif Indonesia (Nominatim OSM + fallback Placemark).
class JagaTanahReverseGeocoder {
  JagaTanahReverseGeocoder._();

  static final Dio _isolatedDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 4),
      receiveTimeout: const Duration(seconds: 4),
      headers: const {'User-Agent': 'AkarMobileApp/1.0'},
    ),
  );

  /// Mengambil data Provinsi, Kabupaten/Kota, Kecamatan, Desa/Kelurahan, dan patokan jalan.
  static Future<JagaTanahAdminAddress> resolve(
    LatLng position, {
    Dio? dio,
    Future<List<Placemark>> Function(LatLng)? placemarkResolver,
  }) async {
    final nominatim = await _resolveFromNominatim(position, dio: dio);
    if (nominatim != null &&
        (nominatim.province != null || nominatim.regency != null)) {
      if (nominatim.district != null && nominatim.village != null) {
        return nominatim;
      }
      final fallback = await _resolveFromPlacemark(
        position,
        placemarkResolver: placemarkResolver,
      );
      return (
        province: nominatim.province ?? fallback.province,
        regency: nominatim.regency ?? fallback.regency,
        district: nominatim.district ?? fallback.district,
        village: nominatim.village ?? fallback.village,
        landmarkAddress: nominatim.landmarkAddress ?? fallback.landmarkAddress,
      );
    }

    return _resolveFromPlacemark(
      position,
      placemarkResolver: placemarkResolver,
    );
  }

  static Future<JagaTanahAdminAddress?> _resolveFromNominatim(
    LatLng position, {
    Dio? dio,
  }) async {
    try {
      final client = dio ?? _isolatedDio;
      final response = await client.get<dynamic>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': position.latitude,
          'lon': position.longitude,
          'format': 'jsonv2',
          'addressdetails': 1,
          'accept-language': 'id',
        },
      );
      if (response.statusCode == 200 && response.data is Map) {
        return parseNominatimResponse(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
    } catch (_) {}
    return null;
  }

  /// Mengurai payload JSON Nominatim (`/reverse?format=jsonv2&addressdetails=1`) ke 4 tingkat wilayah Indonesia.
  @visibleForTesting
  static JagaTanahAdminAddress parseNominatimResponse(
    Map<String, dynamic> payload,
  ) {
    final rawAddress = payload['address'];
    final address = rawAddress is Map
        ? Map<String, dynamic>.from(rawAddress)
        : const <String, dynamic>{};

    final state = _clean(address['state']);
    final city = _clean(address['city']);
    final county = _clean(address['county']);
    final regencyField = _clean(address['regency']);
    final stateDistrict = _clean(address['state_district']);
    final cityDistrict = _clean(address['city_district']);
    final districtField = _clean(address['district']);
    final municipality = _clean(address['municipality']);
    final town = _clean(address['town']);
    final suburb = _clean(address['suburb']);
    final villageField = _clean(address['village']);
    final hamlet = _clean(address['hamlet']);
    final quarter = _clean(address['quarter']);
    final neighbourhood = _clean(address['neighbourhood']);
    final isoLevel4 = _clean(address['ISO3166-2-lvl4']);

    final isDkiJakarta =
        state == null &&
        (isoLevel4 == 'ID-JK' ||
            (city != null && city.toLowerCase().contains('jakarta')));

    final province = state ?? (isDkiJakarta ? city : null);
    final regency = state != null
        ? (county ?? city ?? regencyField ?? stateDistrict ?? cityDistrict)
        : (isDkiJakarta
              ? (cityDistrict ?? county ?? stateDistrict)
              : (county ?? city ?? regencyField ?? cityDistrict));

    final district = isDkiJakarta
        ? (districtField ?? municipality ?? suburb ?? town)
        : (districtField ??
              municipality ??
              cityDistrict ??
              town ??
              (villageField != null ? suburb : null));

    final village =
        villageField ??
        hamlet ??
        quarter ??
        neighbourhood ??
        (suburb != null && suburb != district ? suburb : null);

    final road = _clean(address['road']);
    final houseNumber = _clean(address['house_number']);
    final placeName = _clean(payload['name']);
    final streetPart = (road != null && houseNumber != null)
        ? '$road No. $houseNumber'
        : (road ?? placeName);
    final areaHint = village ?? suburb;
    final landmarkParts = <String>[
      ?streetPart,
      if (areaHint != null && areaHint != streetPart) areaHint,
    ];

    return (
      province: province,
      regency: regency,
      district: district,
      village: village,
      landmarkAddress: landmarkParts.isEmpty ? null : landmarkParts.join(', '),
    );
  }

  static Future<JagaTanahAdminAddress> _resolveFromPlacemark(
    LatLng position, {
    Future<List<Placemark>> Function(LatLng)? placemarkResolver,
  }) async {
    try {
      final resolver =
          placemarkResolver ??
          ((LatLng p) =>
              Geocoding().placemarkFromCoordinates(p.latitude, p.longitude));
      final placemarks = await resolver(position)
          .timeout(const Duration(seconds: 4));
      if (placemarks.isEmpty) {
        return _emptyAddress();
      }
      return parsePlacemark(placemarks.first);
    } catch (_) {
      return _emptyAddress();
    }
  }

  /// Mengurai [Placemark] bawaan platform dengan penyesuaian khusus iOS yang sering mengosongkan [subAdministrativeArea].
  @visibleForTesting
  static JagaTanahAdminAddress parsePlacemark(Placemark place) {
    final province = _clean(place.administrativeArea);
    final subAdmin = _clean(place.subAdministrativeArea);
    final locality = _clean(place.locality);
    final subLocality = _clean(place.subLocality);
    final street = _clean(place.street) ?? _clean(place.thoroughfare);

    // Pada iOS (mis. DKI Jakarta), subAdministrativeArea sering kosong dan
    // nama kota masuk ke locality sementara kecamatan/kelurahan ke subLocality.
    final String? regency;
    final String? district;
    final String? village;
    if (subAdmin == null && locality != null && subLocality != null) {
      regency = locality;
      district = subLocality;
      village = subLocality;
    } else {
      regency = subAdmin ?? locality;
      district = locality;
      village = subLocality;
    }

    final landmarkParts = <String>[
      ?street,
      if (subLocality != null && subLocality != street) subLocality,
    ];

    return (
      province: province,
      regency: regency,
      district: district,
      village: village,
      landmarkAddress: landmarkParts.isEmpty ? null : landmarkParts.join(', '),
    );
  }

  static JagaTanahAdminAddress _emptyAddress() => (
    province: null,
    regency: null,
    district: null,
    village: null,
    landmarkAddress: null,
  );

  static String? _clean(dynamic raw) {
    final trimmed = raw?.toString().trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
