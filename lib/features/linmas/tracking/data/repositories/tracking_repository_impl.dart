import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/linmas/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:akar/features/linmas/tracking/domain/entities/tracking_mapper.dart';
import 'package:akar/features/linmas/tracking/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDatasource remoteDatasource;

  TrackingRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, TrackingEntity>> sendLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final model = await remoteDatasource.sendLocation(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(model.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
