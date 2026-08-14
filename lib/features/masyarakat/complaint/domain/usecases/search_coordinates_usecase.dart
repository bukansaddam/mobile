import 'package:akar/core/errors/failures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repositories/location_repository.dart';

class SearchCoordinatesUseCase {
  final LocationRepository repository;

  SearchCoordinatesUseCase(this.repository);

  Future<Either<Failure, LatLng>> call(String query) {
    return repository.searchCoordinatesFromAddress(query);
  }
}
