import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyLocalDatasource localDatasource;

  SurveyRepositoryImpl({required this.localDatasource});

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
