import 'package:dio/dio.dart';
import '../../domain/entities/location_suggestion.dart';

abstract class LocationRemoteDataSource {
  Future<List<LocationSuggestion>> fetchSuggestions(String query);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LocationSuggestion>> fetchSuggestions(String query) async {
    final response = await dio.get(
      'https://nominatim.openstreetmap.org/search',
      queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': 1,
        'limit': 5,
      },
      options: Options(headers: {'User-Agent': 'DumasApp/1.0'}),
    );

    if (response.statusCode == 200 && response.data is List) {
      final List rawList = response.data as List;
      final List<LocationSuggestion> results = [];

      for (final item in rawList) {
        if (item is Map) {
          final latStr = item['lat'];
          final lonStr = item['lon'];
          final displayName = item['display_name'] ?? '';

          if (latStr != null && lonStr != null) {
            final lat = double.tryParse(latStr.toString());
            final lon = double.tryParse(lonStr.toString());

            if (lat != null && lon != null) {
              results.add(
                LocationSuggestion(
                  displayName: displayName.toString(),
                  latitude: lat,
                  longitude: lon,
                ),
              );
            }
          }
        }
      }
      return results;
    }
    return [];
  }
}
