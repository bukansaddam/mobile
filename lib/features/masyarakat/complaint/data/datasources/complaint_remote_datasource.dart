import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

abstract class ComplaintRemoteDatasource {
  Future<ComplaintReportModel> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  });

  Future<ComplaintPaginatedModel> getMyComplaints({
    int page = 1,
    int perPage = 15,
  });

  Future<ComplaintPaginatedModel> getPublicComplaints({
    int page = 1,
    int perPage = 15,
    String? status,
    String? category,
    String? query,
  });

  Future<ComplaintReportDetailModel> getComplaintDetail(String id);
}

class ComplaintRemoteDatasourceImpl extends BaseRemoteDataSource
    implements ComplaintRemoteDatasource {
  static const String _attachmentsField = 'attachments[]';

  static final Options _uploadOptions = Options(
    sendTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(minutes: 3),
  );

  @override
  Future<ComplaintReportModel> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  }) async {
    try {
      final prepared = await _prepareAttachments(attachments);
      final response = await handleRequest<ComplaintReportModel>(
        () async => dio.post(
          ApiConstants.reports,
          data: await _createFormData(
            title: title,
            description: description,
            address: address,
            latitude: latitude,
            longitude: longitude,
            attachments: prepared,
          ),
          options: _uploadOptions,
        ),
        fromJson: (json) => ComplaintReportModel.fromJson(
          json is Map ? Map<String, dynamic>.from(json) : const {},
        ),
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Gagal mengirim pengaduan');
      }
      return response.data ?? const ComplaintReportModel();
    } on DioException catch (e) {
      AppLogger.e(
        '[COMPLAINT_DS] DioException in createComplaint: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[COMPLAINT_DS] Error in createComplaint: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<ComplaintPaginatedModel> getMyComplaints({
    int page = 1,
    int perPage = 15,
  }) => _getPaginated(ApiConstants.reportsMe, page: page, perPage: perPage);

  @override
  Future<ComplaintPaginatedModel> getPublicComplaints({
    int page = 1,
    int perPage = 15,
    String? status,
    String? category,
    String? query,
  }) => _getPaginated(
    ApiConstants.reports,
    page: page,
    perPage: perPage,
    status: status,
    category: category,
    query: query,
  );

  Future<ComplaintPaginatedModel> _getPaginated(
    String path, {
    required int page,
    required int perPage,
    String? status,
    String? category,
    String? query,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'status': ?status,
          'category': ?category,
          'q': ?query,
        },
      );
      final body = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : const <String, dynamic>{};
      return ComplaintPaginatedModel.fromJson(body);
    } on DioException catch (e) {
      AppLogger.e(
        '[COMPLAINT_DS] DioException in $path: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<ComplaintReportDetailModel> getComplaintDetail(String id) async {
    final response = await handleRequest<ComplaintReportDetailModel>(
      () => dio.get(ApiConstants.reportDetail(id)),
      fromJson: (json) => ComplaintReportDetailModel.fromJson(
        json is Map ? Map<String, dynamic>.from(json) : const {},
      ),
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Gagal memuat detail pengaduan');
    }
    return response.data ?? const ComplaintReportDetailModel();
  }

  Future<List<File>> _prepareAttachments(List<File> attachments) async {
    final prepared = <File>[];
    for (final file in attachments) {
      if (FileSecurityUtils.isVideoPath(file.path)) {
        FileSecurityUtils.validateVideoFile(file);
        prepared.add(file);
      } else {
        FileSecurityUtils.validateImageFile(file);
        prepared.add(await ImageCompressHelper.compressToWebp(file));
      }
    }
    return prepared;
  }

  Future<FormData> _createFormData({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  }) async {
    final files = <MultipartFile>[];
    for (final file in attachments) {
      files.add(await _multipartFile(file));
    }

    return FormData.fromMap({
      'title': title,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      _attachmentsField: files,
    });
  }

  Future<MultipartFile> _multipartFile(File file) {
    return MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
      contentType: _mediaTypeOf(file.path),
    );
  }

  DioMediaType _mediaTypeOf(String path) {
    final extension = path.split('.').last.toLowerCase();
    if (FileSecurityUtils.isVideoPath(path)) {
      return DioMediaType(
        'video',
        extension == 'mov' ? 'quicktime' : extension,
      );
    }
    return DioMediaType('image', extension == 'jpg' ? 'jpeg' : extension);
  }
}
