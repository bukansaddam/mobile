import 'dart:io';

import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:akar/features/linmas/activation/data/models/activation_run_model.dart';
import 'package:akar/features/linmas/activation/data/models/activation_submission_model.dart';
import 'package:akar/utils/app_logger.dart';

abstract class ActivationRemoteDatasource {
  Future<ActivationRunResponseModel> getActivationRuns({
    int? page,
    int? perPage,
    String? status,
  });

  Future<List<ActivationSubmissionDataModel>> getActivationSubmissions({
    required String participantId,
  });

  Future<ActivationSubmissionResponseModel> submitActivationReport({
    required String participantId,
    required List<File> attachments,
    String? notes,
    String? receiverNik,
    String? receiverName,
  });
}

class ActivationRemoteDatasourceImpl extends BaseRemoteDataSource
    implements ActivationRemoteDatasource {
  @override
  Future<ActivationRunResponseModel> getActivationRuns({
    int? page,
    int? perPage,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;

    try {
      final response = await handleRequest<ActivationRunResponseModel>(
        () =>
            dio.get(ApiConstants.activationRuns, queryParameters: queryParams),
        fromJson: (json) {
          if (json is Map<String, dynamic>) {
            return ActivationRunResponseModel.fromJson(json);
          }
          if (json is List) {
            return ActivationRunResponseModel(
              success: true,
              data: json
                  .map(
                    (e) => ActivationRunModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList(),
            );
          }
          return const ActivationRunResponseModel();
        },
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Gagal mengambil data penugasan');
      }
    } on DioException catch (e) {
      AppLogger.e(
        '[ACTIVATION_DS] DioException in getActivationRuns: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[ACTIVATION_DS] Error in getActivationRuns: $e', e, s);
      rethrow;
    }
  }

  static const String _attachmentsField = 'files[]';

  Future<FormData> _createFormData({
    required List<File> attachments,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) async {
    final map = <String, dynamic>{
      _attachmentsField: [
        for (final file in attachments)
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: _mediaTypeOf(file.path),
          ),
      ],
    };

    if (notes != null && notes.trim().isNotEmpty) {
      map['notes'] = notes.trim();
    }
    if (receiverNik != null && receiverNik.trim().isNotEmpty) {
      map['receiver_nik'] = receiverNik.trim();
    }
    if (receiverName != null && receiverName.trim().isNotEmpty) {
      map['receiver_name'] = receiverName.trim();
    }

    return FormData.fromMap(map);
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

  // Unggah lampiran jauh lebih lama dari timeout default 30 detik.
  static final Options _uploadOptions = Options(
    sendTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(minutes: 3),
  );

  @override
  Future<List<ActivationSubmissionDataModel>> getActivationSubmissions({
    required String participantId,
  }) async {
    try {
      final response = await handleRequest<List<ActivationSubmissionDataModel>>(
        () => dio.get(ApiConstants.participantSubmissions(participantId)),
        fromJson: _parseSubmissionList,
      );

      if (response.success) {
        return response.data ?? const [];
      }
      throw Exception(response.message ?? 'Gagal mengambil daftar laporan');
    } on DioException catch (e) {
      AppLogger.e(
        '[ACTIVATION_DS] DioException in getActivationSubmissions: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e(
        '[ACTIVATION_DS] Error in getActivationSubmissions: $e',
        e,
        s,
      );
      rethrow;
    }
  }

  List<ActivationSubmissionDataModel> _parseSubmissionList(dynamic json) {
    dynamic payload = json;
    if (json is Map) {
      payload = json['data'] ?? json['items'] ?? json;
    }

    if (payload is List) {
      return payload
          .whereType<Map>()
          .map(
            (item) => ActivationSubmissionDataModel.fromJson(
              _normalizeSubmission(Map<String, dynamic>.from(item)),
            ),
          )
          .toList();
    }
    if (payload is Map) {
      return [
        ActivationSubmissionDataModel.fromJson(
          _normalizeSubmission(Map<String, dynamic>.from(payload)),
        ),
      ];
    }
    return const [];
  }

  // Server mengirim file_url relatif (mis. /api/activations/...); jadikan absolut.
  Map<String, dynamic> _normalizeSubmission(Map<String, dynamic> json) {
    final attachments = json['attachments'];
    if (attachments is! List) return json;

    final baseUri = Uri.tryParse(ApiConstants.baseUrl);
    final normalized = attachments.map<Map<String, dynamic>>((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final fileUrl = map['file_url'];
      if (fileUrl is String && fileUrl.startsWith('/') && baseUri != null) {
        map['file_url'] = baseUri.resolve(fileUrl).toString();
      }
      return map;
    }).toList();

    return {...json, 'attachments': normalized};
  }

  @override
  Future<ActivationSubmissionResponseModel> submitActivationReport({
    required String participantId,
    required List<File> attachments,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) async {
    try {
      final prepared = await _prepareAttachments(attachments);

      final response = await handleRequest<ActivationSubmissionResponseModel>(
        () async => dio.post(
          ApiConstants.participantSubmissions(participantId),
          data: await _createFormData(
            attachments: prepared,
            notes: notes,
            receiverNik: receiverNik,
            receiverName: receiverName,
          ),
          options: _uploadOptions,
        ),
        fromJson: (json) {
          if (json is Map<String, dynamic>) {
            return ActivationSubmissionResponseModel(
              success: true,
              data: ActivationSubmissionDataModel.fromJson(
                _normalizeSubmission(json),
              ),
            );
          }
          return const ActivationSubmissionResponseModel();
        },
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(
          response.message ?? 'Gagal mengunggah laporan penugasan',
        );
      }
    } on DioException catch (e) {
      AppLogger.e(
        '[ACTIVATION_DS] DioException in submitActivationReport: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[ACTIVATION_DS] Error in submitActivationReport: $e', e, s);
      rethrow;
    }
  }
}
