import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/utils/app_logger.dart';
import '../models/panic_model.dart';

abstract class PanicRemoteDatasource {
  Future<List<NearbyMemberModel>> fetchNearbyMembers(double lat, double lng);
  Future<PanicAlertResultModel> postPanicAlert({
    required double lat,
    required double lng,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  });
}

class PanicRemoteDatasourceImpl extends BaseRemoteDataSource
    implements PanicRemoteDatasource {
  @override
  Future<List<NearbyMemberModel>> fetchNearbyMembers(
    double lat,
    double lng,
  ) async {
    final response = await handleRequest<List<NearbyMemberModel>>(
      () => dio.get(
        ApiConstants.villageMembersNearby,
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'lat': lat,
          'lng': lng,
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
            .map((item) =>
                NearbyMemberModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      AppLogger.w(
        'Gagal memuat petugas terdekat dari server: ${response.message}',
      );
      return [];
    }
  }

  @override
  Future<PanicAlertResultModel> postPanicAlert({
    required double lat,
    required double lng,
    bool isEmergency = true,
    String? selectedMemberId,
    String? note,
  }) async {
    final Map<String, dynamic> requestData = {
      'is_emergency': isEmergency,
      'status': isEmergency ? 'emergency' : 'normal',
      'latitude': lat,
      'longitude': lng,
      if (note != null && note.isNotEmpty) 'note': note,
      if (selectedMemberId != null && selectedMemberId.isNotEmpty)
        'selected_member_id': selectedMemberId,
    };

    final response = await handleRequest<PanicAlertResultModel>(
      () => dio.patch(
        ApiConstants.emergencyStatus,
        data: requestData,
      ),
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return PanicAlertResultModel.fromJson(json);
        } else if (json is Map) {
          return PanicAlertResultModel.fromJson(
            Map<String, dynamic>.from(json),
          );
        }
        return PanicAlertResultModel(
          isSuccess: true,
          alertId:
              'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
          timestamp: DateTime.now(),
          message: isEmergency
              ? 'Sinyal darurat berhasil dikirim.'
              : 'Sinyal darurat berhasil dinonaktifkan.',
        );
      },
    );

    if (response.success) {
      return response.data ??
          PanicAlertResultModel(
            isSuccess: true,
            alertId:
                'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
            timestamp: DateTime.now(),
            message: response.message ??
                (isEmergency
                    ? 'Sinyal darurat berhasil dikirim.'
                    : 'Sinyal darurat berhasil dinonaktifkan.'),
          );
    } else {
      throw Exception(response.message ?? 'Gagal memperbarui status darurat');
    }
  }
}
