import '../../domain/entities/panic_entity.dart';

class NearbyMemberModel extends NearbyMemberEntity {
  const NearbyMemberModel({
    required super.id,
    required super.name,
    required super.role,
    required super.distanceText,
    required super.latitude,
    required super.longitude,
    required super.phone,
    required super.isOnline,
  });

  factory NearbyMemberModel.fromJson(Map<String, dynamic> json) {
    return NearbyMemberModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      distanceText: json['distance_text'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      phone: json['phone'] ?? '',
      isOnline: json['is_online'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'distance_text': distanceText,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'is_online': isOnline,
    };
  }
}

class PanicAlertResultModel extends PanicAlertResultEntity {
  const PanicAlertResultModel({
    required super.isSuccess,
    required super.alertId,
    required super.timestamp,
    required super.message,
  });

  factory PanicAlertResultModel.fromJson(Map<String, dynamic> json) {
    return PanicAlertResultModel(
      isSuccess: json['is_success'] ?? true,
      alertId: json['alert_id'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      message: json['message'] ?? 'Sinyal darurat berhasil dikirim.',
    );
  }
}
