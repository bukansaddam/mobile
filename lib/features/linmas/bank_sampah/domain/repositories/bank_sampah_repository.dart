import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

abstract class BankSampahRepository {
  Future<Either<Failure, BankSampahReportsDataEntity>> getReports({
    int? page,
    int? perPage,
    String? sortBy,
    String? sortDirection,
    int? bankId,
    String? wasteType,
  });
  Future<Either<Failure, BankSampahReportEntity>> addReport(
    BankSampahReportEntity report, {
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  });
  Future<Either<Failure, bool>> deleteReport(String id);
  Future<Either<Failure, List<BankSampahLocationEntity>>> getLocations();
  Future<Either<Failure, BankSampahLocationEntity>> addLocation(
    BankSampahLocationEntity location,
  );
}
