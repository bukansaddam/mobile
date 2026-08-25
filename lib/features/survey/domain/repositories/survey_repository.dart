import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';

abstract class SurveyRepository {
  bool isInitialSurveyCompletedSync(int userId);
  Future<void> saveInitialSurvey(int userId, InitialSurveyEntity survey);
  Future<InitialSurveyEntity?> getInitialSurvey(int userId);

  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(String periodKey);
  Future<SurveyItemEntity?> getActiveMonthlySurveyFromApi(String periodKey);

  Future<void> submitApiSurveyAnswers({
    required int surveyId,
    required SurveySubmitRequestEntity request,
  });

  Future<void> submitDynamicMonthlySurvey(DynamicMonthlySurveyEntity survey);
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(
    String periodKey,
  );

  Future<bool> isSurveySubmittedForPeriod(String periodKey);
  Future<bool> isSurveyDismissedForPeriod(String periodKey);
  Future<void> setSurveyDismissedForPeriod(String periodKey);
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey);
  Future<List<SurveyEntity>> getAllSurveyHistory();
  Future<void> submitSurvey(SurveyEntity survey);
  Future<void> clearAllSurveys();
}
