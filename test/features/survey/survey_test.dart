import 'package:flutter_test/flutter_test.dart';

import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/data/datasources/survey_remote_datasource.dart';
import 'package:akar/features/survey/data/models/initial_quiz_model.dart';
import 'package:akar/features/survey/data/models/survey_model.dart';
import 'package:akar/features/survey/data/repositories/survey_repository_impl.dart';
import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/usecases/get_initial_quiz_usecase.dart';
import 'package:akar/features/survey/domain/usecases/get_monthly_survey_status_usecase.dart';
import 'package:akar/features/survey/domain/usecases/get_survey_history_usecase.dart';
import 'package:akar/features/survey/domain/usecases/submit_api_survey_answers_usecase.dart';
import 'package:akar/features/survey/domain/usecases/submit_initial_quiz_usecase.dart';
import 'package:akar/features/survey/domain/usecases/submit_monthly_survey_usecase.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';

class FakeSurveyRemoteDatasource implements SurveyRemoteDatasource {
  bool submitCalled = false;
  int? submittedSurveyId;
  SurveySubmitRequestModel? submittedRequest;
  bool shouldThrow = false;

  bool submitInitialQuizCalled = false;
  dynamic submittedInitialQuizAnswers;
  InitialQuizResponseModel fakeInitialQuiz = const InitialQuizResponseModel(
    success: true,
    hasSubmitted: false,
    isInitialQuizCompleted: false,
    questions: [
      InitialQuizQuestionModel(
        id: 1,
        questionNumber: 1,
        text: 'Apakah di lingkungan anda sudah memilah sampah?',
        type: 'single_choice',
        options: [
          InitialQuizOptionModel(
            id: 1,
            key: 'a',
            value: 'sudah',
            label: 'Sudah',
          ),
          InitialQuizOptionModel(
            id: 2,
            key: 'b',
            value: 'belum',
            label: 'Belum',
          ),
        ],
      ),
      InitialQuizQuestionModel(
        id: 5,
        questionNumber: 5,
        text: 'Ada berapa anggota aslinmas di RT anda?',
        type: 'single_choice_with_input',
        hasSubInput: true,
        subInputLabel: 'Jumlah Anggota Linmas',
        subInputType: 'number',
        subInputTriggerValue: 'ada',
        options: [
          InitialQuizOptionModel(
            id: 10,
            key: 'a',
            value: 'ada',
            label: 'Ada',
            triggersSubInput: true,
          ),
          InitialQuizOptionModel(
            id: 11,
            key: 'b',
            value: 'tidak',
            label: 'Tidak',
          ),
        ],
      ),
    ],
  );

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

  @override
  Future<InitialQuizResponseModel> getInitialQuiz() async {
    if (shouldThrow) {
      throw Exception('Server 500 error');
    }
    return fakeInitialQuiz;
  }

  @override
  Future<bool> submitInitialQuizAnswers(dynamic answers) async {
    if (shouldThrow) {
      throw Exception('Server 500 error');
    }
    submitInitialQuizCalled = true;
    submittedInitialQuizAnswers = answers;
    return true;
  }
}

class FakeSurveyLocalDatasource implements SurveyLocalDatasource {
  final Map<String, DynamicMonthlySurveyEntity> dynamicSurveys = {};
  final Map<int, InitialSurveyEntity> initialSurveys = {};

  @override
  Future<void> clearAllSurveys() async {
    dynamicSurveys.clear();
    initialSurveys.clear();
  }

  @override
  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(
    String periodKey,
  ) async {
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
  Future<InitialSurveyEntity?> getInitialSurvey(int userId) async =>
      initialSurveys[userId];

  @override
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(
    String periodKey,
  ) async {
    return dynamicSurveys[periodKey];
  }

  @override
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey) async =>
      null;

  @override
  bool isInitialSurveyCompletedSync(int userId) =>
      initialSurveys.containsKey(userId);

  @override
  Future<bool> isSurveyDismissedForPeriod(String periodKey) async => false;

  @override
  Future<bool> isSurveySubmittedForPeriod(String periodKey) async {
    return dynamicSurveys.containsKey(periodKey);
  }

  @override
  Future<void> saveDynamicMonthlySurvey(
    DynamicMonthlySurveyEntity survey,
  ) async {
    dynamicSurveys[survey.period] = survey;
  }

  @override
  Future<void> saveInitialSurvey(
    int userId,
    InitialSurveyEntity survey,
  ) async {
    initialSurveys[userId] = survey;
  }

  @override
  Future<void> saveSurvey(SurveyEntity survey) async {}

