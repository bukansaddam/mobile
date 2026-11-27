import 'package:akar/features/survey/domain/entities/initial_quiz_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object?> get props => const [];
}

class SurveyInitialState extends SurveyState {
  const SurveyInitialState();
}

class SurveyLoadingState extends SurveyState {
  const SurveyLoadingState();
}

class InitialQuizLoadedState extends SurveyState {
  final InitialQuizResponseEntity quiz;

  const InitialQuizLoadedState({required this.quiz});

  @override
  List<Object?> get props => [quiz];
}

class InitialQuizAlreadyCompletedState extends SurveyState {
  final String message;

  const InitialQuizAlreadyCompletedState({
    this.message = 'Survey profil sudah pernah diisi.',
  });

  @override
  List<Object?> get props => [message];
}

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

  @override
  List<Object?> get props => [
    periodKey,
    periodLabel,
    isSubmitted,
    isDismissed,
    latestSurvey,
    history,
  ];
}

class DynamicFormLoadedState extends SurveyState {
  final MonthlySurveyFormEntity form;
  final bool isSubmitted;

  const DynamicFormLoadedState({required this.form, required this.isSubmitted});

  @override
  List<Object?> get props => [form, isSubmitted];
}

class ApiSurveyLoadedState extends SurveyState {
  final SurveyItemEntity survey;
  final bool isSubmitted;

  const ApiSurveyLoadedState({required this.survey, required this.isSubmitted});

  @override
  List<Object?> get props => [survey, isSubmitted];
}

class SurveySubmittingState extends SurveyState {
  const SurveySubmittingState();
}

class SurveySuccessState extends SurveyState {
  final SurveyEntity survey;
  final String message;

  const SurveySuccessState({required this.survey, required this.message});

  @override
  List<Object?> get props => [survey, message];
}

class InitialSurveySuccessState extends SurveyState {
  final String message;

  const InitialSurveySuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class DynamicSurveySuccessState extends SurveyState {
  final String message;

  const DynamicSurveySuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SurveyFailureState extends SurveyState {
  final String errorMessage;

  const SurveyFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
