import 'package:akar/core/errors/failures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, LatLng>> call() {
    return repository.getCurrentLocation();
  }
}
