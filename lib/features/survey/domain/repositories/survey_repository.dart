import 'package:akar/features/survey/domain/entities/survey_entity.dart';

abstract class SurveyRepository {
  Future<bool> isSurveySubmittedForPeriod(String periodKey);
  Future<bool> isSurveyDismissedForPeriod(String periodKey);
  Future<void> setSurveyDismissedForPeriod(String periodKey);
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey);
  Future<List<SurveyEntity>> getAllSurveyHistory();
  Future<void> submitSurvey(SurveyEntity survey);
  Future<void> clearAllSurveys();
}
