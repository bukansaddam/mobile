import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';
import 'package:akar/features/linmas/ronda_malam/domain/repositories/ronda_repository.dart';

class SubmitRondaLaporanUsecase {
  final RondaRepository repository;

  SubmitRondaLaporanUsecase(this.repository);

  Future<Either<Failure, RondaLaporanEntity>> call(
    RondaLaporanEntity data,
  ) => repository.submitLaporan(data);
}
