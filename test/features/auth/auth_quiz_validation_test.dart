import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:akar/features/auth/domain/entities/auth_mapper.dart';
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
  UserModel? cachedUser;

  @override
  Future<void> clearSession() async {
    cachedToken = null;
    cachedUser = null;
  }

  @override
  Future<String?> getToken() async => cachedToken;

  @override
  Future<UserModel?> getUser() async => cachedUser;

  @override
  Future<void> saveToken(String token) async {
    cachedToken = token;
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
  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(String periodKey) async {
    throw UnimplementedError();
  }

  @override
  Future<List<SurveyEntity>> getAllSurveyHistory() async => [];

  @override
  Future<InitialSurveyEntity?> getInitialSurvey(int userId) async => null;

  @override
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(String periodKey) async => null;

  @override
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey) async => null;

  @override
  Future<bool> isSurveyDismissedForPeriod(String periodKey) async => false;

  @override
  Future<bool> isSurveySubmittedForPeriod(String periodKey) async => false;

  @override
  Future<void> saveDynamicMonthlySurvey(DynamicMonthlySurveyEntity survey) async {}

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
        "is_initial_quiz_filled": false
      }
    };

    final Map<String, dynamic> rawLoginJsonCompleted = {
      "success": true,
      "message": "Login berhasil",
      "access_token": "476|JljwCyy1dZQ5W0KPNeAByhskJRI2ATmwJWnyGk3md7248bb1",
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
        "is_initial_quiz_filled": true
      }
    };

    test('AuthModel.fromJson parses is_initial_quiz_completed and is_initial_quiz_filled accurately', () {
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
    });

    test('AuthRepositoryImpl.login syncs initial survey completion false to SurveyLocalDatasource', () async {
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
    });

    test('AuthRepositoryImpl.login syncs initial survey completion true to SurveyLocalDatasource', () async {
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
    });
  });
}
