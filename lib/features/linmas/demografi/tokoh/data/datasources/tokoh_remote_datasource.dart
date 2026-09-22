import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../models/tokoh_model.dart';

abstract class TokohRemoteDatasource {
  Future<TokohResponseModel> getTokohList({
    int? page,
    int? perPage,
    String? label,
    String? field,
    String? name,
  });
  Future<TokohModel> addTokoh(TokohModel model);
  Future<TokohModel> updateTokoh(String id, TokohModel model);
}

class TokohRemoteDatasourceImpl extends BaseRemoteDataSource
    implements TokohRemoteDatasource {
  @override
  Future<TokohResponseModel> getTokohList({
    int? page,
    int? perPage,
    String? label,
    String? field,
    String? name,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;
    if (label != null && label.trim().isNotEmpty) {
      queryParams['label'] = label.trim();
    }
    if (field != null && field.trim().isNotEmpty) {
      queryParams['field'] = field.trim().toLowerCase();
    }
    if (name != null && name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }

    try {
      final res = await dio.get(
        ApiConstants.figures,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final rawData = res.data;
      if (rawData is Map<String, dynamic>) {
        return TokohResponseModel.fromJson(rawData);
      } else if (rawData is Map) {
        return TokohResponseModel.fromJson(Map<String, dynamic>.from(rawData));
      } else if (rawData is List) {
        return TokohResponseModel(
          success: true,
          data: rawData
              .map(
                (e) => TokohModel.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList(),
        );
      }
      return const TokohResponseModel();
    } on DioException catch (e) {
      AppLogger.e('[TOKOH_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[TOKOH_DS] Unexpected error', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<TokohModel> addTokoh(TokohModel model) async {
    final response = await handleRequest<TokohModel>(
      () => dio.post(ApiConstants.figures, data: model.toApiJson()),
      fromJson: (json) {
        if (json is Map) {
          return TokohModel.fromJson(Map<String, dynamic>.from(json));
        }
        return model;
      },
    );

    if (response.success) {
      return response.data ?? model;
    } else {
      throw Exception(response.message ?? 'Gagal menambahkan data tokoh');
    }
  }

  @override
  Future<TokohModel> updateTokoh(String id, TokohModel model) async {
    final response = await handleRequest<TokohModel>(
      () => dio.patch('${ApiConstants.figures}/$id', data: model.toApiJson()),
      fromJson: (json) {
        if (json is Map) {
          return TokohModel.fromJson(Map<String, dynamic>.from(json));
        }
        return model;
      },
    );

    if (response.success) {
      return response.data ?? model;
    } else {
      throw Exception(response.message ?? 'Gagal memperbarui data tokoh');
    }
  }
}