  @override
  Future<void> setInitialSurveyCompleted(int userId, bool isCompleted) async {
    if (isCompleted) {
      initialSurveys[userId] = InitialSurveyEntity(
        id: '1',
        isMemilahSampah: true,
        tujuanSampahOrganik: 'TPS',
        hasBankSampah: true,
        hasMesinPengolahOrganik: true,
        hasAslinmas: true,
        hasRonda: true,
        submittedAt: DateTime.now(),
      );
    } else {
      initialSurveys.remove(userId);
    }
  }

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
    late GetInitialQuizUsecase getInitialQuizUsecase;
    late SubmitInitialQuizUsecase submitInitialQuizUsecase;

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
      getInitialQuizUsecase = GetInitialQuizUsecase(repository);
      submitInitialQuizUsecase = SubmitInitialQuizUsecase(repository);
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

    test('getInitialQuiz in repository returns mapped domain entity', () async {
      final result = await repository.getInitialQuiz();
      expect(result, isNotNull);
      expect(result?.questions.length, equals(2));
      expect(result?.questions.first.text, contains('memilah sampah'));
      expect(result?.questions.first.options.length, equals(2));
      expect(result?.questions.last.hasSubInput, isTrue);
      expect(result?.questions.last.subInputTriggerValue, equals('ada'));
    });

    test('submitInitialQuiz in repository forwards answers and saves locally', () async {
      final answers = [
        {'question_number': 1, 'value': 'sudah'},
        {'question_number': 5, 'value': 'ada', 'sub_value': '5'},
      ];

      await repository.submitInitialQuiz(userId: 123, answers: answers);

      expect(fakeRemote.submitInitialQuizCalled, isTrue);
      expect(fakeRemote.submittedInitialQuizAnswers, equals(answers));
      expect(fakeLocal.isInitialSurveyCompletedSync(123), isTrue);

      final savedSurvey = await fakeLocal.getInitialSurvey(123);
      expect(savedSurvey?.isMemilahSampah, isTrue);
      expect(savedSurvey?.hasAslinmas, isTrue);
      expect(savedSurvey?.jumlahAnggotaAslinmas, equals(5));
    });

    test('SurveyBloc handles GetInitialQuizEvent and emits InitialQuizLoadedState', () async {
      final bloc = SurveyBloc(
        getMonthlySurveyStatusUsecase: getStatusUsecase,
        submitMonthlySurveyUsecase: submitMonthlyUsecase,
        getSurveyHistoryUsecase: getHistoryUsecase,
        getInitialQuizUsecase: getInitialQuizUsecase,
        submitInitialQuizUsecase: submitInitialQuizUsecase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SurveyLoadingState>(),
          isA<InitialQuizLoadedState>(),
        ]),
      );

      bloc.add(const GetInitialQuizEvent(userId: 123));
    });

    test('SurveyBloc emits InitialQuizAlreadyCompletedState when quiz is already submitted', () async {
      fakeRemote.fakeInitialQuiz = const InitialQuizResponseModel(
        success: true,
        hasSubmitted: true,
        isInitialQuizCompleted: true,
        questions: [],
      );

      final bloc = SurveyBloc(
        getMonthlySurveyStatusUsecase: getStatusUsecase,
        submitMonthlySurveyUsecase: submitMonthlyUsecase,
        getSurveyHistoryUsecase: getHistoryUsecase,
        getInitialQuizUsecase: getInitialQuizUsecase,
        submitInitialQuizUsecase: submitInitialQuizUsecase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SurveyLoadingState>(),
          isA<InitialQuizAlreadyCompletedState>(),
        ]),
      );

      bloc.add(const GetInitialQuizEvent(userId: 123));

      await Future.delayed(const Duration(milliseconds: 100));
      expect(fakeLocal.isInitialSurveyCompletedSync(123), isTrue);
    });

    test('SurveyBloc handles SubmitInitialQuizAnswersEvent successfully', () async {
      final bloc = SurveyBloc(
        getMonthlySurveyStatusUsecase: getStatusUsecase,
        submitMonthlySurveyUsecase: submitMonthlyUsecase,
        getSurveyHistoryUsecase: getHistoryUsecase,
        getInitialQuizUsecase: getInitialQuizUsecase,
        submitInitialQuizUsecase: submitInitialQuizUsecase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SurveySubmittingState>(),
          isA<InitialSurveySuccessState>(),
        ]),
      );

      bloc.add(
        const SubmitInitialQuizAnswersEvent(
          userId: 123,
          answers: [
            {'question_number': 1, 'value': 'sudah'},
          ],
        ),
      );

      await Future.delayed(const Duration(milliseconds: 100));
      expect(fakeRemote.submitInitialQuizCalled, isTrue);
      expect(fakeLocal.isInitialSurveyCompletedSync(123), isTrue);
    });
  });
}
