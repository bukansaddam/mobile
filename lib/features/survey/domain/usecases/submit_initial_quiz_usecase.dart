import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class SubmitInitialQuizUsecase {
  final SurveyRepository repository;

  SubmitInitialQuizUsecase(this.repository);

  Future<void> call({
    required int userId,
    required dynamic answers,
    InitialSurveyEntity? legacySurvey,
  }) {
    return repository.submitInitialQuiz(
      userId: userId,
      answers: answers,
      legacySurvey: legacySurvey,
    );
  }
}
