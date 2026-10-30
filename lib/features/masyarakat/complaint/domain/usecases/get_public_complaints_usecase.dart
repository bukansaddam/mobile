import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';

class GetPublicComplaintsUsecase {
  final ComplaintRepository repository;

  const GetPublicComplaintsUsecase(this.repository);

  Future<Either<Failure, ComplaintPaginatedEntity>> call({
    int page = 1,
    int perPage = 15,
    String? status,
    String? category,
    String? query,
  }) {
    return repository.getPublicComplaints(
      page: page,
      perPage: perPage,
      status: status,
      category: category,
      query: query,
    );
  }
}
