import 'package:akar/core/errors/failures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:akar/features/masyarakat/complaint/domain/repositories/location_repository.dart';

class GetAddressFromLatLngUseCase {
  final LocationRepository repository;

  GetAddressFromLatLngUseCase(this.repository);

  Future<Either<Failure, String>> call(LatLng position) {
    return repository.getAddressFromLatLng(position);
  }
}
