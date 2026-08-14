import '../entities/panic_entity.dart';

abstract class PanicRepository {
  Future<List<NearbyMemberEntity>> getNearbyMembers({
    required double latitude,
    required double longitude,
  });

  Future<PanicAlertResultEntity> sendPanicAlert({
    required double latitude,
    required double longitude,
    String? selectedMemberId,
    String? note,
  });
}
