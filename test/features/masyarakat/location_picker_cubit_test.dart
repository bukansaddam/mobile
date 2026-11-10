import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/location_suggestion.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/location_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_address_from_latlng_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_current_location_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_location_suggestions_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/search_coordinates_usecase.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/location_picker_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class _FakeLocationRepository implements LocationRepository {
  @override
  Future<Either<Failure, LatLng>> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Right(LatLng(-6.2, 106.8));
  }

  @override
  Future<Either<Failure, String>> getAddressFromLatLng(LatLng position) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Right('Jl. Jend. Sudirman');
  }

  @override
  Future<Either<Failure, List<LocationSuggestion>>> getLocationSuggestions(
    String query,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Right([]);
  }

  @override
  Future<Either<Failure, LatLng>> searchCoordinatesFromAddress(
    String query,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Right(LatLng(-6.2, 106.8));
  }
}

void main() {
  test(
    'LocationPickerCubit does not throw StateError if closed while locating user',
    () async {
      final repo = _FakeLocationRepository();
      final cubit = LocationPickerCubit(
        getLocationSuggestionsUseCase: GetLocationSuggestionsUseCase(repo),
        getAddressFromLatLngUseCase: GetAddressFromLatLngUseCase(repo),
        searchCoordinatesUseCase: SearchCoordinatesUseCase(repo),
        getCurrentLocationUseCase: GetCurrentLocationUseCase(repo),
      );

      cubit.determineUserPosition();
      await cubit.close();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.isClosed, isTrue);
    },
  );
}
