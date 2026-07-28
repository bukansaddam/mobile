import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_entity.freezed.dart';

@freezed
abstract class AuthEntity with _$AuthEntity {
  const factory AuthEntity({
    String? message,
    required String accessToken,
    String? tokenType,
    required UserEntity user,
  }) = _AuthEntity;
}

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    String? name,
    String? email,
    String? username,
    String? phoneNumber,
    String? nik,
    double? latitude,
    double? longitude,
    dynamic emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? villageMembersId,
  }) = _UserEntity;
}
