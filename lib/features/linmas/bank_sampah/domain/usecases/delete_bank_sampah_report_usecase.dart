import 'package:akar/core/errors/failures.dart';
import '../repositories/bank_sampah_repository.dart';

class DeleteBankSampahReportUsecase {
  final BankSampahRepository repository;

  DeleteBankSampahReportUsecase(this.repository);

  Future<Either<Failure, bool>> call(String id) {
    return repository.deleteReport(id);
  }
}
