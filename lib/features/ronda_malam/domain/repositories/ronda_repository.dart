import '../../../../core/errors/failures.dart';
import '../entities/ronda_laporan_entity.dart';

abstract class RondaRepository {
  Future<Either<Failure, RondaLaporanEntity>> submitLaporan(
    RondaLaporanEntity data,
  );
}
