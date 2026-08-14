import 'package:akar/core/errors/failures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entities/location_suggestion.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<LocationSuggestion>>> getLocationSuggestions(
    String query,
  );
  Future<Either<Failure, String>> getAddressFromLatLng(LatLng position);
  Future<Either<Failure, LatLng>> searchCoordinatesFromAddress(String query);
  Future<Either<Failure, LatLng>> getCurrentLocation();
}
