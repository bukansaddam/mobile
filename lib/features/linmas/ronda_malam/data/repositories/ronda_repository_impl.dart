import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/ronda_laporan_mapper.dart';
import '../../domain/repositories/ronda_repository.dart';
import '../datasources/ronda_remote_datasource.dart';

class RondaRepositoryImpl implements RondaRepository {
  final RondaRemoteDatasource remoteDatasource;

  RondaRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, RondaLaporanEntity>> submitLaporan(
    RondaLaporanEntity data,
  ) async {
    try {
      final model = data.toModel();
      final resultModel = await remoteDatasource.submitLaporan(model);
      return Right(resultModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
