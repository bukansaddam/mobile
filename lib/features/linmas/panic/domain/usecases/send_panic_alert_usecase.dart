import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';
import 'package:akar/features/linmas/panic/domain/repositories/panic_repository.dart';

class SendPanicAlertUsecase {
  final PanicRepository repository;

  SendPanicAlertUsecase(this.repository);

  Future<Either<Failure, PanicAlertResultEntity>> call({
    required double latitude,
    required double longitude,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  }) => repository.sendPanicAlert(
    latitude: latitude,
    longitude: longitude,
    isEmergency: isEmergency,
    selectedMemberId: selectedMemberId,
    note: note,
  );
}
