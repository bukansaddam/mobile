import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../models/organisasi_model.dart';

abstract class OrganisasiRemoteDatasource {
  Future<OrganisasiResponseModel> getOrganisasiList({
    int? page,
    int? perPage,
    String? field,
    String? name,
  });
  Future<OrganisasiModel> addOrganisasi(OrganisasiModel model);
  Future<OrganisasiModel> updateOrganisasi(String id, OrganisasiModel model);
}

class OrganisasiRemoteDatasourceImpl extends BaseRemoteDataSource
    implements OrganisasiRemoteDatasource {
  @override
  Future<OrganisasiResponseModel> getOrganisasiList({
    int? page,
    int? perPage,
    String? field,
    String? name,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;
    if (field != null && field.trim().isNotEmpty) {
      queryParams['field'] = field.trim().toLowerCase();
    }
    if (name != null && name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }

    try {
      final res = await dio.get(
        ApiConstants.figureOrganizations,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final rawData = res.data;
      if (rawData is Map<String, dynamic>) {
        return OrganisasiResponseModel.fromJson(rawData);
      } else if (rawData is Map) {
        return OrganisasiResponseModel.fromJson(
          Map<String, dynamic>.from(rawData),
        );
      } else if (rawData is List) {
        return OrganisasiResponseModel(
          success: true,
          data: rawData
              .map(
                (e) => OrganisasiModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList(),
        );
      }
      return const OrganisasiResponseModel();
    } on DioException catch (e) {
      AppLogger.e(
        '[ORGANISASI_DS] DioException: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[ORGANISASI_DS] Unexpected error', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<OrganisasiModel> addOrganisasi(OrganisasiModel model) async {
    final response = await handleRequest<OrganisasiModel>(
      () => dio.post(ApiConstants.figureOrganizations, data: model.toApiJson()),
      fromJson: (json) {
        if (json is Map) {
          return OrganisasiModel.fromJson(Map<String, dynamic>.from(json));
        }
        return model;
      },
    );

    if (response.success) {
      return response.data ?? model;
    } else {
      throw Exception(response.message ?? 'Gagal menambahkan organisasi');
    }
  }

  @override
  Future<OrganisasiModel> updateOrganisasi(
    String id,
    OrganisasiModel model,
  ) async {
    final response = await handleRequest<OrganisasiModel>(
      () => dio.patch(
        '${ApiConstants.figureOrganizations}/$id',
        data: model.toApiJson(),
      ),
      fromJson: (json) {
        if (json is Map) {
          return OrganisasiModel.fromJson(Map<String, dynamic>.from(json));
        }
        return model;
      },
    );

    if (response.success) {
      return response.data ?? model;
    } else {
      throw Exception(response.message ?? 'Gagal memperbarui organisasi');
    }
  }
}
