import 'package:akar/core/errors/failures.dart';
import '../entities/bank_sampah_report_entity.dart';
import '../repositories/bank_sampah_repository.dart';

class GetBankSampahReportsUsecase {
  final BankSampahRepository repository;

  GetBankSampahReportsUsecase(this.repository);

  Future<Either<Failure, List<BankSampahReportEntity>>> call() {
    return repository.getReports();
  }
}
