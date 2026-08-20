import 'package:akar/features/survey/domain/entities/survey_entity.dart';

abstract class SurveyState {
  const SurveyState();
}

class SurveyInitialState extends SurveyState {}

class SurveyLoadingState extends SurveyState {}

class SurveyStatusLoadedState extends SurveyState {
  final String periodKey;
  final String periodLabel;
  final bool isSubmitted;
  final bool isDismissed;
  final SurveyEntity? latestSurvey;
  final List<SurveyEntity> history;

  const SurveyStatusLoadedState({
    required this.periodKey,
    required this.periodLabel,
    required this.isSubmitted,
    this.isDismissed = false,
    this.latestSurvey,
    this.history = const [],
  });
}

class SurveySubmittingState extends SurveyState {}

class SurveySuccessState extends SurveyState {
  final SurveyEntity survey;
  final String message;

  const SurveySuccessState({required this.survey, required this.message});
}

class SurveyFailureState extends SurveyState {
  final String errorMessage;

  const SurveyFailureState(this.errorMessage);
}
