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
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final GetSavedUserUsecase _getSavedUserUsecase;
  final GetSavedTokenUsecase _getSavedTokenUsecase;
  final LogoutUsecase _logoutUsecase;
  final FirebaseNotificationService? _notificationService;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required GetSavedUserUsecase getSavedUserUsecase,
    required GetSavedTokenUsecase getSavedTokenUsecase,
    required LogoutUsecase logoutUsecase,
    FirebaseNotificationService? notificationService,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _getSavedUserUsecase = getSavedUserUsecase,
        _getSavedTokenUsecase = getSavedTokenUsecase,
        _logoutUsecase = logoutUsecase,
        _notificationService = notificationService,
        super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<UpdateAuthUserEvent>(_onUpdateAuthUser);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthChecking());

    final tokenResult = await _getSavedTokenUsecase();
    final userResult = await _getSavedUserUsecase();

    final token = tokenResult.fold((_) => null, (val) => val);
    final currentUser = userResult.fold((_) => null, (val) => val);

    if (token != null && token.isNotEmpty && currentUser != null) {
      DioClient.instance.options.headers['Authorization'] = 'Bearer $token';
      emit(AuthAuthenticated(user: currentUser, token: token));
    } else {
      DioClient.instance.options.headers.remove('Authorization');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());

    final deviceId = await _resolveDeviceId(event.deviceId);
    final result = await _loginUsecase(
      username: event.username,
      password: event.password,
      deviceId: deviceId,
    );

    AuthEntity? loggedIn;
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (entity) => loggedIn = entity,
    );

    final authEntity = loggedIn;
    if (authEntity == null) return;

    final isOfficer = authEntity.user.isOfficer;
    if (event.expectOfficer != null && event.expectOfficer != isOfficer) {
      await _logoutUsecase();
      DioClient.instance.options.headers.remove('Authorization');
      emit(const AuthFailure('Akun tidak ditemukan'));
      return;
    }

    DioClient.instance.options.headers['Authorization'] =
        'Bearer ${authEntity.accessToken}';
    emit(
      AuthAuthenticated(
        user: authEntity.user,
        token: authEntity.accessToken,
        message: authEntity.message ?? 'Login berhasil',
      ),
    );
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());

    final deviceId = await _resolveDeviceId(event.deviceId);
    final result = await _registerUsecase(
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

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (authEntity) {
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
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());
    await _logoutUsecase();
    DioClient.instance.options.headers.remove('Authorization');
    emit(const AuthUnauthenticated(message: 'Logout berhasil'));
  }

  void _onUpdateAuthUser(
    UpdateAuthUserEvent event,
    Emitter<AuthState> emit,
  ) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(currentState.copyWith(user: event.user));
    }
  }

  Future<String?> _resolveDeviceId(String? deviceId) async {
    if (deviceId != null && deviceId.isNotEmpty) return deviceId;
    try {
      return await _notificationService?.getToken();
    } catch (_) {
      return null;
    }
  }
}
