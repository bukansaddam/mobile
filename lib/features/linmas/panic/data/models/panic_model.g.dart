// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NearbyMemberModel _$NearbyMemberModelFromJson(Map<String, dynamic> json) =>
    _NearbyMemberModel(
      id: _readId(json, 'id') as String,
      name: _readName(json, 'name') as String,
      role: _readRole(json, 'role') as String,
      distanceText: _readDistanceText(json, 'distance_text') as String? ?? '',
      latitude: (_readLatitude(json, 'latitude') as num?)?.toDouble() ?? 0.0,
      longitude: (_readLongitude(json, 'longitude') as num?)?.toDouble() ?? 0.0,
      phone: _readPhone(json, 'phone') as String? ?? '',
      isOnline: _readIsOnline(json, 'is_online') as bool? ?? true,
    );

Map<String, dynamic> _$NearbyMemberModelToJson(_NearbyMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'distance_text': instance.distanceText,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'is_online': instance.isOnline,
    };

_PanicAlertResultModel _$PanicAlertResultModelFromJson(
  Map<String, dynamic> json,
) => _PanicAlertResultModel(
  isSuccess: _readIsSuccess(json, 'is_success') as bool? ?? true,
  alertId: _readAlertId(json, 'alert_id') as String,
  timestamp: _dateTimeFromJson(_readTimestamp(json, 'timestamp')),
  message: _readMessage(json, 'message') as String,
);

Map<String, dynamic> _$PanicAlertResultModelToJson(
  _PanicAlertResultModel instance,
) => <String, dynamic>{
  'is_success': instance.isSuccess,
  'alert_id': instance.alertId,
  'timestamp': _dateTimeToJson(instance.timestamp),
  'message': instance.message,
};
