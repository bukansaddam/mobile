import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';

abstract class PanicRepository {
  Future<Either<Failure, List<NearbyMemberEntity>>> getNearbyMembers({
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, PanicAlertResultEntity>> sendPanicAlert({
    required double latitude,
    required double longitude,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  });
}
