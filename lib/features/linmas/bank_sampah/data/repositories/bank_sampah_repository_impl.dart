import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/bank_sampah_location_entity.dart';
import '../../domain/entities/bank_sampah_report_entity.dart';
import '../../domain/repositories/bank_sampah_repository.dart';
import '../datasources/bank_sampah_local_datasource.dart';
import '../models/bank_sampah_location_model.dart';
import '../models/bank_sampah_report_model.dart';

class BankSampahRepositoryImpl implements BankSampahRepository {
  final BankSampahLocalDatasource localDatasource;

  BankSampahRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<BankSampahReportEntity>>> getReports() async {
    try {
      final list = await localDatasource.getReports();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, BankSampahReportEntity>> addReport(
    BankSampahReportEntity report,
  ) async {
    try {
      final model = BankSampahReportModel.fromEntity(report);
      final result = await localDatasource.addReport(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReport(String id) async {
    try {
      final result = await localDatasource.deleteReport(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<BankSampahLocationEntity>>> getLocations() async {
    try {
      final list = await localDatasource.getLocations();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, BankSampahLocationEntity>> addLocation(
    BankSampahLocationEntity location,
  ) async {
    try {
      final model = BankSampahLocationModel.fromEntity(location);
      final result = await localDatasource.addLocation(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
