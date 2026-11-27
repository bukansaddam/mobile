import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_user_usecase.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:akar/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/permissions/data/services/app_permission_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final GetSavedUserUsecase _getSavedUserUsecase;
  final GetSavedTokenUsecase _getSavedTokenUsecase;
  final LogoutUsecase _logoutUsecase;
  final RefreshTokenUsecase _refreshTokenUsecase;
  final FirebaseNotificationService? _notificationService;
  final AppPermissionService? _permissionService;

  AuthBloc({
    required this._loginUsecase,
    required this._registerUsecase,
    required this._getSavedUserUsecase,
    required this._getSavedTokenUsecase,
    required this._logoutUsecase,
    required this._refreshTokenUsecase,
    this._notificationService,
    this._permissionService,
  }) : super(const AuthInitial()) {
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
      final refreshResult = await _refreshTokenUsecase();
      await refreshResult.fold<Future<void>>(
        (failure) async {
          // Pertahankan sesi lokal saat offline/timeout/5xx agar user tetap bisa lapor offline.
          if (failure.isRetryable) {
            DioClient.instance.options.headers['Authorization'] =
                'Bearer $token';
            await _permissionService?.refreshStatuses(
              isOfficer: currentUser.isOfficer,
            );
            emit(
              AuthAuthenticated(
                user: currentUser,
                token: token,
                isOfflineSession: true,
              ),
            );
            return;
          }

          await _logoutUsecase();
          DioClient.instance.options.headers.remove('Authorization');
          emit(const AuthUnauthenticated());
        },
        (refreshed) async {
          if (refreshed.accessToken.isEmpty) {
            await _logoutUsecase();
            DioClient.instance.options.headers.remove('Authorization');
            emit(const AuthUnauthenticated());
            return;
          }

          DioClient.instance.options.headers['Authorization'] =
              'Bearer ${refreshed.accessToken}';
          await _permissionService?.refreshStatuses(
            isOfficer: refreshed.user.isOfficer,
          );
          emit(
            AuthAuthenticated(
              user: refreshed.user,
              token: refreshed.accessToken,
            ),
          );
        },
      );
      return;
    } else {
      DioClient.instance.options.headers.remove('Authorization');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());

    final deviceId = await _resolveDeviceId(event.deviceId);
    final result = await _loginUsecase(
      username: event.username,
      password: event.password,
      deviceId: deviceId,
      isOfficer: event.expectOfficer ?? false,
    );

    AuthEntity? loggedIn;
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (entity) => loggedIn = entity,
    );

    final authEntity = loggedIn;
    if (authEntity == null) return;

    DioClient.instance.options.headers['Authorization'] =
        'Bearer ${authEntity.accessToken}';
    await _permissionService?.refreshStatuses(
      isOfficer: authEntity.user.isOfficer,
    );
    emit(
      AuthAuthenticated(
        user: authEntity.user,
        token: authEntity.accessToken,
        message: authEntity.message ?? 'Login berhasil',
      ),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());

    final deviceId = await _resolveDeviceId(event.deviceId);
    final result = await _registerUsecase(
      name: event.name,
      phoneNumber: event.phoneNumber,
      nik: event.nik,
      birthPlace: event.birthPlace,
      birthDate: event.birthDate,
      address: event.address,
      longitude: event.longitude,
      latitude: event.latitude,
      username: event.username,
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      otpChallengeToken: event.otpChallengeToken,
      otpCode: event.otpCode,
      ktpPhoto: event.ktpPhoto,
      deviceId: deviceId,
    );

    await result.fold<Future<void>>(
      (failure) async => emit(AuthFailure(failure.message)),
      (authEntity) async {
        if (authEntity.accessToken.isNotEmpty) {
          DioClient.instance.options.headers['Authorization'] =
              'Bearer ${authEntity.accessToken}';
          await _permissionService?.refreshStatuses(
            isOfficer: authEntity.user.isOfficer,
          );
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

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    if (state is AuthLoading) return;
    final previousState = state;
    _permissionService?.resetCache();
    emit(const AuthLoading());

    if (event.clearOfflineQueue) {
      String? currentUserId;
      if (previousState is AuthAuthenticated) {
        currentUserId = previousState.user.id.toString();
      } else if (sl.isRegistered<AuthLocalDatasource>()) {
        currentUserId = sl<AuthLocalDatasource>().getCachedUserId();
      }

      if (currentUserId != null &&
          currentUserId.isNotEmpty &&
          sl.isRegistered<OfflineQueueLocalDatasource>()) {
        try {
          await sl<OfflineQueueLocalDatasource>().clearForUser(currentUserId);
        } catch (_) {}
      }

      if (sl.isRegistered<OfflineMasterCacheLocalDatasource>()) {
        try {
          await sl<OfflineMasterCacheLocalDatasource>().clearAll();
        } catch (_) {}
      }
    }

    await _logoutUsecase();
    _permissionService?.resetCache();
    _notificationService?.resetSyncedDeviceState();
    DioClient.instance.options.headers.remove('Authorization');
    emit(const AuthUnauthenticated(message: 'Logout berhasil'));
  }

  void _onUpdateAuthUser(UpdateAuthUserEvent event, Emitter<AuthState> emit) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final activeRole = currentState.user.role;
      final nextUser = activeRole != null
          ? event.user.copyWith(role: activeRole)
          : event.user;
      emit(currentState.copyWith(user: nextUser));
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
