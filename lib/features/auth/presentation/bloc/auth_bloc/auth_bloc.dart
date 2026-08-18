import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final AuthRepository repository;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.repository,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(AuthChecking());

      final tokenResult = await repository.getSavedToken();
      final userResult = await repository.getSavedUser();

      String? token;
      UserEntity? currentUser;

      tokenResult.fold(
        (failure) => token = null,
        (savedToken) => token = savedToken,
      );

      userResult.fold(
        (failure) => currentUser = null,
        (savedUser) => currentUser = savedUser,
      );

      if (token != null && token!.isNotEmpty && currentUser != null) {
        DioClient.instance.options.headers['Authorization'] = 'Bearer $token';
        emit(AuthAuthenticated(user: currentUser!, token: token!));
      } else {
        DioClient.instance.options.headers.remove('Authorization');
        emit(const AuthUnauthenticated());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await loginUsecase(
        username: event.username,
        password: event.password,
      );

      result.fold((failure) => emit(AuthFailure(failure.message)), (
        authEntity,
      ) {
        DioClient.instance.options.headers['Authorization'] =
            'Bearer ${authEntity.accessToken}';
        emit(
          AuthAuthenticated(
            user: authEntity.user,
            token: authEntity.accessToken,
            message: authEntity.message ?? 'Login berhasil',
          ),
        );
      });
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await registerUsecase(
        name: event.name,
        phoneNumber: event.phoneNumber,
        nik: event.nik,
        longitude: event.longitude,
        latitude: event.latitude,
        username: event.username,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      result.fold((failure) => emit(AuthFailure(failure.message)), (
        authEntity,
      ) {
        if (authEntity.accessToken.isNotEmpty) {
          DioClient.instance.options.headers['Authorization'] =
              'Bearer ${authEntity.accessToken}';
          emit(
            AuthAuthenticated(
              user: authEntity.user,
              token: authEntity.accessToken,
              message: authEntity.message ?? 'Registrasi berhasil',
            ),
          );
        } else {
          emit(
            RegisterSuccess(
              message: authEntity.message ?? 'Registrasi berhasil',
              user: authEntity.user,
            ),
          );
        }
      });
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      await repository.logout();
      DioClient.instance.options.headers.remove('Authorization');
      emit(const AuthUnauthenticated(message: 'Logout berhasil'));
    });
  }
}
