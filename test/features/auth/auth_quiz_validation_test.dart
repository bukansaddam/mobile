import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/data/models/ktp_ocr_model.dart';
import 'package:akar/features/auth/data/models/otp_challenge_model.dart';
import 'package:akar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:akar/features/auth/domain/entities/auth_mapper.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_user_usecase.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:akar/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter(this.responseBody);

  final Map<String, dynamic> responseBody;
  String? lastPath;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastPath = options.path;
    return ResponseBody.fromString(
      jsonEncode(responseBody),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  late AuthModel fakeResponse;
  bool? lastIsOfficer;

  @override
  Future<KtpOcrModel> scanKtp(File file) {
    throw UnimplementedError();
  }

  @override
  Future<AuthModel> login({
    required String username,
    required String password,
    String? deviceId,
    bool isOfficer = false,
  }) async {
    lastIsOfficer = isOfficer;
    return fakeResponse;
  }

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    return fakeResponse;
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String phoneNumber,
    required String nik,
    String birthPlace = '',
    String birthDate = '',
    String address = '',
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String otpChallengeToken = '',
    String otpCode = '',
    File? ktpPhoto,
    String? deviceId,
  }) async {
    return fakeResponse;
  }

  @override
  Future<OtpChallengeModel> sendRegisterOtp({
    required String phoneNumber,
  }) async {
    return const OtpChallengeModel(
      challengeToken: 'challenge-token',
      expiresIn: 300,
      resendAfter: 60,
    );
  }
}

class FakeAuthLocalDatasource implements AuthLocalDatasource {
  String? cachedToken;
  DateTime? cachedLastActivityAt;
  String? cachedRefreshToken;
  UserModel? cachedUser;

  @override
  Future<void> clearSession() async {
    cachedToken = null;
    cachedLastActivityAt = null;
    cachedRefreshToken = null;
    cachedUser = null;
  }

  @override
  Future<String?> getToken() async => cachedToken;

  @override
  Future<DateTime?> getLastActivityAt() async => cachedLastActivityAt;

  @override
  Future<void> touchActivity() async {
    cachedLastActivityAt = DateTime.now();
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    cachedRefreshToken = token;
  }

  @override
  Future<String?> getRefreshToken() async => cachedRefreshToken;

  @override
  Future<UserModel?> getUser() async => cachedUser;

  @override
  String? getCachedUserId() => cachedUser?.id.toString();

  @override
  Future<void> saveToken(String token) async {
    cachedToken = token;
    await touchActivity();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    cachedUser = user;
  }
}

class MemorySurveyLocalDatasource implements SurveyLocalDatasource {
  final Map<int, bool> _quizStatus = {};

  @override
  bool isInitialSurveyCompletedSync(int userId) {
    return _quizStatus[userId] ?? false;
  }

  @override
  Future<void> setInitialSurveyCompleted(int userId, bool isCompleted) async {
    _quizStatus[userId] = isCompleted;
  }

  @override
  Future<void> saveInitialSurvey(int userId, InitialSurveyEntity survey) async {
    _quizStatus[userId] = true;
  }

  @override
  Future<void> clearAllSurveys() async => _quizStatus.clear();

  @override
  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(
    String periodKey,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<List<SurveyEntity>> getAllSurveyHistory() async => [];

  @override
  Future<InitialSurveyEntity?> getInitialSurvey(int userId) async => null;

  @override
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(
    String periodKey,
  ) async => null;

  @override
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey) async =>
      null;

  @override
  Future<bool> isSurveyDismissedForPeriod(String periodKey) async => false;

  @override
  Future<bool> isSurveySubmittedForPeriod(String periodKey) async => false;

  @override
  Future<void> saveDynamicMonthlySurvey(
    DynamicMonthlySurveyEntity survey,
  ) async {}

  @override
  Future<void> saveSurvey(SurveyEntity survey) async {}

  @override
  Future<void> setSurveyDismissedForPeriod(String periodKey) async {}
}

