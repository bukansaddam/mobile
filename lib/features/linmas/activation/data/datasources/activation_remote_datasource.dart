import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
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

  Future<ActivationSubmissionResponseModel> submitActivationReport({
    required String participantId,
    required File file,
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

    final response = await handleRequest<ActivationRunResponseModel>(
      () => dio.get(ApiConstants.activationRuns, queryParameters: queryParams),
      fromJson: (json) {
        AppLogger.i('[RAW RESPONSE getActivationRuns]: $json');
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
  }

  Future<FormData> _createFormData({
    required File webpFile,
    required String webpName,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) async {
    final map = <String, dynamic>{
      'file': await MultipartFile.fromFile(webpFile.path, filename: webpName),
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

  @override
  Future<ActivationSubmissionResponseModel> submitActivationReport({
    required String participantId,
    required File file,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) async {
    // Compress any image format (HEIC, PNG, JPG, BMP, etc.) to WebP
    final webpFile = await ImageCompressHelper.compressToWebp(file);
    final rawName = webpFile.path.split('/').last;
    final webpName = rawName.endsWith('.webp')
        ? rawName
        : '${rawName.split('.').first}.webp';

    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('🚀 [SUBMISSION REQUEST START]');
    debugPrint('📍 Target Participant/Run ID : $participantId');
    debugPrint('📷 WebP Compressed Path     : ${webpFile.path}');
    debugPrint('📄 WebP File Name           : $webpName');
    debugPrint('📝 Notes                    : ${notes ?? '-'}');
    debugPrint('👤 Receiver NIK             : ${receiverNik ?? '-'}');
    debugPrint('👤 Receiver Name            : ${receiverName ?? '-'}');
    debugPrint('════════════════════════════════════════════════════════════');

    // 1. Primary Endpoint: /api/activations/participants/{id}/submissions
    var response = await handleRequest<ActivationSubmissionResponseModel>(
      () async => dio.post(
        ApiConstants.participantSubmissions(participantId),
        data: await _createFormData(
          webpFile: webpFile,
          webpName: webpName,
          notes: notes,
          receiverNik: receiverNik,
          receiverName: receiverName,
        ),
      ),
      fromJson: (json) {
        debugPrint('📩 [PRIMARY ENDPOINT RAW RESPONSE JSON]: $json');
        AppLogger.i('[RAW RESPONSE submitActivationReport primary]: $json');
        if (json is Map<String, dynamic>) {
          return ActivationSubmissionResponseModel.fromJson(json);
        }
        return const ActivationSubmissionResponseModel();
      },
    );

    // 2. Fallback Endpoint if 404 (e.g. using run ID): /api/activations/runs/{id}/submissions
    if (!response.success && response.statusCode == 404) {
      debugPrint(
        '⚠️ Primary endpoint 404. Attempting Fallback to /api/activations/runs/$participantId/submissions',
      );

      response = await handleRequest<ActivationSubmissionResponseModel>(
        () async => dio.post(
          '/api/activations/runs/$participantId/submissions',
          data: await _createFormData(
            webpFile: webpFile,
            webpName: webpName,
            notes: notes,
            receiverNik: receiverNik,
            receiverName: receiverName,
          ),
        ),
        fromJson: (json) {
          debugPrint('📩 [FALLBACK ENDPOINT RAW RESPONSE JSON]: $json');
          AppLogger.i('[RAW RESPONSE submitActivationReport fallback]: $json');
          if (json is Map<String, dynamic>) {
            return ActivationSubmissionResponseModel.fromJson(json);
          }
          return const ActivationSubmissionResponseModel();
        },
      );
    }

    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('🏁 [SUBMISSION REQUEST RESULT]');
    debugPrint('📊 Status Code : ${response.statusCode}');
    debugPrint('Status Success : ${response.success}');
    debugPrint('💬 Message      : ${response.message}');
    debugPrint('📦 Data ID       : ${response.data?.data?.id}');
    debugPrint('════════════════════════════════════════════════════════════');

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Gagal mengunggah laporan penugasan');
    }
  }
}
