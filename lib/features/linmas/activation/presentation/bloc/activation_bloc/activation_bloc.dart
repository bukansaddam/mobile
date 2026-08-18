import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:akar/features/linmas/activation/data/datasources/dummy_activation_data.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';

part 'activation_event.dart';
part 'activation_state.dart';

class ActivationBloc extends Bloc<ActivationEvent, ActivationState> {
  ActivationBloc() : super(const ActivationState()) {
    on<LoadActivationActivitiesEvent>(_onLoadActivities);
    on<SetActivationSearchQueryEvent>(_onSetSearchQuery);
    on<SetActivationCategoryFilterEvent>(_onSetCategoryFilter);
    on<SetActivationStatusFilterEvent>(_onSetStatusFilter);
    on<SetActivationSortOptionEvent>(_onSetSortOption);
    on<ClearActivationSearchEvent>(_onClearSearch);
    on<ResetActivationFiltersEvent>(_onResetFilters);
    on<AddActivationReportEvent>(_onAddReport);

    add(LoadActivationActivitiesEvent());
  }

  void _onLoadActivities(
    LoadActivationActivitiesEvent event,
    Emitter<ActivationState> emit,
  ) {
    final initialList = List<ActivationActivity>.from(
      DummyActivationData.activities
          .where(
            (act) =>
                act.status == ActivationStatus.sedangBerjalan &&
                act.reports.isEmpty,
          )
          .take(5),
    );

    emit(state.copyWith(activities: initialList));
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
