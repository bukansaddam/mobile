import 'package:freezed_annotation/freezed_annotation.dart';

part 'panic_model.freezed.dart';
part 'panic_model.g.dart';

Object? _readId(Map json, String key) {
  final userMap = json['user'] is Map
      ? json['user'] as Map
      : (json['member'] is Map ? json['member'] as Map : null);
  return (json['id'] ??
          json['member_id'] ??
          json['user_id'] ??
          userMap?['id'] ??
          '')
      .toString();
}

Object? _readName(Map json, String key) {
  final userMap = json['user'] is Map
      ? json['user'] as Map
      : (json['member'] is Map ? json['member'] as Map : null);
  return (json['name'] ??
          json['full_name'] ??
          json['nama'] ??
          json['nama_lengkap'] ??
          userMap?['name'] ??
          userMap?['full_name'] ??
          userMap?['nama'] ??
          'Petugas Linmas')
      .toString();
}

Object? _readRole(Map json, String key) {
  final userMap = json['user'] is Map
      ? json['user'] as Map
      : (json['member'] is Map ? json['member'] as Map : null);
  return (json['role'] ??
          json['jabatan'] ??
          json['position'] ??
          json['role_name'] ??
          userMap?['role'] ??
          'Petugas Respon Cepat')
      .toString();
}

Object? _readDistanceText(Map json, String key) {
  String distText = (json['distance_text'] ?? json['distance_str'] ?? '')
      .toString();
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
  return distText;
}

Object? _readLatitude(Map json, String key) {
  final userMap = json['user'] is Map
      ? json['user'] as Map
      : (json['member'] is Map ? json['member'] as Map : null);
  final latRaw =
      json['latitude'] ??
      json['lat'] ??
      userMap?['latitude'] ??
      userMap?['lat'];
  if (latRaw is num) return latRaw.toDouble();
  return double.tryParse(latRaw?.toString() ?? '') ?? 0.0;
}

Object? _readLongitude(Map json, String key) {
  final userMap = json['user'] is Map
      ? json['user'] as Map
      : (json['member'] is Map ? json['member'] as Map : null);
  final lngRaw =
      json['longitude'] ??
      json['lng'] ??
      json['long'] ??
      userMap?['longitude'] ??
      userMap?['lng'];
  if (lngRaw is num) return lngRaw.toDouble();
  return double.tryParse(lngRaw?.toString() ?? '') ?? 0.0;
}

Object? _readPhone(Map json, String key) {
  final userMap = json['user'] is Map
      ? json['user'] as Map
      : (json['member'] is Map ? json['member'] as Map : null);
  return (json['phone'] ??
          json['phone_number'] ??
          json['no_hp'] ??
          json['telepon'] ??
          userMap?['phone'] ??
          userMap?['phone_number'] ??
          '')
      .toString();
}

Object? _readIsOnline(Map json, String key) {
  final isOnlineRaw =
      json['is_online'] ?? json['online'] ?? (json['status'] == 'online');
  return isOnlineRaw is bool ? isOnlineRaw : true;
}

Object? _readAlertId(Map json, String key) {
  return (json['alert_id'] ??
          json['id'] ??
          json['emergency_id'] ??
          'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}')
      .toString();
}

Object? _readIsSuccess(Map json, String key) {
  final isSuccessRaw = json['is_success'] ?? json['success'] ?? true;
  return isSuccessRaw is bool ? isSuccessRaw : true;
}

Object? _readTimestamp(Map json, String key) {
  return json['timestamp'] ?? json['created_at'];
}

Object? _readMessage(Map json, String key) {
  final alertId = _readAlertId(json, key);
  return (json['message'] ??
          'Sinyal darurat (SOS) ID $alertId berhasil dikirim! Tim tanggap darurat telah menerima koordinat Anda.')
      .toString();
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString()) ?? DateTime.now();
}

String _dateTimeToJson(DateTime date) => date.toIso8601String();

@freezed
abstract class NearbyMemberModel with _$NearbyMemberModel {
  const NearbyMemberModel._();

  const factory NearbyMemberModel({
    @JsonKey(name: 'id', readValue: _readId) required String id,
    @JsonKey(name: 'name', readValue: _readName) required String name,
    @JsonKey(name: 'role', readValue: _readRole) required String role,
    @JsonKey(name: 'distance_text', readValue: _readDistanceText)
    @Default('')
    String distanceText,
    @JsonKey(name: 'latitude', readValue: _readLatitude)
    @Default(0.0)
    double latitude,
    @JsonKey(name: 'longitude', readValue: _readLongitude)
    @Default(0.0)
    double longitude,
    @JsonKey(name: 'phone', readValue: _readPhone) @Default('') String phone,
    @JsonKey(name: 'is_online', readValue: _readIsOnline)
    @Default(true)
    bool isOnline,
  }) = _NearbyMemberModel;

  factory NearbyMemberModel.fromJson(Map<String, dynamic> json) =>
      _$NearbyMemberModelFromJson(json);
}

@freezed
abstract class PanicAlertResultModel with _$PanicAlertResultModel {
  const PanicAlertResultModel._();

  const factory PanicAlertResultModel({
    @JsonKey(name: 'is_success', readValue: _readIsSuccess)
    @Default(true)
    bool isSuccess,
    @JsonKey(name: 'alert_id', readValue: _readAlertId) required String alertId,
    @JsonKey(
      name: 'timestamp',
      readValue: _readTimestamp,
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    required DateTime timestamp,
    @JsonKey(name: 'message', readValue: _readMessage) required String message,
  }) = _PanicAlertResultModel;

  factory PanicAlertResultModel.fromJson(Map<String, dynamic> json) =>
      _$PanicAlertResultModelFromJson(json);
}
