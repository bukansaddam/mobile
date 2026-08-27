import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/data/datasources/survey_remote_datasource.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_mapper.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyLocalDatasource localDatasource;
  final SurveyRemoteDatasource? remoteDatasource;

  SurveyRepositoryImpl({
    required this.localDatasource,
    this.remoteDatasource,
  });

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
  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(String periodKey) {
    return localDatasource.getActiveMonthlySurveyForm(periodKey);
  }

  @override
  Future<SurveyItemEntity?> getActiveMonthlySurveyFromApi(String periodKey) async {
    if (remoteDatasource == null) return null;
    try {
      final responseModel = await remoteDatasource!.getSurveys(period: periodKey);
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
    // API submit disabled per requirement: submit is saved locally only
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
