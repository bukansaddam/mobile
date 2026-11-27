import 'package:akar/features/linmas/tracking/data/models/tracking_response_model.dart';
import 'package:akar/features/linmas/tracking/domain/entities/tracking_entity.dart';

export 'package:akar/features/linmas/tracking/domain/entities/tracking_entity.dart';

extension TrackingResponseModelMapper on TrackingResponseModel {
  TrackingEntity toDomain() {
    return TrackingEntity(success: success, message: message);
  }
}

extension TrackingEntityMapper on TrackingEntity {
  TrackingResponseModel toModel() {
    return TrackingResponseModel(success: success, message: message);
  }
}
