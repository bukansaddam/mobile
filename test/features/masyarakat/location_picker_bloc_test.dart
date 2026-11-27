import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/location_suggestion.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/location_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_address_from_latlng_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_current_location_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_location_suggestions_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/search_coordinates_usecase.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/location_picker_bloc/location_picker_bloc.dart';
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
    'LocationPickerBloc does not throw StateError if closed while locating user',
    () async {
      final repo = _FakeLocationRepository();
      final bloc = LocationPickerBloc(
        getLocationSuggestionsUseCase: GetLocationSuggestionsUseCase(repo),
        getAddressFromLatLngUseCase: GetAddressFromLatLngUseCase(repo),
        searchCoordinatesUseCase: SearchCoordinatesUseCase(repo),
        getCurrentLocationUseCase: GetCurrentLocationUseCase(repo),
      );

      bloc.add(const LocationPickerDetermineUserPosition());
      await bloc.close();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.isClosed, isTrue);
    },
  );

  test(
    'LocationPickerBloc updates position and fetches address on initialize',
    () async {
      final repo = _FakeLocationRepository();
      final bloc = LocationPickerBloc(
        getLocationSuggestionsUseCase: GetLocationSuggestionsUseCase(repo),
        getAddressFromLatLngUseCase: GetAddressFromLatLngUseCase(repo),
        searchCoordinatesUseCase: SearchCoordinatesUseCase(repo),
        getCurrentLocationUseCase: GetCurrentLocationUseCase(repo),
      );

      bloc.add(const LocationPickerInitialized());
      await Future.delayed(const Duration(milliseconds: 180));

      expect(bloc.state.targetPosition, const LatLng(-6.2, 106.8));
      expect(bloc.state.selectedAddress, 'Jl. Jend. Sudirman');
      await bloc.close();
    },
  );
}
