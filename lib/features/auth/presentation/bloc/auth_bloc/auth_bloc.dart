import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_user_usecase.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final GetSavedUserUsecase getSavedUserUsecase;
  final GetSavedTokenUsecase getSavedTokenUsecase;
  final LogoutUsecase logoutUsecase;
  final FirebaseNotificationService? notificationService;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.getSavedUserUsecase,
    required this.getSavedTokenUsecase,
    required this.logoutUsecase,
    this.notificationService,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(AuthChecking());

      final tokenResult = await getSavedTokenUsecase();
      final userResult = await getSavedUserUsecase();

      final token = tokenResult.fold((_) => null, (val) => val);
      final currentUser = userResult.fold((_) => null, (val) => val);

      if (token != null && token.isNotEmpty && currentUser != null) {
        DioClient.instance.options.headers['Authorization'] = 'Bearer $token';
        emit(AuthAuthenticated(user: currentUser, token: token));
      } else {
        DioClient.instance.options.headers.remove('Authorization');
        emit(const AuthUnauthenticated());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      final deviceId = await _resolveDeviceId(event.deviceId);
      final result = await loginUsecase(
        username: event.username,
        password: event.password,
        deviceId: deviceId,
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

      final deviceId = await _resolveDeviceId(event.deviceId);
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
        deviceId: deviceId,
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
      await logoutUsecase();
      DioClient.instance.options.headers.remove('Authorization');
      emit(const AuthUnauthenticated(message: 'Logout berhasil'));
    });

    on<UpdateAuthUserEvent>((event, emit) {
      final currentState = state;
      if (currentState is AuthAuthenticated) {
        emit(currentState.copyWith(user: event.user));
      }
    });
  }

  Future<String?> _resolveDeviceId(String? deviceId) async {
    if (deviceId != null && deviceId.isNotEmpty) return deviceId;
    try {
      return await notificationService?.getToken();
    } catch (_) {
      return null;
    }
  }
}
