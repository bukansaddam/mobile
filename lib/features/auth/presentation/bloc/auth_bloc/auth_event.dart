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

  const LoginEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
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
  ];
}

class LogoutEvent extends AuthEvent {}
