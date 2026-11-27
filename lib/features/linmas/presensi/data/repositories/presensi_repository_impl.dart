import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';

import 'package:akar/features/linmas/presensi/data/mappers/presensi_mapper.dart';
import 'package:akar/features/linmas/presensi/domain/repositories/presensi_repository.dart';
import 'package:akar/features/linmas/presensi/data/datasources/presensi_remote_datasource.dart';

class PresensiRepositoryImpl implements PresensiRepository {
  final PresensiRemoteDatasource remoteDatasource;

  PresensiRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, PresensiDataEntity>> submitPresensi(
    PresensiDataEntity data,
  ) async {
    try {
      final model = data.toModel();
      final resultModel = await remoteDatasource.submitPresensi(model);
      return Right(resultModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
