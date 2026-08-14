import 'package:akar/core/errors/failures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/location_suggestion.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_native_datasource.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationNativeDataSource nativeDataSource;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.nativeDataSource,
  });

  @override
  Future<Either<Failure, List<LocationSuggestion>>> getLocationSuggestions(
    String query,
  ) async {
    try {
      final suggestions = await remoteDataSource.fetchSuggestions(query);
      return Right(suggestions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromLatLng(LatLng position) async {
    try {
      final address = await nativeDataSource.getAddressFromLatLng(position);
      return Right(address);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LatLng>> searchCoordinatesFromAddress(
    String query,
  ) async {
    try {
      final coordinates = await nativeDataSource.getCoordinatesFromAddress(
        query,
      );
      return Right(coordinates);
    } catch (e) {
      return Left(Failure('Lokasi tidak ditemukan'));
    }
  }

  @override
  Future<Either<Failure, LatLng>> getCurrentLocation() async {
    try {
      final position = await nativeDataSource.getCurrentPosition();
      return Right(position);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
