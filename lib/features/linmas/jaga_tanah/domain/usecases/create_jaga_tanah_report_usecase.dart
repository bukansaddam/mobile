import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

class CreateJagaTanahReportUsecase {
  final JagaTanahRepository _repository;

  const CreateJagaTanahReportUsecase(this._repository);

  Future<Either<Failure, ComplaintReportEntity>> call({
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
  }) {
    return _repository.createReport(
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
  }
}
