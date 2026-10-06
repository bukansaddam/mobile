import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/panic_mapper.dart';
import '../../domain/repositories/panic_repository.dart';
import '../datasources/panic_remote_datasource.dart';

class PanicRepositoryImpl implements PanicRepository {
  final PanicRemoteDatasource remoteDatasource;

  PanicRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<NearbyMemberEntity>>> getNearbyMembers({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final list = await remoteDatasource.getNearbyMembers(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(list.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, PanicAlertResultEntity>> sendPanicAlert({
    required double latitude,
    required double longitude,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  }) async {
    try {
      final result = await remoteDatasource.sendPanicAlert(
        latitude: latitude,
        longitude: longitude,
        isEmergency: isEmergency,
        selectedMemberId: selectedMemberId,
        note: note,
      );
      return Right(result.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
