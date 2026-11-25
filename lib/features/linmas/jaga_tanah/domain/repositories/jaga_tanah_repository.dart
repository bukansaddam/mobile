import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

abstract class JagaTanahRepository {
  Future<Either<Failure, ComplaintPaginatedEntity>> getMyReports({
    int page = 1,
    int perPage = 20,
    String? status,
    String? category,
  });

  Future<Either<Failure, JagaTanahDetailEntity>> getReportDetail(String id);

  Future<Either<Failure, List<JagaTanahCategoryEntity>>> getCategories();

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getProvinces({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getRegencies(
    String provinceId, {
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getDistricts(
    String regencyId, {
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getVillages(
    String districtId, {
    bool forceRefresh = false,
  });

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
    Map<String, dynamic>? boundaryGeojson,
    String? estimatedArea,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  });
}
