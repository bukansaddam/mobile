import 'package:akar/features/linmas/panic/data/models/panic_model.dart';
import 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';

export 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';

extension NearbyMemberModelMapper on NearbyMemberModel {
  NearbyMemberEntity toDomain() {
    return NearbyMemberEntity(
      id: id,
      name: name,
      role: role,
      distanceText: distanceText,
      latitude: latitude,
      longitude: longitude,
      phone: phone,
      isOnline: isOnline,
    );
  }
}

extension NearbyMemberEntityMapper on NearbyMemberEntity {
  NearbyMemberModel toModel() {
    return NearbyMemberModel(
      id: id,
      name: name,
      role: role,
      distanceText: distanceText,
      latitude: latitude,
      longitude: longitude,
      phone: phone,
      isOnline: isOnline,
    );
  }
}

extension PanicAlertResultModelMapper on PanicAlertResultModel {
  PanicAlertResultEntity toDomain() {
    return PanicAlertResultEntity(
      isSuccess: isSuccess,
      alertId: alertId,
      timestamp: timestamp,
      message: message,
    );
  }
}

extension PanicAlertResultEntityMapper on PanicAlertResultEntity {
  PanicAlertResultModel toModel() {
    return PanicAlertResultModel(
      isSuccess: isSuccess,
      alertId: alertId,
      timestamp: timestamp,
      message: message,
    );
  }
}
