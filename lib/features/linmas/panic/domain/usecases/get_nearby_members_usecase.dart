import '../entities/panic_entity.dart';
import '../repositories/panic_repository.dart';

class GetNearbyMembersUsecase {
  final PanicRepository repository;

  GetNearbyMembersUsecase(this.repository);

  Future<List<NearbyMemberEntity>> call({
    required double latitude,
    required double longitude,
  }) async {
    return await repository.getNearbyMembers(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
