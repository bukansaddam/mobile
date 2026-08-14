import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/ronda_laporan_entity.dart';
import '../../domain/repositories/ronda_repository.dart';
import '../datasources/ronda_remote_datasource.dart';
import '../models/ronda_laporan_model.dart';

class RondaRepositoryImpl implements RondaRepository {
  final RondaRemoteDatasource remoteDatasource;

  RondaRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, RondaLaporanEntity>> submitLaporan(
    RondaLaporanEntity data,
  ) async {
    try {
      final model = RondaLaporanModel.fromEntity(data);
      final resultModel = await remoteDatasource.submitLaporan(model);
      return Right(resultModel);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
