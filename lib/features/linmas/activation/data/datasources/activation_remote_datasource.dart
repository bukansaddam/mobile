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
    try {
      // Security Check: Validasi tipe format dan ukuran maksimal berkas
      FileSecurityUtils.validateImageFile(file);

      final webpFile = await ImageCompressHelper.compressToWebp(file);
      final rawName = webpFile.path.split('/').last;
      final webpName = rawName.endsWith('.webp')
          ? rawName
          : '${rawName.split('.').first}.webp';

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
          if (json is Map<String, dynamic>) {
            return ActivationSubmissionResponseModel.fromJson(json);
          }
          return const ActivationSubmissionResponseModel();
        },
      );

      if (!response.success && response.statusCode == 404) {
        AppLogger.w(
          '[ACTIVATION_DS] Primary endpoint returned 404, falling back to run submissions',
        );
        response = await handleRequest<ActivationSubmissionResponseModel>(
          () async => dio.post(
            ApiConstants.runSubmissions(participantId),
            data: await _createFormData(
              webpFile: webpFile,
              webpName: webpName,
              notes: notes,
              receiverNik: receiverNik,
              receiverName: receiverName,
            ),
          ),
          fromJson: (json) {
            if (json is Map<String, dynamic>) {
              return ActivationSubmissionResponseModel.fromJson(json);
            }
            return const ActivationSubmissionResponseModel();
          },
        );
      }

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
