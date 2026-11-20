import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/features/linmas/jaga_tanah/data/datasources/jaga_tanah_remote_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_mapper.dart';
import 'package:akar/utils/app_logger.dart';

class JagaTanahRepositoryImpl implements JagaTanahRepository {
  final JagaTanahRemoteDatasource remoteDatasource;

  JagaTanahRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ComplaintPaginatedEntity>> getMyReports({
    int page = 1,
    int perPage = 20,
    String? status,
    String? category,
  }) async {
    try {
      final model = await remoteDatasource.getMyReports(
        page: page,
        perPage: perPage,
        status: status,
        category: category,
      );
      return Right(model.toDomain());
    } catch (e, s) {
      AppLogger.e('[JAGA_TANAH_REPO] Error getMyReports', e, s);
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<JagaTanahCategoryEntity>>> getCategories() async {
    try {
      final items = await remoteDatasource.getCategories();
      return Right(items);
    } catch (e, s) {
      AppLogger.e('[JAGA_TANAH_REPO] Error getCategories', e, s);
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ComplaintReportEntity>> createReport({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    required int categoryId,
    int? subCategoryId,
    String type = 'point',
    String? locationAccess,
    String? fieldCondition,
    String? dominantLandCover,
    String? visibleUsage,
    String? usageLevel,
    String? maintenanceStatus,
    String? conditionInfoSource,
    String? tenureInfoSource,
    String? possessionMarkers,
    String? conflictInfo,
    String? idempotencyKey,
  }) async {
    try {
      final model = await remoteDatasource.createReport(
        title: title,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        attachments: attachments,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        type: type,
        locationAccess: locationAccess,
        fieldCondition: fieldCondition,
        dominantLandCover: dominantLandCover,
        visibleUsage: visibleUsage,
        usageLevel: usageLevel,
        maintenanceStatus: maintenanceStatus,
        conditionInfoSource: conditionInfoSource,
        tenureInfoSource: tenureInfoSource,
        possessionMarkers: possessionMarkers,
        conflictInfo: conflictInfo,
        idempotencyKey: idempotencyKey,
      );
      return Right(model.toDomain());
    } on FileSecurityException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e, s) {
      AppLogger.e('[JAGA_TANAH_REPO] Error createReport', e, s);
      return Left(ErrorUtils.toFailure(e));
    }
  }
}
