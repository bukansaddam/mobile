import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../models/institusi_model.dart';
import '../models/institusi_category_model.dart';

abstract class InstitusiRemoteDatasource {
  Future<InstitusiResponseModel> getInstitusiList({
    int? page,
    int? perPage,
    String? scope,
    String? name,
    String? label,
  });
  Future<InstitusiModel> addInstitusi(InstitusiModel model);
  Future<InstitusiModel> updateInstitusi(String id, InstitusiModel model);
  Future<List<InstitusiCategoryModel>> getCategories({
    String domain = 'institution',
  });
}

class InstitusiRemoteDatasourceImpl extends BaseRemoteDataSource
    implements InstitusiRemoteDatasource {
  @override
  Future<InstitusiResponseModel> getInstitusiList({
    int? page,
    int? perPage,
    String? scope,
    String? name,
    String? label,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;
    if (scope != null && scope.trim().isNotEmpty) {
      final s = scope.trim().toLowerCase();
      queryParams['scope'] = (s == 'kabupaten/kota' || s == 'kabupaten_kota')
          ? 'kabupaten_kota'
          : s;
    }
    if (name != null && name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }
    if (label != null && label.trim().isNotEmpty) {
      queryParams['label'] = label.trim();
    }

    try {
      final res = await dio.get(
        ApiConstants.figureInstitutions,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final rawData = res.data;
      if (rawData is Map<String, dynamic>) {
        return InstitusiResponseModel.fromJson(rawData);
      } else if (rawData is Map) {
        return InstitusiResponseModel.fromJson(
          Map<String, dynamic>.from(rawData),
        );
      } else if (rawData is List) {
        return InstitusiResponseModel(
          success: true,
          data: rawData
              .map(
                (e) => InstitusiModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList(),
        );
      }
      return const InstitusiResponseModel();
    } on DioException catch (e) {
      AppLogger.e('[INSTITUSI_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[INSTITUSI_DS] Unexpected error', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<InstitusiModel> addInstitusi(InstitusiModel model) async {
    final response = await handleRequest<InstitusiModel>(
      () => dio.post(ApiConstants.figureInstitutions, data: model.toApiJson()),
      fromJson: (json) {
        if (json is Map) {
          return InstitusiModel.fromJson(Map<String, dynamic>.from(json));
        }
        return model;
      },
    );

    if (response.success) {
      return response.data ?? model;
    } else {
      throw Exception(response.message ?? 'Gagal menambahkan institusi');
    }
  }

  @override
  Future<InstitusiModel> updateInstitusi(
    String id,
    InstitusiModel model,
  ) async {
    final response = await handleRequest<InstitusiModel>(
      () => dio.patch(
        '${ApiConstants.figureInstitutions}/$id',
        data: model.toApiJson(),
      ),
      fromJson: (json) {
        if (json is Map) {
          return InstitusiModel.fromJson(Map<String, dynamic>.from(json));
        }
        return model;
      },
    );

    if (response.success) {
      return response.data ?? model;
    } else {
      throw Exception(response.message ?? 'Gagal memperbarui institusi');
    }
  }

  @override
  Future<List<InstitusiCategoryModel>> getCategories({
    String domain = 'institution',
  }) async {
    try {
      final res = await dio.get(
        ApiConstants.categories,
        queryParameters: {'domain': domain},
      );
      final rawData = res.data;
      List list = [];
      if (rawData is Map && rawData['data'] is List) {
        list = rawData['data'] as List;
      } else if (rawData is List) {
        list = rawData;
      }
      return list
          .map(
            (e) => InstitusiCategoryModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .where((c) => c.isActive && c.label.trim().isNotEmpty)
          .toList();
    } catch (e) {
      AppLogger.e('InstitusiRemoteDatasourceImpl.getCategories error: $e');
      rethrow;
    }
  }
}
