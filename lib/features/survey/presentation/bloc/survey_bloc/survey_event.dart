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
