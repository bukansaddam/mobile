import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/tracking/domain/entities/tracking_entity.dart';

abstract class TrackingRepository {
  Future<Either<Failure, TrackingEntity>> sendLocation({
    required double latitude,
    required double longitude,
  });
}
