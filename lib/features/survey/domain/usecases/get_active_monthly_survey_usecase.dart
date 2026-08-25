import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class GetActiveMonthlySurveyUsecase {
  final SurveyRepository repository;

  GetActiveMonthlySurveyUsecase(this.repository);

  Future<SurveyItemEntity?> call(String periodKey) {
    return repository.getActiveMonthlySurveyFromApi(periodKey);
  }
}
