import '../../../../core/errors/failures.dart';
import '../entities/presensi_entity.dart';
import '../repositories/presensi_repository.dart';

class SubmitPresensiUsecase {
  final PresensiRepository repository;

  SubmitPresensiUsecase(this.repository);

  Future<Either<Failure, PresensiDataEntity>> call(
    PresensiDataEntity data,
  ) async {
    return await repository.submitPresensi(data);
  }
}
