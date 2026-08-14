import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/features/linmas/tracking/data/models/tracking_response_model.dart';

abstract class TrackingRemoteDatasource {
  Future<TrackingResponseModel> sendLocation({
    required double latitude,
    required double longitude,
  });
}

class TrackingRemoteDatasourceImpl extends BaseRemoteDataSource
    implements TrackingRemoteDatasource {
  @override
  Future<TrackingResponseModel> sendLocation({
    required double latitude,
    required double longitude,
  }) async {
    final response = await handleRequest<Map<String, dynamic>>(() async {
      return await dio.patch(
        ApiConstants.tracking,
        data: {'latitude': latitude, 'longitude': longitude},
      );
    }, fromJson: (json) => json as Map<String, dynamic>);

    if (response.success && response.data != null) {
      final map = Map<String, dynamic>.from(response.data!);
      return TrackingResponseModel.fromJson(map);
    } else {
      return TrackingResponseModel(
        success: response.success,
        message: response.message ?? 'Pengiriman lokasi selesai',
      );
    }
  }
}
