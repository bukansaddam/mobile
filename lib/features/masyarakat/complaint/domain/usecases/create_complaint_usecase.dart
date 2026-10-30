import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';

class CreateComplaintUsecase {
  final ComplaintRepository repository;

  CreateComplaintUsecase(this.repository);

  Future<Either<Failure, ComplaintReportEntity>> call({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  }) {
    return repository.createComplaint(
      title: title,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      attachments: attachments,
    );
  }
}
