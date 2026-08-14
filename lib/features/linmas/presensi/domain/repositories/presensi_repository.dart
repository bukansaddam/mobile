import 'package:akar/core/errors/failures.dart';
import '../entities/presensi_entity.dart';

abstract class PresensiRepository {
  Future<Either<Failure, PresensiDataEntity>> submitPresensi(
    PresensiDataEntity data,
  );
}
