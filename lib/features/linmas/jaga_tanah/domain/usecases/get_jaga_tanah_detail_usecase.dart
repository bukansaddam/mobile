import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';

/// Usecase untuk mengambil detail lengkap laporan Jaga Tanah berdasarkan ID.
class GetJagaTanahDetailUsecase {
  final JagaTanahRepository _repository;

  const GetJagaTanahDetailUsecase(this._repository);

  Future<Either<Failure, JagaTanahDetailEntity>> call(String id) {
    return _repository.getReportDetail(id);
  }
}
