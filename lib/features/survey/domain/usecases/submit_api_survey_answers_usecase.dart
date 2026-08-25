import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class SubmitApiSurveyAnswersUsecase {
  final SurveyRepository repository;

  SubmitApiSurveyAnswersUsecase(this.repository);

  Future<void> call({
    required int surveyId,
    required SurveySubmitRequestEntity request,
  }) {
    return repository.submitApiSurveyAnswers(
      surveyId: surveyId,
      request: request,
    );
  }
}
