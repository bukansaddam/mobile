import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

class GetMyJagaTanahReportsUsecase {
  final JagaTanahRepository _repository;

  const GetMyJagaTanahReportsUsecase(this._repository);

  Future<Either<Failure, ComplaintPaginatedEntity>> call({
    int page = 1,
    int perPage = 20,
    String? status,
    String? category,
  }) {
    return _repository.getMyReports(
      page: page,
      perPage: perPage,
      status: status,
      category: category,
    );
  }
}
