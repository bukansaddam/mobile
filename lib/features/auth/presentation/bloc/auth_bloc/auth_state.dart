part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  UserEntity? get user {
    final s = this;
    if (s is AuthAuthenticated) {
      return s.user;
    } else if (s is RegisterSuccess) {
      return s.user;
    }
    return null;
  }

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthChecking extends AuthState {
  const AuthChecking();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

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

  AuthAuthenticated copyWith({
    UserEntity? user,
    String? token,
    String? message,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
      token: token ?? this.token,
      message: message ?? this.message,
    );
  }

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
