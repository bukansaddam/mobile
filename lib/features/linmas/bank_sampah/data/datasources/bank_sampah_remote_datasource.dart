import 'dart:io';

import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';

import '../models/bank_sampah_location_model.dart';
import '../models/bank_sampah_report_model.dart';

abstract class BankSampahRemoteDataSource {
  Future<BankSampahMyDepositsResponseModel> getMyDeposits({
    int? page,
    int? perPage,
    String? sortBy,
    String? sortDirection,
    int? bankId,
    String? wasteType,
  });

  Future<List<BankSampahLocationModel>> getBankSampahMap();

  Future<BankSampahReportModel> addDeposit({
    required int bankId,
    required String wasteType,
    required double weightKg,
    required String reportDate,
    String? notes,
    File? photo,
  });
}

class BankSampahRemoteDataSourceImpl extends BaseRemoteDataSource
    implements BankSampahRemoteDataSource {
  @override
  Future<BankSampahMyDepositsResponseModel> getMyDeposits({
    int? page,
    int? perPage,
    String? sortBy,
    String? sortDirection,
    int? bankId,
    String? wasteType,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;
    if (sortBy != null && sortBy.trim().isNotEmpty) {
      queryParams['sort_by'] = sortBy.trim();
    }
    if (sortDirection != null && sortDirection.trim().isNotEmpty) {
      queryParams['sort_direction'] = sortDirection.trim();
    }
    if (bankId != null) {
      queryParams['bank_id'] = bankId;
    }
    if (wasteType != null && wasteType.trim().isNotEmpty) {
      queryParams['waste_type'] = wasteType.trim();
    }

    final response = await dio.get(
      ApiConstants.bankSampahMyDeposits,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      return BankSampahMyDepositsResponseModel.fromJson(rawData);
    } else if (rawData is Map) {
      return BankSampahMyDepositsResponseModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );
    }
    throw Exception('Format response bank sampah tidak sesuai');
  }

  @override
  Future<List<BankSampahLocationModel>> getBankSampahMap() async {
    final response = await dio.get(ApiConstants.bankSampahMap);
    final rawData = response.data;
    List<dynamic>? list;
    if (rawData is Map) {
      if (rawData['points'] is List) {
        list = rawData['points'] as List<dynamic>;
      } else if (rawData['data'] is List) {
        list = rawData['data'] as List<dynamic>;
      } else if (rawData['rows'] is List) {
        list = rawData['rows'] as List<dynamic>;
      }
    } else if (rawData is List) {
      list = rawData;
    }
    if (list != null) {
      return list
          .map(
            (item) => BankSampahLocationModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    }
    return [];
  }

  @override
  Future<BankSampahReportModel> addDeposit({
    required int bankId,
    required String wasteType,
    required double weightKg,
    required String reportDate,
    String? notes,
    File? photo,
  }) async {
    final map = <String, dynamic>{
      'bank_id': bankId,
      'waste_type': wasteType,
      'weight_kg': weightKg,
      'report_date': reportDate,
    };
    if (notes != null && notes.trim().isNotEmpty) {
      map['notes'] = notes.trim();
    }
    if (photo != null) {
      FileSecurityUtils.validateImageFile(photo);
      final compressedPhoto = await ImageCompressHelper.compressToWebp(photo);
      final fileName = compressedPhoto.path.split('/').last;
      map['photo'] = await MultipartFile.fromFile(
        compressedPhoto.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap(map);
    final response = await dio.post(
      ApiConstants.bankSampahDeposits,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final rawData = response.data;
    if (rawData is Map && rawData['data'] is Map) {
      return BankSampahReportModel.fromJson(
        Map<String, dynamic>.from(rawData['data'] as Map),
      );
    }
    throw Exception(
      (rawData is Map ? rawData['message'] : null) ??
          'Gagal menambahkan setoran sampah',
    );
  }
}
