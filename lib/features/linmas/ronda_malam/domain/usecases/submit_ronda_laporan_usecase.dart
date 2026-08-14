import 'package:akar/core/errors/failures.dart';
import '../entities/ronda_laporan_entity.dart';
import '../repositories/ronda_repository.dart';

class SubmitRondaLaporanUsecase {
  final RondaRepository repository;

  SubmitRondaLaporanUsecase(this.repository);

  Future<Either<Failure, RondaLaporanEntity>> call(
    RondaLaporanEntity data,
  ) async {
    return await repository.submitLaporan(data);
  }
}
