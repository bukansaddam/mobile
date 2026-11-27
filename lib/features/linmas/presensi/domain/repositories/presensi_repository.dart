import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/presensi/domain/entities/presensi_entity.dart';

abstract class PresensiRepository {
  Future<Either<Failure, PresensiDataEntity>> submitPresensi(
    PresensiDataEntity data,
  );
}
