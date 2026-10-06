import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/utils/app_logger.dart';
import '../models/panic_model.dart';

abstract class PanicRemoteDatasource {
  Future<List<NearbyMemberModel>> getNearbyMembers({
    required double latitude,
    required double longitude,
  });

  Future<PanicAlertResultModel> sendPanicAlert({
    required double latitude,
    required double longitude,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  });
}

class PanicRemoteDatasourceImpl extends BaseRemoteDataSource
    implements PanicRemoteDatasource {
  @override
  Future<List<NearbyMemberModel>> getNearbyMembers({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await handleRequest<List<NearbyMemberModel>>(
        () => dio.get(
          ApiConstants.villageMembersNearby,
          queryParameters: {
            'latitude': latitude,
            'longitude': longitude,
            'lat': latitude,
            'lng': longitude,
          },
        ),
        fromJson: (json) {
          List<dynamic> items = [];
          if (json is List) {
            items = json;
          } else if (json is Map && json['data'] is List) {
            items = json['data'] as List;
          }

          return items
              .whereType<Map>()
              .map(
                (item) =>
                    NearbyMemberModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        },
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(
          response.message ?? 'Gagal memuat petugas terdekat dari server',
        );
      }
    } on DioException catch (e) {
      AppLogger.e('[PANIC_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[PANIC_DS] Unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<PanicAlertResultModel> sendPanicAlert({
    required double latitude,
    required double longitude,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  }) async {
    final Map<String, dynamic> requestData = {
      'is_emergency': isEmergency,
      'status': isEmergency ? 'emergency' : 'normal',
      'latitude': latitude,
      'longitude': longitude,
      if (note != null && note.isNotEmpty) 'note': note,
      if (selectedMemberId != null && selectedMemberId.isNotEmpty)
        'selected_member_id': selectedMemberId,
    };

    try {
      final response = await handleRequest<PanicAlertResultModel>(
        () => dio.patch(ApiConstants.emergencyStatus, data: requestData),
        fromJson: (json) {
          if (json is Map<String, dynamic>) {
            return PanicAlertResultModel.fromJson(json);
          } else if (json is Map) {
            return PanicAlertResultModel.fromJson(
              Map<String, dynamic>.from(json),
            );
          }
          throw Exception('Format respons status darurat tidak valid');
        },
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Gagal memperbarui status darurat');
      }
    } on DioException catch (e) {
      AppLogger.e('[PANIC_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[PANIC_DS] Unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }
}
