import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

abstract class ComplaintRepository {
  Future<Either<Failure, ComplaintReportEntity>> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  });

  Future<Either<Failure, ComplaintPaginatedEntity>> getMyComplaints({
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure, ComplaintReportEntity>> getComplaintDetail(String id);
}
