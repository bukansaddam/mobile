import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/bank_sampah/domain/repositories/bank_sampah_repository.dart';

class DeleteBankSampahReportUsecase {
  final BankSampahRepository repository;

  DeleteBankSampahReportUsecase(this.repository);

  Future<Either<Failure, bool>> call(String id) {
    return repository.deleteReport(id);
  }
}
