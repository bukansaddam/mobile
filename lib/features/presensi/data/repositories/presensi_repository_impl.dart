import '../../../../core/errors/failures.dart';
import '../../../../core/utils/error_utils.dart';
import '../../domain/entities/presensi_entity.dart';
import '../../domain/repositories/presensi_repository.dart';
import '../datasources/presensi_remote_datasource.dart';
import '../models/presensi_model.dart';

class PresensiRepositoryImpl implements PresensiRepository {
  final PresensiRemoteDatasource remoteDatasource;

  PresensiRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, PresensiDataEntity>> submitPresensi(
    PresensiDataEntity data,
  ) async {
    try {
      final model = PresensiDataModel.fromEntity(data);
      final resultModel = await remoteDatasource.submitPresensi(model);
      return Right(resultModel);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
