import 'dart:io';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_mapper.dart';
import 'package:akar/features/linmas/activation/domain/usecases/get_activation_runs_usecase.dart';
import 'package:akar/features/linmas/activation/domain/usecases/submit_activation_report_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'activation_event.dart';
part 'activation_state.dart';

class ActivationBloc extends Bloc<ActivationEvent, ActivationState> {
  final GetActivationRunsUsecase? getActivationRunsUsecase;
  final SubmitActivationReportUsecase? submitActivationReportUsecase;

  ActivationBloc({
    this.getActivationRunsUsecase,
    this.submitActivationReportUsecase,
  }) : super(const ActivationState()) {
    on<LoadActivationActivitiesEvent>(_onLoadActivities);
    on<LoadMoreActivationActivitiesEvent>(_onLoadMoreActivities);
    on<SetActivationSearchQueryEvent>(_onSetSearchQuery);
    on<SetActivationCategoryFilterEvent>(_onSetCategoryFilter);
    on<SetActivationStatusFilterEvent>(_onSetStatusFilter);
    on<SetActivationSortOptionEvent>(_onSetSortOption);
    on<ClearActivationSearchEvent>(_onClearSearch);
    on<ResetActivationFiltersEvent>(_onResetFilters);
    on<AddActivationReportEvent>(_onAddReport);
    on<SubmitActivationReportApiEvent>(_onSubmitApiReport);

    add(const LoadActivationActivitiesEvent());
  }

  Future<void> _onLoadActivities(
    LoadActivationActivitiesEvent event,
    Emitter<ActivationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, currentPage: 1, hasMore: true));

    if (getActivationRunsUsecase != null) {
      try {
        final runs = await getActivationRunsUsecase!(page: 1, perPage: 10);
        final apiActivities = runs.map((run) => run.toActivity()).toList();
        final hasMore = runs.length >= 10;
        emit(
          state.copyWith(
            activities: apiActivities,
            isLoading: false,
            currentPage: 1,
            hasMore: hasMore,
          ),
        );
        return;
      } catch (_) {}
    }

    emit(state.copyWith(activities: const [], isLoading: false, hasMore: false));
  }

  Future<void> _onLoadMoreActivities(
    LoadMoreActivationActivitiesEvent event,
    Emitter<ActivationState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    if (getActivationRunsUsecase == null) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final runs = await getActivationRunsUsecase!(page: nextPage, perPage: 10);
      final newActivities = runs.map((run) => run.toActivity()).toList();
      final hasMore = runs.length >= 10;

      final updatedList = List<ActivationActivity>.from(state.activities)
        ..addAll(newActivities);

      emit(
        state.copyWith(
          activities: updatedList,
          currentPage: nextPage,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSubmitApiReport(
    SubmitActivationReportApiEvent event,
    Emitter<ActivationState> emit,
  ) async {
    if (submitActivationReportUsecase != null) {
      try {
        final result = await submitActivationReportUsecase!(
          participantId: event.participantId,
          file: event.file,
          notes: event.notes,
          receiverNik: event.receiverNik,
          receiverName: event.receiverName,
        );

        // Update local activity progress & reports
        final activities = List<ActivationActivity>.from(state.activities);
        final index =
            activities.indexWhere((act) => act.id == event.participantId);
        if (index != -1) {
          final old = activities[index];
          final newCompleted =
              result.targetDone ?? (old.completedSteps + 1).clamp(0, old.totalSteps);
          final newTotal = result.totalTarget ?? old.totalSteps;
          final newStatus = (newCompleted >= newTotal)
              ? ActivationStatus.selesai
              : old.status;

          final newReport = ActivationReport(
            id: result.id.toString(),
            photoUrls: result.attachments
                .map((a) => a.fileUrl ?? a.filePath ?? '')
                .where((u) => u.isNotEmpty)
                .toList(),
            submittedAt: DateTime.now(),
            latitude: 0.0,
            longitude: 0.0,
            notes: result.notes,
            recipientName: result.receiverName,
            recipientNik: result.receiverNik,
          );

          final updatedReports = List<ActivationReport>.from(old.reports)
            ..add(newReport);

          activities[index] = old.copyWith(
            reports: updatedReports,
            completedSteps: newCompleted,
            totalSteps: newTotal,
            status: newStatus,
          );

          emit(state.copyWith(activities: activities));
        }

        event.onSuccess?.call();
        return;
      } catch (e) {
        event.onError?.call(e.toString().replaceAll('Exception: ', ''));
      }
    } else {
      event.onSuccess?.call();
    }
  }

  void _onSetSearchQuery(
    SetActivationSearchQueryEvent event,
    Emitter<ActivationState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSetCategoryFilter(
    SetActivationCategoryFilterEvent event,
    Emitter<ActivationState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCategoryFilter: event.category,
        clearCategory: event.category == null,
      ),
    );
  }

  void _onSetStatusFilter(
    SetActivationStatusFilterEvent event,
    Emitter<ActivationState> emit,
  ) {
    emit(
      state.copyWith(
        selectedStatusFilter: event.status,
        clearStatus: event.status == null,
      ),
    );
  }

  void _onSetSortOption(
    SetActivationSortOptionEvent event,
    Emitter<ActivationState> emit,
  ) {
    emit(state.copyWith(selectedSortOption: event.sortOption));
  }

  void _onClearSearch(
    ClearActivationSearchEvent event,
    Emitter<ActivationState> emit,
  ) {
    emit(state.copyWith(searchQuery: ''));
  }

  void _onResetFilters(
    ResetActivationFiltersEvent event,
    Emitter<ActivationState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: '',
        clearCategory: true,
        clearStatus: true,
        selectedSortOption: ActivationSortOption.deadlineTerdekat,
      ),
    );
  }

  void _onAddReport(
    AddActivationReportEvent event,
    Emitter<ActivationState> emit,
  ) {
    final activities = List<ActivationActivity>.from(state.activities);
    final index = activities.indexWhere((act) => act.id == event.activityId);
    if (index != -1) {
      final old = activities[index];
      final updatedReports = List<ActivationReport>.from(old.reports)
        ..add(event.report);
      final newCompleted = (old.completedSteps + 1).clamp(0, old.totalSteps);
      final newStatus = (newCompleted >= old.totalSteps)
          ? ActivationStatus.selesai
          : (old.status == ActivationStatus.terjadwal
                ? ActivationStatus.sedangBerjalan
                : old.status);

      activities[index] = old.copyWith(
        reports: updatedReports,
        completedSteps: newCompleted,
        status: newStatus,
      );

      emit(state.copyWith(activities: activities));
    }
  }
}
