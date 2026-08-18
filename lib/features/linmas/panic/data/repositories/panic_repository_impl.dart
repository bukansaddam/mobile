import '../../domain/entities/panic_mapper.dart';
import '../../domain/repositories/panic_repository.dart';
import '../datasources/panic_remote_datasource.dart';

class PanicRepositoryImpl implements PanicRepository {
  final PanicRemoteDatasource remoteDatasource;

  PanicRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<NearbyMemberEntity>> getNearbyMembers({
    required double latitude,
    required double longitude,
  }) async {
    final list = await remoteDatasource.fetchNearbyMembers(latitude, longitude);
    return list.map((e) => e.toDomain()).toList();
  }

  @override
  Future<PanicAlertResultEntity> sendPanicAlert({
    required double latitude,
    required double longitude,
    String? selectedMemberId,
    String? note,
  }) async {
    final result = await remoteDatasource.postPanicAlert(
      lat: latitude,
      lng: longitude,
      selectedMemberId: selectedMemberId,
      note: note,
    );
    return result.toDomain();
  }
}
