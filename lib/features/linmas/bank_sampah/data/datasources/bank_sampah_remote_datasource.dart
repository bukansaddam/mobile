import 'dart:io';
import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import '../models/bank_sampah_location_model.dart';
import '../models/bank_sampah_report_model.dart';

abstract class BankSampahRemoteDataSource {
  Future<BankSampahMyDepositsResponseModel> getMyDeposits({
    int? page,
    int? perPage,
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
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;

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
      final fileName = photo.path.split('/').last;
      map['photo'] = await MultipartFile.fromFile(
        photo.path,
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
