part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  final String? deviceId;

  const LoginEvent({
    required this.username,
    required this.password,
    this.deviceId,
  });

  @override
  List<Object?> get props => [username, password, deviceId];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String phoneNumber;
  final String nik;
  final double longitude;
  final double latitude;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? deviceId;

  const RegisterEvent({
    required this.name,
    required this.phoneNumber,
    required this.nik,
    required this.longitude,
    required this.latitude,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.deviceId,
  });

  @override
  List<Object?> get props => [
    name,
    phoneNumber,
    nik,
    longitude,
    latitude,
    username,
    email,
    password,
    passwordConfirmation,
    deviceId,
  ];
}

class LogoutEvent extends AuthEvent {}

class UpdateAuthUserEvent extends AuthEvent {
  final UserEntity user;

  const UpdateAuthUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
