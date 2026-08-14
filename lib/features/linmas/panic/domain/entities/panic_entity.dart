class NearbyMemberEntity {
  final String id;
  final String name;
  final String role;
  final String distanceText;
  final double latitude;
  final double longitude;
  final String phone;
  final bool isOnline;

  const NearbyMemberEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.distanceText,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.isOnline,
  });
}

class PanicAlertResultEntity {
  final bool isSuccess;
  final String alertId;
  final DateTime timestamp;
  final String message;

  const PanicAlertResultEntity({
    required this.isSuccess,
    required this.alertId,
    required this.timestamp,
    required this.message,
  });
}
