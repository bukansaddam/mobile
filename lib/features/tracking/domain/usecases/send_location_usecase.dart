import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/tracking/domain/entities/tracking_entity.dart';
import 'package:akar/features/tracking/domain/repositories/tracking_repository.dart';

class SendLocationUsecase {
  final TrackingRepository repository;

  SendLocationUsecase(this.repository);

  Future<Either<Failure, TrackingEntity>> call({
    required double latitude,
    required double longitude,
  }) async {
    return await repository.sendLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
