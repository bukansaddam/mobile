import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object?> get props => const [];
}

class CheckSurveyStatusEvent extends SurveyEvent {
  final String? periodKey;

  const CheckSurveyStatusEvent({this.periodKey});

  @override
  List<Object?> get props => [periodKey];
}

class SubmitSurveyEvent extends SurveyEvent {
  final SurveyEntity survey;

  const SubmitSurveyEvent(this.survey);

  @override
  List<Object?> get props => [survey];
}

class SubmitInitialSurveyEvent extends SurveyEvent {
  final int userId;
  final InitialSurveyEntity survey;

  const SubmitInitialSurveyEvent({required this.userId, required this.survey});

  @override
  List<Object?> get props => [userId, survey];
}

class GetInitialQuizEvent extends SurveyEvent {
  final int? userId;

  const GetInitialQuizEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class SubmitInitialQuizAnswersEvent extends SurveyEvent {
  final int userId;
  final dynamic answers;
  final InitialSurveyEntity? legacySurvey;

  const SubmitInitialQuizAnswersEvent({
    required this.userId,
    required this.answers,
    this.legacySurvey,
  });

  @override
  List<Object?> get props => [userId, answers, legacySurvey];
}

class LoadDynamicMonthlyFormEvent extends SurveyEvent {
  final String? periodKey;

  const LoadDynamicMonthlyFormEvent({this.periodKey});

  @override
  List<Object?> get props => [periodKey];
}

class SubmitDynamicMonthlySurveyEvent extends SurveyEvent {
  final DynamicMonthlySurveyEntity survey;

  const SubmitDynamicMonthlySurveyEvent(this.survey);

  @override
  List<Object?> get props => [survey];
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

  @override
  List<Object?> get props => [surveyId, periodKey, request];
}

class LoadSurveyHistoryEvent extends SurveyEvent {
  const LoadSurveyHistoryEvent();
}

class DismissSurveyCardEvent extends SurveyEvent {
  final String? periodKey;

  const DismissSurveyCardEvent({this.periodKey});

  @override
  List<Object?> get props => [periodKey];
}

class ResetSurveyStatusEvent extends SurveyEvent {
  const ResetSurveyStatusEvent();
}
