import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/features/masyarakat/complaint/data/datasources/complaint_remote_datasource.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_mapper.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDatasource remoteDatasource;

  ComplaintRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ComplaintReportEntity>> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  }) async {
    try {
      final model = await remoteDatasource.createComplaint(
        title: title,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        attachments: attachments,
      );
      return Right(model.toDomain());
    } on FileSecurityException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
