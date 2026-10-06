import 'package:akar/core/errors/failures.dart';
import '../entities/panic_entity.dart';
import '../repositories/panic_repository.dart';

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
