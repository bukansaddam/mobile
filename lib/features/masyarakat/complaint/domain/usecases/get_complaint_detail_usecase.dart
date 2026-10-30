import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';

class GetComplaintDetailUsecase {
  final ComplaintRepository repository;

  const GetComplaintDetailUsecase(this.repository);

  Future<Either<Failure, ComplaintReportEntity>> call(String id) {
    return repository.getComplaintDetail(id);
  }
}
