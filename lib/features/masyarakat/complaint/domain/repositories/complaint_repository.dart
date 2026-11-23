import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_category_option.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

abstract class ComplaintRepository {
  Future<Either<Failure, ComplaintReportEntity>> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    String? category,
    int? categoryId,
    bool isInsidentil = false,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  });

  Future<Either<Failure, ComplaintPaginatedEntity>> getMyComplaints({
    int page = 1,
    int perPage = 15,
    bool isInsidentil = false,
    String? status,
    String? category,
  });

  Future<Either<Failure, List<ComplaintCategoryOption>>>
  getIncidentCategories();

  Future<Either<Failure, ComplaintPaginatedEntity>> getPublicComplaints({
    int page = 1,
    int perPage = 15,
    String? status,
    String? category,
    String? query,
  });

  Future<Either<Failure, ComplaintReportEntity>> getComplaintDetail(String id);
}
