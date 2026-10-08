import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';

export 'package:akar/features/auth/domain/entities/auth_entity.dart';

extension AuthModelMapper on AuthModel {
  AuthEntity toDomain() {
    final quizCompleted = isInitialQuizCompleted ?? user.isInitialQuizCompleted;
    final quizFilled = isInitialQuizFilled ?? user.isInitialQuizFilled;
    return AuthEntity(
      message: message,
      accessToken: accessToken,
      tokenType: tokenType,
      isInitialQuizCompleted: quizCompleted,
      isInitialQuizFilled: quizFilled,
      user: user.toDomain().copyWith(
        isInitialQuizCompleted: user.isInitialQuizCompleted ?? quizCompleted,
        isInitialQuizFilled: user.isInitialQuizFilled ?? quizFilled,
      ),
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
      isInitialQuizCompleted: isInitialQuizCompleted,
      isInitialQuizFilled: isInitialQuizFilled,
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
      isInitialQuizCompleted: isInitialQuizCompleted,
      isInitialQuizFilled: isInitialQuizFilled,
    );
  }
}

extension AuthEntityMapper on AuthEntity {
  AuthModel toModel() {
    return AuthModel(
      message: message,
      accessToken: accessToken,
      tokenType: tokenType,
      isInitialQuizCompleted: isInitialQuizCompleted,
      isInitialQuizFilled: isInitialQuizFilled,
      user: user.toModel(),
    );
  }
}
