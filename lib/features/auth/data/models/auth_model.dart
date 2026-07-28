import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class AuthModel with _$AuthModel {
  const AuthModel._();

  const factory AuthModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "token_type") String? tokenType,
    @JsonKey(name: "user") required UserModel user,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  AuthEntity toEntity() => AuthEntity(
        message: message,
        accessToken: accessToken,
        tokenType: tokenType,
        user: user.toEntity(),
      );
}

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "username") String? username,
    @JsonKey(name: "phone_number") String? phoneNumber,
    @JsonKey(name: "nik") String? nik,
    @JsonKey(name: "latitude") double? latitude,
    @JsonKey(name: "longitude") double? longitude,
    @JsonKey(name: "email_verified_at") dynamic emailVerifiedAt,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "village_members_id") int? villageMembersId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        username: username,
        phoneNumber: phoneNumber,
        nik: nik,
        latitude: latitude,
        longitude: longitude,
        emailVerifiedAt: emailVerifiedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        villageMembersId: villageMembersId,
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        username: entity.username,
        phoneNumber: entity.phoneNumber,
        nik: entity.nik,
        latitude: entity.latitude,
        longitude: entity.longitude,
        emailVerifiedAt: entity.emailVerifiedAt,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        villageMembersId: entity.villageMembersId,
      );
}
