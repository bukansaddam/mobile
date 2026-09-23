import 'dart:io';
import 'package:intl/intl.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/bank_sampah_location_mapper.dart';
import '../../domain/entities/bank_sampah_report_entity.dart';
import '../../domain/entities/bank_sampah_report_mapper.dart';
import '../../domain/repositories/bank_sampah_repository.dart';
import '../datasources/bank_sampah_remote_datasource.dart';

class BankSampahRepositoryImpl implements BankSampahRepository {
  final BankSampahRemoteDataSource remoteDataSource;

  BankSampahRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BankSampahReportsDataEntity>> getReports({
    int? page,
    int? perPage,
  }) async {
    try {
      final res = await remoteDataSource.getMyDeposits(
        page: page,
        perPage: perPage,
      );
      return Right(res.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, BankSampahReportEntity>> addReport(
    BankSampahReportEntity report,
  ) async {
    final bankIdInt = int.tryParse(report.bankSampahId);
    if (bankIdInt != null && bankIdInt > 0) {
      try {
        final reportDateStr = DateFormat('yyyy-MM-dd').format(report.createdAt);
        final file = (report.fotoPath != null && report.fotoPath!.isNotEmpty)
            ? File(report.fotoPath!)
            : null;
        final remoteModel = await remoteDataSource.addDeposit(
          bankId: bankIdInt,
          wasteType: report.jenisSampah,
          weightKg: report.beratKg,
          reportDate: reportDateStr,
          notes: report.catatan.isNotEmpty ? report.catatan : null,
          photo: file,
        );
        return Right(remoteModel.toDomain());
      } catch (e) {
        return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
      }
    }

    return const Left(
      ServerFailure(
        'Lokasi Bank Sampah tidak valid atau belum dipilih dari server. Silakan pilih kembali unit Bank Sampah.',
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteReport(String id) async {
    return const Left(
      ServerFailure('Fitur hapus laporan belum didukung di server.'),
    );
  }

  @override
  Future<Either<Failure, List<BankSampahLocationEntity>>> getLocations() async {
    try {
      final remoteList = await remoteDataSource.getBankSampahMap();
      return Right(remoteList.map((m) => m.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, BankSampahLocationEntity>> addLocation(
    BankSampahLocationEntity location,
  ) async {
    return const Left(
      ServerFailure('Penambahan bank sampah dilakukan oleh administrator.'),
    );
  }
}
