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
    final userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['member'] is Map<String, dynamic>
            ? json['member'] as Map<String, dynamic>
            : null);

    final id = (json['id'] ??
            json['member_id'] ??
            json['user_id'] ??
            userMap?['id'] ??
            '')
        .toString();

    final name = (json['name'] ??
            json['full_name'] ??
            json['nama'] ??
            json['nama_lengkap'] ??
            userMap?['name'] ??
            userMap?['full_name'] ??
            userMap?['nama'] ??
            'Petugas Linmas')
        .toString();

    final role = (json['role'] ??
            json['jabatan'] ??
            json['position'] ??
            json['role_name'] ??
            userMap?['role'] ??
            'Petugas Respon Cepat')
        .toString();

    final phone = (json['phone'] ??
            json['phone_number'] ??
            json['no_hp'] ??
            json['telepon'] ??
            userMap?['phone'] ??
            userMap?['phone_number'] ??
            '')
        .toString();

    final latRaw = json['latitude'] ??
        json['lat'] ??
        userMap?['latitude'] ??
        userMap?['lat'];
    final lngRaw = json['longitude'] ??
        json['lng'] ??
        json['long'] ??
        userMap?['longitude'] ??
        userMap?['lng'];

    final double lat = latRaw is num
        ? latRaw.toDouble()
        : (double.tryParse(latRaw?.toString() ?? '') ?? 0.0);
    final double lng = lngRaw is num
        ? lngRaw.toDouble()
        : (double.tryParse(lngRaw?.toString() ?? '') ?? 0.0);

    String distText =
        (json['distance_text'] ?? json['distance_str'] ?? '').toString();
    if (distText.isEmpty && json['distance'] != null) {
      final d = json['distance'];
      if (d is num) {
        if (d >= 1000) {
          distText = '${(d / 1000).toStringAsFixed(1)} km dari lokasi Anda';
        } else {
          distText = '${d.round()} m dari lokasi Anda';
        }
      } else {
        distText = d.toString();
      }
    }

    final isOnlineRaw =
        json['is_online'] ?? json['online'] ?? (json['status'] == 'online');
    final bool isOnline = isOnlineRaw is bool ? isOnlineRaw : true;

    return NearbyMemberModel(
      id: id,
      name: name,
      role: role,
      distanceText: distText,
      latitude: lat,
      longitude: lng,
      phone: phone,
      isOnline: isOnline,
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
    final alertId = (json['alert_id'] ??
            json['id'] ??
            json['emergency_id'] ??
            'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}')
        .toString();

    final message = (json['message'] ??
            'Sinyal darurat (SOS) ID $alertId berhasil dikirim! Tim tanggap darurat telah menerima koordinat Anda.')
        .toString();

    final isSuccessRaw = json['is_success'] ?? json['success'] ?? true;
    final bool isSuccess = isSuccessRaw is bool ? isSuccessRaw : true;

    final timestamp = json['timestamp'] != null
        ? (DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now())
        : (json['created_at'] != null
            ? (DateTime.tryParse(json['created_at'].toString()) ??
                DateTime.now())
            : DateTime.now());

    return PanicAlertResultModel(
      isSuccess: isSuccess,
      alertId: alertId,
      timestamp: timestamp,
      message: message,
    );
  }
}
