import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/repositories/bank_sampah_repository.dart';

class AddBankSampahReportUsecase {
  final BankSampahRepository repository;

  AddBankSampahReportUsecase(this.repository);

  Future<Either<Failure, BankSampahReportEntity>> call(
    BankSampahReportEntity report, {
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) {
    return repository.addReport(
      report,
      idempotencyKey: idempotencyKey,
      skipMediaPreparation: skipMediaPreparation,
    );
  }
}
