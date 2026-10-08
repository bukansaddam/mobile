import 'package:akar/features/survey/domain/entities/initial_quiz_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class GetInitialQuizUsecase {
  final SurveyRepository repository;

  GetInitialQuizUsecase(this.repository);

  Future<InitialQuizResponseEntity?> call() {
    return repository.getInitialQuiz();
  }
}
