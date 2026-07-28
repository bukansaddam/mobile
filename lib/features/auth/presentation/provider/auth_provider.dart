import 'package:akar/core/network/dio_client.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final AuthRepository repository;

  AuthProvider({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.repository,
  });

  bool _isLoading = false;
  bool _isInitialChecking = true;
  String? _errorMessage;
  String? _successMessage;
  UserEntity? _currentUser;
  String? _token;

  bool get isLoading => _isLoading;
  bool get isInitialChecking => _isInitialChecking;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  UserEntity? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty && _currentUser != null;

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isInitialChecking = true;

    final tokenResult = await repository.getSavedToken();
    final userResult = await repository.getSavedUser();

    tokenResult.fold(
      (failure) => _token = null,
      (savedToken) => _token = savedToken,
    );

    userResult.fold(
      (failure) => _currentUser = null,
      (savedUser) => _currentUser = savedUser,
    );

    if (_token != null && _token!.isNotEmpty) {
      DioClient.instance.options.headers['Authorization'] = 'Bearer $_token';
    }

    _isInitialChecking = false;
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await loginUsecase(username: username, password: password);

    bool isSuccess = false;
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        isSuccess = false;
      },
      (authEntity) {
        _currentUser = authEntity.user;
        _token = authEntity.accessToken;
        DioClient.instance.options.headers['Authorization'] = 'Bearer $_token';
        _successMessage = authEntity.message ?? 'Login berhasil';
        isSuccess = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> register({
    required String name,
    required String phoneNumber,
    required String nik,
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await registerUsecase(
      name: name,
      phoneNumber: phoneNumber,
      nik: nik,
      longitude: longitude,
      latitude: latitude,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    bool isSuccess = false;
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        isSuccess = false;
      },
      (authEntity) {
        _successMessage = authEntity.message ?? 'Registrasi berhasil';
        if (authEntity.accessToken.isNotEmpty) {
          _currentUser = authEntity.user;
          _token = authEntity.accessToken;
          DioClient.instance.options.headers['Authorization'] = 'Bearer $_token';
        }
        isSuccess = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await repository.logout();
    _token = null;
    _currentUser = null;
    _errorMessage = null;
    _successMessage = null;
    DioClient.instance.options.headers.remove('Authorization');

    _isLoading = false;
    notifyListeners();
  }
}
