import '../entities/panic_entity.dart';
import '../repositories/panic_repository.dart';

class SendPanicAlertUsecase {
  final PanicRepository repository;

  SendPanicAlertUsecase(this.repository);

  Future<PanicAlertResultEntity> call({
    required double latitude,
    required double longitude,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  }) async {
    return await repository.sendPanicAlert(
      latitude: latitude,
      longitude: longitude,
      isEmergency: isEmergency,
      selectedMemberId: selectedMemberId,
      note: note,
    );
  }
}
