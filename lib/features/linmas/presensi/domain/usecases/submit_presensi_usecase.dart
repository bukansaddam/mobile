import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/presensi/domain/entities/presensi_entity.dart';
import 'package:akar/features/linmas/presensi/domain/repositories/presensi_repository.dart';

class SubmitPresensiUsecase {
  final PresensiRepository repository;

  SubmitPresensiUsecase(this.repository);

  Future<Either<Failure, PresensiDataEntity>> call(
    PresensiDataEntity data,
  ) async {
    return await repository.submitPresensi(data);
  }
}
