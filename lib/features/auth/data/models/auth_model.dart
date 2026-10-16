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
    @JsonKey(name: "is_initial_quiz_completed") bool? isInitialQuizCompleted,
    @JsonKey(name: "is_initial_quiz_filled") bool? isInitialQuizFilled,
    @JsonKey(name: "user") required UserModel user,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}

Object? _readPhone(Map json, String key) {
  return json['phone'] ??
      json['phone_number'] ??
      (json['public_member'] is Map ? json['public_member']['phone'] : null);
}

Object? _readRole(Map json, String key) {
  final username = (json['username'] ?? '').toString().trim().toLowerCase();
  if (username == 'officer') {
    return 'officer';
  }
  if (username == 'member') {
    return 'member';
  }

  if (json['role'] != null) return json['role'].toString();
  if (json['roles'] is List && (json['roles'] as List).isNotEmpty) {
    final first = (json['roles'] as List).first;
    if (first is Map && first['name'] != null) return first['name'].toString();
    return first.toString();
  }
  if (json['public_member'] != null) return 'member';
  if (json['village_members_id'] != null) return 'officer';
  return null;
}

Object? _readAddress(Map json, String key) {
  return json['address'] ??
      json['alamat'] ??
      (json['public_member'] is Map ? json['public_member']['address'] : null);
}

Object? _readBirthDate(Map json, String key) {
  return json['birth_date'] ??
      json['birthdate'] ??
      json['tanggal_lahir'] ??
      (json['public_member'] is Map
          ? json['public_member']['birth_date']
          : null);
}

Object? _readProfilePic(Map json, String key) {
  return json['profile_pic'] ??
      json['profile_photo'] ??
      json['avatar'] ??
      json['photo'] ??
      (json['public_member'] is Map
          ? json['public_member']['profile_pic']
          : null);
}

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "username") String? username,
    @JsonKey(name: "phone", readValue: _readPhone) String? phoneNumber,
    @JsonKey(name: "nik") String? nik,
    @JsonKey(name: "role", readValue: _readRole) String? role,
    @JsonKey(name: "latitude") double? latitude,
    @JsonKey(name: "longitude") double? longitude,
    @JsonKey(name: "email_verified_at") dynamic emailVerifiedAt,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "village_members_id") int? villageMembersId,
    @JsonKey(name: "is_initial_quiz_completed") bool? isInitialQuizCompleted,
    @JsonKey(name: "is_initial_quiz_filled") bool? isInitialQuizFilled,
    @JsonKey(name: "birth_date", readValue: _readBirthDate) String? birthDate,
    @JsonKey(name: "address", readValue: _readAddress) String? address,
    @JsonKey(name: "profile_pic", readValue: _readProfilePic)
    String? profilePic,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
