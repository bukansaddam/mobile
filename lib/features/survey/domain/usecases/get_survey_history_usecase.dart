import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class GetSurveyHistoryUsecase {
  final SurveyRepository repository;

  GetSurveyHistoryUsecase(this.repository);

  Future<List<SurveyEntity>> call() {
    return repository.getAllSurveyHistory();
  }
}
