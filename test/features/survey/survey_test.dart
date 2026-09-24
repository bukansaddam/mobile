import 'package:flutter_test/flutter_test.dart';

import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/data/datasources/survey_remote_datasource.dart';
import 'package:akar/features/survey/data/models/survey_model.dart';
import 'package:akar/features/survey/data/repositories/survey_repository_impl.dart';
import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/usecases/get_monthly_survey_status_usecase.dart';
import 'package:akar/features/survey/domain/usecases/get_survey_history_usecase.dart';
import 'package:akar/features/survey/domain/usecases/submit_api_survey_answers_usecase.dart';
import 'package:akar/features/survey/domain/usecases/submit_monthly_survey_usecase.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';

class FakeSurveyRemoteDatasource implements SurveyRemoteDatasource {
  bool submitCalled = false;
  int? submittedSurveyId;
  SurveySubmitRequestModel? submittedRequest;
  bool shouldThrow = false;

  @override
  Future<SurveyListResponseModel> getSurveys({String? period}) async {
    return const SurveyListResponseModel(
      success: true,
      data: [
        SurveyItemModel(
          id: 1,
          title: 'Survey Lingkungan & Keamanan',
          period: '2026-09',
          questions: [
            SurveyQuestionModel(
              id: 101,
              text: 'Apakah pernah terjadi pencurian?',
              type: 'pilihan_ganda',
              options: ['Ya', 'Tidak'],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<bool> submitSurveyAnswers({
    required int surveyId,
    required SurveySubmitRequestModel request,
  }) async {
    if (shouldThrow) {
      throw Exception('Server 500 error');
    }
    submitCalled = true;
    submittedSurveyId = surveyId;
    submittedRequest = request;
    return true;
  }
}

class FakeSurveyLocalDatasource implements SurveyLocalDatasource {
  final Map<String, DynamicMonthlySurveyEntity> dynamicSurveys = {};

  @override
  Future<void> clearAllSurveys() async => dynamicSurveys.clear();

  @override
  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(String periodKey) async {
    return const MonthlySurveyFormEntity(
      id: '1',
      title: 'Survey Lingkungan',
      description: 'Deskripsi',
      period: '2026-09',
      periodLabel: 'September 2026',
      questions: [],
    );
  }

  @override
  Future<List<SurveyEntity>> getAllSurveyHistory() async => [];

  @override
  Future<InitialSurveyEntity?> getInitialSurvey(int userId) async => null;

  @override
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(String periodKey) async {
    return dynamicSurveys[periodKey];
  }

  @override
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey) async => null;

  @override
  bool isInitialSurveyCompletedSync(int userId) => true;

  @override
  Future<bool> isSurveyDismissedForPeriod(String periodKey) async => false;

  @override
  Future<bool> isSurveySubmittedForPeriod(String periodKey) async {
    return dynamicSurveys.containsKey(periodKey);
  }

  @override
  Future<void> saveDynamicMonthlySurvey(DynamicMonthlySurveyEntity survey) async {
    dynamicSurveys[survey.period] = survey;
  }

  @override
  Future<void> saveInitialSurvey(int userId, InitialSurveyEntity survey) async {}

  @override
  Future<void> saveSurvey(SurveyEntity survey) async {}

  @override
  Future<void> setSurveyDismissedForPeriod(String periodKey) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Survey Remote Submission Integration Tests', () {
    late FakeSurveyRemoteDatasource fakeRemote;
    late FakeSurveyLocalDatasource fakeLocal;
    late SurveyRepositoryImpl repository;
    late SubmitApiSurveyAnswersUsecase submitUsecase;
    late GetMonthlySurveyStatusUsecase getStatusUsecase;
    late SubmitMonthlySurveyUsecase submitMonthlyUsecase;
    late GetSurveyHistoryUsecase getHistoryUsecase;

    setUp(() {
      fakeRemote = FakeSurveyRemoteDatasource();
      fakeLocal = FakeSurveyLocalDatasource();
      repository = SurveyRepositoryImpl(
        localDatasource: fakeLocal,
        remoteDatasource: fakeRemote,
      );
      submitUsecase = SubmitApiSurveyAnswersUsecase(repository);
      getStatusUsecase = GetMonthlySurveyStatusUsecase(repository);
      submitMonthlyUsecase = SubmitMonthlySurveyUsecase(repository);
      getHistoryUsecase = GetSurveyHistoryUsecase(repository);
    });

    test('submitApiSurveyAnswers in repository forwards request to remote datasource', () async {
      const request = SurveySubmitRequestEntity(
        answers: [
          SurveyQuestionAnswerEntity(
            questionId: 101,
            value: 'Ya',
            fields: [
              SurveyFieldAnswerEntity(fieldId: 1, value: 'Dekat Pos Ronda'),
              SurveyFieldAnswerEntity(fieldId: 2, value: '23:30'),
            ],
          ),
        ],
      );

      await repository.submitApiSurveyAnswers(
        surveyId: 1,
        request: request,
      );

      expect(fakeRemote.submitCalled, isTrue);
      expect(fakeRemote.submittedSurveyId, equals(1));
      expect(fakeRemote.submittedRequest?.answers.length, equals(1));
      expect(fakeRemote.submittedRequest?.answers.first.questionId, equals(101));
      expect(fakeRemote.submittedRequest?.answers.first.value, equals('Ya'));
      expect(fakeRemote.submittedRequest?.answers.first.fields.length, equals(2));
      expect(fakeRemote.submittedRequest?.answers.first.fields.first.fieldId, equals(1));
      expect(fakeRemote.submittedRequest?.answers.first.fields.first.value, equals('Dekat Pos Ronda'));
    });

    test('SurveyBloc emits [Submitting, Success, Loaded] and saves locally when submit succeeds', () async {
      final bloc = SurveyBloc(
        getMonthlySurveyStatusUsecase: getStatusUsecase,
        submitMonthlySurveyUsecase: submitMonthlyUsecase,
        getSurveyHistoryUsecase: getHistoryUsecase,
        submitApiSurveyAnswersUsecase: submitUsecase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SurveySubmittingState>(),
          isA<DynamicSurveySuccessState>(),
          isA<ApiSurveyLoadedState>(),
        ]),
      );

      bloc.add(
        const SubmitApiSurveyAnswersEvent(
          surveyId: 1,
          periodKey: '2026-09',
          request: SurveySubmitRequestEntity(
            answers: [
              SurveyQuestionAnswerEntity(
                questionId: 101,
                value: 'Ya',
                fields: [],
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 100));
      expect(fakeRemote.submitCalled, isTrue);
      expect(fakeLocal.dynamicSurveys.containsKey('2026-09'), isTrue);
    });

    test('SurveyBloc emits [Submitting, Failure] when remote submit fails', () async {
      fakeRemote.shouldThrow = true;
      final bloc = SurveyBloc(
        getMonthlySurveyStatusUsecase: getStatusUsecase,
        submitMonthlySurveyUsecase: submitMonthlyUsecase,
        getSurveyHistoryUsecase: getHistoryUsecase,
        submitApiSurveyAnswersUsecase: submitUsecase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SurveySubmittingState>(),
          isA<SurveyFailureState>(),
        ]),
      );

      bloc.add(
        const SubmitApiSurveyAnswersEvent(
          surveyId: 1,
          periodKey: '2026-09',
          request: SurveySubmitRequestEntity(
            answers: [],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 100));
      expect(fakeRemote.submitCalled, isFalse);
    });
  });
}
