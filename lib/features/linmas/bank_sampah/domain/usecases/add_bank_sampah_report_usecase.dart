import 'package:akar/core/errors/failures.dart';
import '../entities/bank_sampah_report_entity.dart';
import '../repositories/bank_sampah_repository.dart';

class AddBankSampahReportUsecase {
  final BankSampahRepository repository;

  AddBankSampahReportUsecase(this.repository);

  Future<Either<Failure, BankSampahReportEntity>> call(
    BankSampahReportEntity report,
  ) {
    return repository.addReport(report);
  }
}
