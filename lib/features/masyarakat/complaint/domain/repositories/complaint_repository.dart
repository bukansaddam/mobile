import 'dart:io';

import 'package:akar/core/errors/failures.dart';

import '../entities/complaint_report_entity.dart';

abstract class ComplaintRepository {
  Future<Either<Failure, ComplaintReportEntity>> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  });
}
