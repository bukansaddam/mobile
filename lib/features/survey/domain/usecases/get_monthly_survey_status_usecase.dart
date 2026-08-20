import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';

class GetMonthlySurveyStatusUsecase {
  final SurveyRepository repository;

  GetMonthlySurveyStatusUsecase(this.repository);

  Future<SurveyStatusResult> call([String? periodKey]) async {
    final key = periodKey ?? SurveyEntity.getCurrentPeriodKey();
    final isSubmitted = await repository.isSurveySubmittedForPeriod(key);
    final isDismissed = await repository.isSurveyDismissedForPeriod(key);
    final survey = await repository.getLatestSurveyForPeriod(key);
    return SurveyStatusResult(
      periodKey: key,
      periodLabel: SurveyEntity.getCurrentPeriodLabel(),
      isSubmitted: isSubmitted,
      isDismissed: isDismissed,
      latestSurvey: survey,
    );
  }
}

class SurveyStatusResult {
  final String periodKey;
  final String periodLabel;
  final bool isSubmitted;
  final bool isDismissed;
  final SurveyEntity? latestSurvey;

  SurveyStatusResult({
    required this.periodKey,
    required this.periodLabel,
    required this.isSubmitted,
    this.isDismissed = false,
    this.latestSurvey,
  });
}
