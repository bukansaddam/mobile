import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';

abstract class SurveyEvent {
  const SurveyEvent();
}

class CheckSurveyStatusEvent extends SurveyEvent {
  final String? periodKey;

  const CheckSurveyStatusEvent({this.periodKey});
}

class SubmitSurveyEvent extends SurveyEvent {
  final SurveyEntity survey;

  const SubmitSurveyEvent(this.survey);
}

class SubmitInitialSurveyEvent extends SurveyEvent {
  final int userId;
  final InitialSurveyEntity survey;

  const SubmitInitialSurveyEvent({required this.userId, required this.survey});
}

class LoadDynamicMonthlyFormEvent extends SurveyEvent {
  final String? periodKey;

  const LoadDynamicMonthlyFormEvent({this.periodKey});
}

class SubmitDynamicMonthlySurveyEvent extends SurveyEvent {
  final DynamicMonthlySurveyEntity survey;

  const SubmitDynamicMonthlySurveyEvent(this.survey);
}

class SubmitApiSurveyAnswersEvent extends SurveyEvent {
  final int surveyId;
  final String periodKey;
  final SurveySubmitRequestEntity request;

  const SubmitApiSurveyAnswersEvent({
    required this.surveyId,
    required this.periodKey,
    required this.request,
  });
}

class LoadSurveyHistoryEvent extends SurveyEvent {
  const LoadSurveyHistoryEvent();
}

class DismissSurveyCardEvent extends SurveyEvent {
  final String? periodKey;

  const DismissSurveyCardEvent({this.periodKey});
}

class ResetSurveyStatusEvent extends SurveyEvent {
  const ResetSurveyStatusEvent();
}
