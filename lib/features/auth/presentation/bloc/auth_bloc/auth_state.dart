part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  UserEntity? get user {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).user;
    } else if (this is RegisterSuccess) {
      return (this as RegisterSuccess).user;
    }
    return null;
  }

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthChecking extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  @override
  final UserEntity user;
  final String token;
  final String? message;

  const AuthAuthenticated({
    required this.user,
    required this.token,
    this.message,
  });

  @override
  List<Object?> get props => [user, token, message];
}

class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterSuccess extends AuthState {
  final String message;
  @override
  final UserEntity? user;
  final String? token;

  const RegisterSuccess({required this.message, this.user, this.token});

  @override
  List<Object?> get props => [message, user, token];
}