void main() {
  group('Auth Initial Quiz Response Validation Tests', () {
    final Map<String, dynamic> rawLoginJsonUncompleted = {
      "success": true,
      "message": "Login berhasil",
      "access_token": "476|JljwCyy1dZQ5W0KPNeAByhskJRI2ATmwJWnyGk3md7248bb1",
      "refresh_token": "refresh-476",
      "token_type": "Bearer",
      "is_initial_quiz_completed": false,
      "is_initial_quiz_filled": false,
      "user": {
        "id": 250420,
        "name": "Agus Sunandar",
        "email": "agus@example.test",
        "username": "agusunandar",
        "role": "officer",
        "village_members_id": 5714542,
        "is_initial_quiz_completed": false,
        "is_initial_quiz_filled": false,
      },
    };

    final Map<String, dynamic> rawLoginJsonCompleted = {
      "success": true,
      "message": "Login berhasil",
      "access_token": "476|JljwCyy1dZQ5W0KPNeAByhskJRI2ATmwJWnyGk3md7248bb1",
      "refresh_token": "refresh-476",
      "token_type": "Bearer",
      "is_initial_quiz_completed": true,
      "is_initial_quiz_filled": true,
      "user": {
        "id": 250420,
        "name": "Agus Sunandar",
        "email": "agus@example.test",
        "username": "agusunandar",
        "role": "officer",
        "village_members_id": 5714542,
        "is_initial_quiz_completed": true,
        "is_initial_quiz_filled": true,
      },
    };

    test(
      'AuthModel.fromJson parses is_initial_quiz_completed and is_initial_quiz_filled accurately',
      () {
        final modelUncompleted = AuthModel.fromJson(rawLoginJsonUncompleted);
        expect(modelUncompleted.isInitialQuizCompleted, isFalse);
        expect(modelUncompleted.isInitialQuizFilled, isFalse);
        expect(modelUncompleted.user.isInitialQuizCompleted, isFalse);
        expect(modelUncompleted.user.isInitialQuizFilled, isFalse);

        final domainUncompleted = modelUncompleted.toDomain();
        expect(domainUncompleted.hasCompletedInitialQuiz, isFalse);
        expect(domainUncompleted.user.hasCompletedInitialQuiz, isFalse);

        final modelCompleted = AuthModel.fromJson(rawLoginJsonCompleted);
        expect(modelCompleted.isInitialQuizCompleted, isTrue);
        expect(modelCompleted.isInitialQuizFilled, isTrue);
        expect(modelCompleted.user.isInitialQuizCompleted, isTrue);
        expect(modelCompleted.user.isInitialQuizFilled, isTrue);

        final domainCompleted = modelCompleted.toDomain();
        expect(domainCompleted.hasCompletedInitialQuiz, isTrue);
        expect(domainCompleted.user.hasCompletedInitialQuiz, isTrue);
      },
    );

    test(
      'AuthRepositoryImpl.login syncs initial survey completion false to SurveyLocalDatasource',
      () async {
        final fakeRemote = FakeAuthRemoteDatasource();
        final fakeLocal = FakeAuthLocalDatasource();
        final surveyLocal = MemorySurveyLocalDatasource();

        fakeRemote.fakeResponse = AuthModel.fromJson(rawLoginJsonUncompleted);

        final repository = AuthRepositoryImpl(
          remoteDatasource: fakeRemote,
          localDatasource: fakeLocal,
          surveyLocalDatasource: surveyLocal,
        );

        final result = await repository.login(
          username: 'agusunandar',
          password: 'password',
        );

        expect(result.isRight, isTrue);
        expect(surveyLocal.isInitialSurveyCompletedSync(250420), isFalse);
        final user = result.right.user;
        expect(user.hasCompletedInitialQuiz, isFalse);
      },
    );

    test(
      'AuthRepositoryImpl.login syncs initial survey completion true to SurveyLocalDatasource',
      () async {
        final fakeRemote = FakeAuthRemoteDatasource();
        final fakeLocal = FakeAuthLocalDatasource();
        final surveyLocal = MemorySurveyLocalDatasource();

        fakeRemote.fakeResponse = AuthModel.fromJson(rawLoginJsonCompleted);

        final repository = AuthRepositoryImpl(
          remoteDatasource: fakeRemote,
          localDatasource: fakeLocal,
          surveyLocalDatasource: surveyLocal,
        );

        final result = await repository.login(
          username: 'agusunandar',
          password: 'password',
        );

        expect(result.isRight, isTrue);
        expect(surveyLocal.isInitialSurveyCompletedSync(250420), isTrue);
        final user = result.right.user;
        expect(user.hasCompletedInitialQuiz, isTrue);
      },
    );

    test('AuthRepositoryImpl.login menyimpan refresh token', () async {
      final fakeRemote = FakeAuthRemoteDatasource();
      final fakeLocal = FakeAuthLocalDatasource();
      fakeRemote.fakeResponse = AuthModel.fromJson(rawLoginJsonUncompleted);

      final repository = AuthRepositoryImpl(
        remoteDatasource: fakeRemote,
        localDatasource: fakeLocal,
      );

      await repository.login(username: 'agusunandar', password: 'password');

      expect(fakeLocal.cachedToken, isNotEmpty);
      expect(fakeLocal.cachedRefreshToken, 'refresh-476');
    });
  });

  group('Login role validation', () {
    AuthBloc buildBloc(
      FakeAuthRemoteDatasource remote,
      FakeAuthLocalDatasource local,
    ) {
      final repository = AuthRepositoryImpl(
        remoteDatasource: remote,
        localDatasource: local,
      );
      return AuthBloc(
        loginUsecase: LoginUsecase(repository),
        registerUsecase: RegisterUsecase(repository),
        getSavedUserUsecase: GetSavedUserUsecase(repository),
        getSavedTokenUsecase: GetSavedTokenUsecase(repository),
        logoutUsecase: LogoutUsecase(repository),
        refreshTokenUsecase: RefreshTokenUsecase(repository),
      );
    }

    final multiRoleLoginJson = {
      "success": true,
      "message": "Login berhasil",
      "access_token": "477|multi-role-token",
      "token_type": "Bearer",
      "user": {
        "id": 769798,
        "name": "Rezzitukam",
        "username": "rezzitukam",
        "village_members_id": 6234204,
      },
    };

    test(
      'akun multi-role dengan village_members_id berhasil login sebagai masyarakat',
      () async {
        final remote = FakeAuthRemoteDatasource()
          ..fakeResponse = AuthModel.fromJson(multiRoleLoginJson);
        final local = FakeAuthLocalDatasource();
        final bloc = buildBloc(remote, local);

        final emissions = expectLater(
          bloc.stream,
          emitsInOrder([isA<AuthLoading>(), isA<AuthAuthenticated>()]),
        );
        bloc.add(
          const LoginEvent(
            username: 'rezzitukam',
            password: 'password',
            expectOfficer: false,
          ),
        );
        await emissions;

        final authState = bloc.state as AuthAuthenticated;
        expect(remote.lastIsOfficer, isFalse);
        expect(authState.user.role, 'member');
        expect(authState.user.isMember, isTrue);
        expect(local.cachedUser?.role, 'member');
        await bloc.close();
      },
    );

    test('UpdateAuthUserEvent mempertahankan role sesi aktif akun multi-role', () async {
      final remote = FakeAuthRemoteDatasource()
        ..fakeResponse = AuthModel.fromJson(multiRoleLoginJson);
      final local = FakeAuthLocalDatasource();
      final bloc = buildBloc(remote, local);

      final loginDone = expectLater(
        bloc.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthAuthenticated>()]),
      );
      bloc.add(
        const LoginEvent(
          username: 'rezzitukam',
          password: 'password',
          expectOfficer: false,
        ),
      );
      await loginDone;

      final updateDone = expectLater(bloc.stream, emits(isA<AuthAuthenticated>()));
      bloc.add(
        UpdateAuthUserEvent(
          UserModel.fromJson({
            'id': 769798,
            'name': 'Rezzitukam Updated',
            'username': 'rezzitukam',
            'village_members_id': 6234204,
          }).toDomain(),
        ),
      );
      await updateDone;

      final authState = bloc.state as AuthAuthenticated;
      expect(authState.user.name, 'Rezzitukam Updated');
      expect(authState.user.role, 'member');
      expect(authState.user.isMember, isTrue);
      await bloc.close();
    });

    test('menerima login Linmas untuk akun officer', () async {
      final remote = FakeAuthRemoteDatasource()
        ..fakeResponse = AuthModel.fromJson({
          "success": true,
          "message": "Login berhasil",
          "access_token": "478|officer-token",
          "token_type": "Bearer",
          "user": {
            "id": 250422,
            "name": "Petugas",
            "username": "petugas",
            "role": "linmas",
          },
        });
      final local = FakeAuthLocalDatasource();
      final bloc = buildBloc(remote, local);

      final emissions = expectLater(
        bloc.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthAuthenticated>()]),
      );
      bloc.add(
        const LoginEvent(
          username: 'petugas',
          password: 'password',
          expectOfficer: true,
        ),
      );
      await emissions;

      final authState = bloc.state as AuthAuthenticated;
      expect(remote.lastIsOfficer, isTrue);
      expect(authState.user.role, 'officer');
      expect(authState.user.isOfficer, isTrue);
      expect(local.cachedToken, isNotNull);
      await bloc.close();
    });

    test('login masyarakat dan fallback role null mengirim isOfficer false', () async {
      final remote = FakeAuthRemoteDatasource()
        ..fakeResponse = AuthModel.fromJson(multiRoleLoginJson);
      final local = FakeAuthLocalDatasource();
      final bloc = buildBloc(remote, local);

      for (final expectOfficer in [false, null]) {
        remote.lastIsOfficer = null;
        final emissions = expectLater(
          bloc.stream,
          emitsInOrder([isA<AuthLoading>(), isA<AuthAuthenticated>()]),
        );
        bloc.add(
          LoginEvent(
            username: 'warga',
            password: 'password',
            expectOfficer: expectOfficer,
          ),
        );
        await emissions;
        expect(remote.lastIsOfficer, isFalse);
      }

      await bloc.close();
    });
  });

  group('AuthRemoteDatasourceImpl.login endpoint routing', () {
    test('memilih /api/login/member untuk masyarakat dan /api/login/officer untuk linmas', () async {
      final adapter = _RecordingAdapter({
        'success': true,
        'message': 'Login berhasil',
        'data': {
          'access_token': 'token-123',
          'token_type': 'Bearer',
          'user': {'id': 1, 'name': 'User', 'role': 'member'},
        },
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
        ..httpClientAdapter = adapter;
      final datasource = AuthRemoteDatasourceImpl(dioClient: dio);

      await datasource.login(username: 'warga', password: 'secret');
      expect(adapter.lastPath, '/api/login/member');

      await datasource.login(
        username: 'petugas',
        password: 'secret',
        isOfficer: true,
      );
      expect(adapter.lastPath, '/api/login/officer');
    });
  });
}
