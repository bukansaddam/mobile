import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyLocalDatasource localDatasource;

  SurveyRepositoryImpl({required this.localDatasource});

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
