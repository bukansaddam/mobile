import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
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
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  late AuthModel fakeResponse;

  @override
  Future<AuthModel> login({
    required String username,
    required String password,
    String? deviceId,
  }) async {
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
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceId,
  }) async {
    return fakeResponse;
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

    final memberLoginJson = {
      "success": true,
      "message": "Login berhasil",
      "access_token": "477|member-token",
      "token_type": "Bearer",
      "user": {
        "id": 250421,
        "name": "Warga",
        "username": "warga",
        "role": "member",
        "village_members_id": null,
      },
    };

    test('menolak login Linmas untuk akun masyarakat', () async {
      final remote = FakeAuthRemoteDatasource()
        ..fakeResponse = AuthModel.fromJson(memberLoginJson);
      final local = FakeAuthLocalDatasource();
      final bloc = buildBloc(remote, local);

      final emissions = expectLater(
        bloc.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthFailure>()]),
      );
      bloc.add(
        const LoginEvent(
          username: 'warga',
          password: 'password',
          expectOfficer: true,
        ),
      );
      await emissions;

      expect((bloc.state as AuthFailure).message, 'Akun tidak ditemukan');
      expect(local.cachedToken, isNull);
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

      expect(local.cachedToken, isNotNull);
      await bloc.close();
    });
  });
}
