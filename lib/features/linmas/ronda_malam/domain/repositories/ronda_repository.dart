import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';

abstract class RondaRepository {
  Future<Either<Failure, RondaLaporanEntity>> submitLaporan(
    RondaLaporanEntity data,
  );
}
