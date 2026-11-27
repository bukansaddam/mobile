import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';
import 'package:akar/features/linmas/panic/domain/repositories/panic_repository.dart';

class GetNearbyMembersUsecase {
  final PanicRepository repository;

  GetNearbyMembersUsecase(this.repository);

  Future<Either<Failure, List<NearbyMemberEntity>>> call({
    required double latitude,
    required double longitude,
  }) => repository.getNearbyMembers(latitude: latitude, longitude: longitude);
}
