import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';

class GetMyComplaintsUsecase {
  final ComplaintRepository repository;

  const GetMyComplaintsUsecase(this.repository);

  Future<Either<Failure, ComplaintPaginatedEntity>> call({
    int page = 1,
    int perPage = 15,
  }) {
    return repository.getMyComplaints(page: page, perPage: perPage);
  }
}
