import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/domain/usecases/get_monthly_survey_status_usecase.dart';
import 'package:akar/features/survey/domain/usecases/get_survey_history_usecase.dart';
import 'package:akar/features/survey/domain/usecases/submit_monthly_survey_usecase.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final GetMonthlySurveyStatusUsecase getMonthlySurveyStatusUsecase;
  final SubmitMonthlySurveyUsecase submitMonthlySurveyUsecase;
  final GetSurveyHistoryUsecase getSurveyHistoryUsecase;

  SurveyBloc({
    required this.getMonthlySurveyStatusUsecase,
    required this.submitMonthlySurveyUsecase,
    required this.getSurveyHistoryUsecase,
  }) : super(SurveyInitialState()) {
    on<CheckSurveyStatusEvent>(_onCheckSurveyStatus);
    on<SubmitSurveyEvent>(_onSubmitSurvey);
    on<SubmitInitialSurveyEvent>(_onSubmitInitialSurvey);
    on<LoadDynamicMonthlyFormEvent>(_onLoadDynamicMonthlyForm);
    on<SubmitDynamicMonthlySurveyEvent>(_onSubmitDynamicMonthlySurvey);
    on<LoadSurveyHistoryEvent>(_onLoadSurveyHistory);
    on<DismissSurveyCardEvent>(_onDismissSurveyCard);
    on<ResetSurveyStatusEvent>(_onResetSurveyStatus);
  }

  Future<void> _onSubmitInitialSurvey(
    SubmitInitialSurveyEvent event,
    Emitter<SurveyState> emit,
  ) async {
    emit(SurveySubmittingState());
    try {
      await getMonthlySurveyStatusUsecase.repository.saveInitialSurvey(
        event.userId,
        event.survey,
      );
      emit(
        const InitialSurveySuccessState(
          message: 'Survey Baseline Profil berhasil disimpan!',
        ),
      );
    } catch (e) {
      emit(
        SurveyFailureState('Gagal menyimpan survey profil: ${e.toString()}'),
      );
    }
  }

  Future<void> _onLoadDynamicMonthlyForm(
    LoadDynamicMonthlyFormEvent event,
    Emitter<SurveyState> emit,
  ) async {
    emit(SurveyLoadingState());
    try {
      final periodKey = event.periodKey ?? SurveyEntity.getCurrentPeriodKey();
      final repository = getMonthlySurveyStatusUsecase.repository;
      final form = await repository.getActiveMonthlySurveyForm(periodKey);
      final latestSubmitted = await repository.getLatestDynamicSurveyForPeriod(
        periodKey,
      );

      emit(
        DynamicFormLoadedState(
          form: form,
          isSubmitted: latestSubmitted != null,
        ),
      );
    } catch (e) {
      emit(
        SurveyFailureState(
          'Gagal memuat survey bulanan dinamis: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSubmitDynamicMonthlySurvey(
    SubmitDynamicMonthlySurveyEvent event,
    Emitter<SurveyState> emit,
  ) async {
    emit(SurveySubmittingState());
    try {
      final repository = getMonthlySurveyStatusUsecase.repository;
      await repository.submitDynamicMonthlySurvey(event.survey);
      emit(
        const DynamicSurveySuccessState(
          message: 'Terima kasih, survey bulanan berhasil dikirim!',
        ),
      );
      final statusResult = await getMonthlySurveyStatusUsecase(
        event.survey.period,
      );
      final history = await getSurveyHistoryUsecase();
      emit(
        SurveyStatusLoadedState(
          periodKey: statusResult.periodKey,
          periodLabel: statusResult.periodLabel,
          isSubmitted: true,
          isDismissed: statusResult.isDismissed,
          history: history,
        ),
      );
    } catch (e) {
      emit(
        SurveyFailureState('Gagal mengirim survey bulanan: ${e.toString()}'),
      );
    }
  }

  Future<void> _onCheckSurveyStatus(
    CheckSurveyStatusEvent event,
    Emitter<SurveyState> emit,
  ) async {
    emit(SurveyLoadingState());
    try {
      final statusResult = await getMonthlySurveyStatusUsecase(event.periodKey);
      final history = await getSurveyHistoryUsecase();
      emit(
        SurveyStatusLoadedState(
          periodKey: statusResult.periodKey,
          periodLabel: statusResult.periodLabel,
          isSubmitted: statusResult.isSubmitted,
          isDismissed: statusResult.isDismissed,
          latestSurvey: statusResult.latestSurvey,
          history: history,
        ),
      );
    } catch (e) {
      emit(
        SurveyFailureState('Gagal memeriksa status survey: ${e.toString()}'),
      );
    }
  }

  Future<void> _onSubmitSurvey(
    SubmitSurveyEvent event,
    Emitter<SurveyState> emit,
  ) async {
    emit(SurveySubmittingState());
    try {
      await submitMonthlySurveyUsecase(event.survey);
      final history = await getSurveyHistoryUsecase();
      emit(
        SurveySuccessState(
          survey: event.survey,
          message: 'Survey Bulanan berhasil dikirim!',
        ),
      );
      // Re-trigger check status
      final statusResult = await getMonthlySurveyStatusUsecase(
        event.survey.period,
      );
      emit(
        SurveyStatusLoadedState(
          periodKey: statusResult.periodKey,
          periodLabel: statusResult.periodLabel,
          isSubmitted: true,
          isDismissed: statusResult.isDismissed,
          latestSurvey: event.survey,
          history: history,
        ),
      );
    } catch (e) {
      emit(SurveyFailureState('Gagal mengirim survey: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSurveyHistory(
    LoadSurveyHistoryEvent event,
    Emitter<SurveyState> emit,
  ) async {
    try {
      final history = await getSurveyHistoryUsecase();
      final statusResult = await getMonthlySurveyStatusUsecase();
      emit(
        SurveyStatusLoadedState(
          periodKey: statusResult.periodKey,
          periodLabel: statusResult.periodLabel,
          isSubmitted: statusResult.isSubmitted,
          isDismissed: statusResult.isDismissed,
          latestSurvey: statusResult.latestSurvey,
          history: history,
        ),
      );
    } catch (e) {
      emit(SurveyFailureState('Gagal memuat riwayat survey: ${e.toString()}'));
    }
  }

  Future<void> _onDismissSurveyCard(
    DismissSurveyCardEvent event,
    Emitter<SurveyState> emit,
  ) async {
    try {
      final statusResult = await getMonthlySurveyStatusUsecase(event.periodKey);
      await getMonthlySurveyStatusUsecase.repository
          .setSurveyDismissedForPeriod(statusResult.periodKey);
      final updatedStatus = await getMonthlySurveyStatusUsecase(
        statusResult.periodKey,
      );
      final history = await getSurveyHistoryUsecase();
      emit(
        SurveyStatusLoadedState(
          periodKey: updatedStatus.periodKey,
          periodLabel: updatedStatus.periodLabel,
          isSubmitted: updatedStatus.isSubmitted,
          isDismissed: updatedStatus.isDismissed,
          latestSurvey: updatedStatus.latestSurvey,
          history: history,
        ),
      );
    } catch (_) {}
  }

  Future<void> _onResetSurveyStatus(
    ResetSurveyStatusEvent event,
    Emitter<SurveyState> emit,
  ) async {
    try {
      await getMonthlySurveyStatusUsecase.repository.clearAllSurveys();
      final statusResult = await getMonthlySurveyStatusUsecase();
      emit(
        SurveyStatusLoadedState(
          periodKey: statusResult.periodKey,
          periodLabel: statusResult.periodLabel,
          isSubmitted: false,
          isDismissed: false,
          latestSurvey: null,
          history: const [],
        ),
      );
    } catch (_) {}
  }
}
