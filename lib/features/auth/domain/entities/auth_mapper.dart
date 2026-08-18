import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';

export 'package:akar/features/auth/domain/entities/auth_entity.dart';

extension AuthModelMapper on AuthModel {
  AuthEntity toDomain() {
    return AuthEntity(
      message: message,
      accessToken: accessToken,
      tokenType: tokenType,
      user: user.toDomain(),
    );
  }
}

extension UserModelMapper on UserModel {
  UserEntity toDomain() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      nik: nik,
      role: role,
      latitude: latitude,
      longitude: longitude,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      villageMembersId: villageMembersId,
    );
  }
}

extension UserEntityMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      nik: nik,
      role: role,
      latitude: latitude,
      longitude: longitude,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      villageMembersId: villageMembersId,
    );
  }
}

extension AuthEntityMapper on AuthEntity {
  AuthModel toModel() {
    return AuthModel(
      message: message,
      accessToken: accessToken,
      tokenType: tokenType,
      user: user.toModel(),
    );
  }
}
