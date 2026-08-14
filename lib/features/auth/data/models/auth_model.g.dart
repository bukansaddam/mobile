// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => _AuthModel(
  message: json['message'] as String?,
  accessToken: json['access_token'] as String,
  tokenType: json['token_type'] as String?,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthModelToJson(_AuthModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'user': instance.user,
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  username: json['username'] as String?,
  phoneNumber: _readPhone(json, 'phone') as String?,
  nik: json['nik'] as String?,
  role: _readRole(json, 'role') as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  emailVerifiedAt: json['email_verified_at'],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  villageMembersId: (json['village_members_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'username': instance.username,
      'phone': instance.phoneNumber,
      'nik': instance.nik,
      'role': instance.role,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'village_members_id': instance.villageMembersId,
    };
