import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class SubmitMonthlySurveyUsecase {
  final SurveyRepository repository;

  SubmitMonthlySurveyUsecase(this.repository);

  Future<void> call(SurveyEntity survey) {
    return repository.submitSurvey(survey);
  }
}
