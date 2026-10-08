import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/data/datasources/survey_remote_datasource.dart';
import 'package:akar/features/survey/data/models/initial_quiz_model.dart';
import 'package:akar/features/survey/domain/entities/initial_quiz_entity.dart';
import 'package:akar/features/survey/domain/entities/initial_quiz_mapper.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_mapper.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyLocalDatasource localDatasource;
  final SurveyRemoteDatasource? remoteDatasource;

  SurveyRepositoryImpl({required this.localDatasource, this.remoteDatasource});

  @override
  bool isInitialSurveyCompletedSync(int userId) {
    return localDatasource.isInitialSurveyCompletedSync(userId);
  }

  @override
  Future<void> saveInitialSurvey(int userId, InitialSurveyEntity survey) {
    return localDatasource.saveInitialSurvey(userId, survey);
  }

  @override
  Future<InitialSurveyEntity?> getInitialSurvey(int userId) {
    return localDatasource.getInitialSurvey(userId);
  }

  @override
  Future<InitialQuizResponseEntity?> getInitialQuiz() async {
    if (remoteDatasource == null) return null;
    final responseModel = await remoteDatasource!.getInitialQuiz();
    return responseModel.toDomain();
  }

  @override
  Future<void> submitInitialQuiz({
    required int userId,
    required dynamic answers,
    InitialSurveyEntity? legacySurvey,
  }) async {
    if (remoteDatasource != null) {
      await remoteDatasource!.submitInitialQuizAnswers(answers);
    }

    String? getValue(int qNum) {
      if (answers is List) {
        for (final item in answers) {
          if (item is Map &&
              (item['question_number'] == qNum ||
                  item['question_number'] == '$qNum')) {
            return item['value']?.toString();
          } else if (item is InitialQuizAnswerItemModel &&
              item.questionNumber == qNum) {
            return item.value;
          }
        }
      } else if (answers is Map) {
        if (answers.containsKey('answers') && answers['answers'] is List) {
          for (final item in answers['answers'] as List) {
            if (item is Map &&
                (item['question_number'] == qNum ||
                    item['question_number'] == '$qNum')) {
              return item['value']?.toString();
            } else if (item is InitialQuizAnswerItemModel &&
                item.questionNumber == qNum) {
              return item.value;
            }
          }
        }
        final val = answers['$qNum'] ?? answers[qNum];
        if (val is Map) return val['value']?.toString();
        return val?.toString();
      } else if (answers is InitialQuizSubmitRequestModel) {
        for (final item in answers.answers) {
          if (item.questionNumber == qNum) return item.value;
        }
      }
      return null;
    }

    String? getSubValue(int qNum) {
      if (answers is List) {
        for (final item in answers) {
          if (item is Map &&
              (item['question_number'] == qNum ||
                  item['question_number'] == '$qNum')) {
            return item['sub_value']?.toString();
          } else if (item is InitialQuizAnswerItemModel &&
              item.questionNumber == qNum) {
            return item.subValue;
          }
        }
      } else if (answers is Map) {
        if (answers.containsKey('answers') && answers['answers'] is List) {
          for (final item in answers['answers'] as List) {
            if (item is Map &&
                (item['question_number'] == qNum ||
                    item['question_number'] == '$qNum')) {
              return item['sub_value']?.toString();
            } else if (item is InitialQuizAnswerItemModel &&
                item.questionNumber == qNum) {
              return item.subValue;
            }
          }
        }
        final val = answers['$qNum'] ?? answers[qNum];
        if (val is Map) return val['sub_value']?.toString();
      } else if (answers is InitialQuizSubmitRequestModel) {
        for (final item in answers.answers) {
          if (item.questionNumber == qNum) return item.subValue;
        }
      }
      return null;
    }

    final q1 = getValue(1);
    final q2 = getValue(2);
    final q3 = getValue(3);
    final q4 = getValue(4);
    final q5 = getValue(5);
    final q5Sub = getSubValue(5);
    final q6 = getValue(6);

    final surveyToSave =
        legacySurvey ??
        InitialSurveyEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isMemilahSampah: q1?.toLowerCase() == 'sudah',
          tujuanSampahOrganik: q2 ?? 'TPS',
          hasBankSampah: q3?.toLowerCase() == 'sudah',
          hasMesinPengolahOrganik: q4?.toLowerCase() == 'sudah',
          hasAslinmas: q5?.toLowerCase() == 'ada',
          jumlahAnggotaAslinmas: int.tryParse(q5Sub ?? ''),
          hasRonda: q6?.toLowerCase() == 'ada',
          submittedAt: DateTime.now(),
        );
    await localDatasource.saveInitialSurvey(userId, surveyToSave);
  }

  @override
  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(String periodKey) {
    return localDatasource.getActiveMonthlySurveyForm(periodKey);
  }

  @override
  Future<SurveyItemEntity?> getActiveMonthlySurveyFromApi(
    String periodKey,
  ) async {
    if (remoteDatasource == null) return null;
    try {
      final responseModel = await remoteDatasource!.getSurveys(
        period: periodKey,
      );
      final domainItems = responseModel.data.map((m) => m.toDomain()).toList();

      // Ambil data yang periodnya sama seperti bulan ini saja
      for (final item in domainItems) {
        if (item.period == periodKey) {
          return item;
        }
      }

      if (domainItems.isNotEmpty) {
        return domainItems.first;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> submitApiSurveyAnswers({
    required int surveyId,
    required SurveySubmitRequestEntity request,
  }) async {
    if (remoteDatasource != null) {
      await remoteDatasource!.submitSurveyAnswers(
        surveyId: surveyId,
        request: request.toModel(),
      );
    }
  }

  @override
  Future<void> submitDynamicMonthlySurvey(DynamicMonthlySurveyEntity survey) {
    return localDatasource.saveDynamicMonthlySurvey(survey);
  }

  @override
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(
    String periodKey,
  ) {
    return localDatasource.getLatestDynamicSurveyForPeriod(periodKey);
  }

  @override
  Future<List<SurveyEntity>> getAllSurveyHistory() {
    return localDatasource.getAllSurveyHistory();
  }

  @override
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey) {
    return localDatasource.getLatestSurveyForPeriod(periodKey);
  }

  @override
  Future<bool> isSurveySubmittedForPeriod(String periodKey) {
    return localDatasource.isSurveySubmittedForPeriod(periodKey);
  }

  @override
  Future<bool> isSurveyDismissedForPeriod(String periodKey) {
    return localDatasource.isSurveyDismissedForPeriod(periodKey);
  }

  @override
  Future<void> setSurveyDismissedForPeriod(String periodKey) {
    return localDatasource.setSurveyDismissedForPeriod(periodKey);
  }

  @override
  Future<void> submitSurvey(SurveyEntity survey) {
    return localDatasource.saveSurvey(survey);
  }

  @override
  Future<void> clearAllSurveys() {
    return localDatasource.clearAllSurveys();
  }
}
