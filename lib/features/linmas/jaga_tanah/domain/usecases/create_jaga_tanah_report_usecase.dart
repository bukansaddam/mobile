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
    );
  }
}
