import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/linmas/activation/data/datasources/activation_pending_report_local_datasource.dart';
import 'package:akar/features/linmas/activation/data/models/pending_activation_report_model.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_mapper.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';
import 'package:akar/features/linmas/activation/domain/usecases/get_activation_runs_usecase.dart';
import 'package:akar/features/linmas/activation/domain/usecases/get_activation_submissions_usecase.dart';
import 'package:akar/features/linmas/activation/domain/usecases/submit_activation_report_usecase.dart';
import 'package:akar/utils/app_logger.dart';

part 'activation_event.dart';
part 'activation_state.dart';

class ActivationBloc extends Bloc<ActivationEvent, ActivationState> {
  final GetActivationRunsUsecase getActivationRunsUsecase;
  final GetActivationSubmissionsUsecase getActivationSubmissionsUsecase;
  final SubmitActivationReportUsecase submitActivationReportUsecase;
  final ActivationPendingReportLocalDatasource pendingReportStore;
  final AuthLocalDatasource authLocalDatasource;

  ActivationBloc({
    required this.getActivationRunsUsecase,
    required this.getActivationSubmissionsUsecase,
    required this.submitActivationReportUsecase,
    required this.pendingReportStore,
    required this.authLocalDatasource,
  }) : super(const ActivationState()) {
    on<LoadActivationActivitiesEvent>(_onLoadActivities);
    on<LoadActivationSubmissionsEvent>(_onLoadSubmissions);
    on<LoadMoreActivationActivitiesEvent>(_onLoadMoreActivities);
    on<SetActivationSearchQueryEvent>(_onSetSearchQuery);
    on<SetActivationCategoryFilterEvent>(_onSetCategoryFilter);
    on<SetActivationStatusFilterEvent>(_onSetStatusFilter);
    on<SetActivationSortOptionEvent>(_onSetSortOption);
    on<ClearActivationSearchEvent>(_onClearSearch);
    on<ResetActivationFiltersEvent>(_onResetFilters);
    on<AddActivationReportEvent>(_onAddReport);
    on<SubmitActivationReportApiEvent>(_onSubmitApiReport);
    on<SyncPendingReportsEvent>(_onSyncPendingReports);
    on<DeletePendingReportEvent>(_onDeletePendingReport);

    add(const LoadActivationActivitiesEvent());
  }

  Future<void> _onLoadActivities(
    LoadActivationActivitiesEvent event,
    Emitter<ActivationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, currentPage: 1, hasMore: true));
    final pendingReports = await _visiblePendingReports();

    final result = await getActivationRunsUsecase(page: 1, perPage: 10);
    result.fold(
      (failure) {
        AppLogger.e(
          '[ACTIVATION_BLOC] Load activities failed: ${failure.message}',
        );
        emit(
          state.copyWith(
            activities: const [],
            pendingReports: pendingReports,
            isLoading: false,
            hasMore: false,
          ),
        );
      },
      (runs) {
        final existingReports = {
          for (final activity in state.activities)
            activity.id: activity.reports,
        };
        final apiActivities = runs
            .map((run) => run.toActivity())
            .map(
              (activity) => activity.copyWith(
                reports: existingReports[activity.id] ?? const [],
              ),
            )
            .toList();
        final hasMore = runs.length >= 10;
        emit(
          state.copyWith(
            activities: apiActivities,
            pendingReports: pendingReports,
            isLoading: false,
            currentPage: 1,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  Future<void> _onLoadSubmissions(
    LoadActivationSubmissionsEvent event,
    Emitter<ActivationState> emit,
  ) async {
    emit(state.copyWith(isLoadingSubmissions: true));

    final result = await getActivationSubmissionsUsecase(
      participantId: event.participantId,
    );

    result.fold(
      (failure) {
        AppLogger.e(
          '[ACTIVATION_BLOC] Load submissions failed: ${failure.message}',
        );
        emit(state.copyWith(isLoadingSubmissions: false));
      },
      (submissions) {
        final reports = submissions.map(_toReport).toList();
        final activities = state.activities
            .map(
              (activity) => activity.id == event.participantId
                  ? activity.copyWith(reports: reports)
                  : activity,
            )
            .toList();
        emit(
          state.copyWith(activities: activities, isLoadingSubmissions: false),
        );
      },
    );
  }

  Future<void> _onLoadMoreActivities(
    LoadMoreActivationActivitiesEvent event,
    Emitter<ActivationState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await getActivationRunsUsecase(page: nextPage, perPage: 10);
    result.fold(
      (failure) {
        AppLogger.e(
          '[ACTIVATION_BLOC] Load more activities failed: ${failure.message}',
        );
        emit(state.copyWith(isLoadingMore: false));
      },
      (runs) {
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
      },
    );
  }

  Future<void> _onSubmitApiReport(
    SubmitActivationReportApiEvent event,
    Emitter<ActivationState> emit,
  ) async {
    final result = await submitActivationReportUsecase(
      participantId: event.participantId,
      attachments: event.attachments,
      notes: event.notes,
      receiverNik: event.receiverNik,
      receiverName: event.receiverName,
    );

    if (result.isLeft) {
      final failure = result.left;
      AppLogger.e(
        '[ACTIVATION_BLOC] Submit activation report failed: ${failure.message}',
      );

      // Kegagalan permanen (berkas tidak valid) tidak diantrekan.
      final retryable =
          failure is! ValidationFailure &&
          (failure.statusCode == null || failure.statusCode! >= 500);
      if (retryable && await _enqueueReport(event, emit)) {
        event.onQueued?.call();
        return;
      }

      event.onError?.call(failure.message);
      return;
    }

    final submission = result.right;
    final activities = List<ActivationActivity>.from(state.activities);
    final index = activities.indexWhere((act) => act.id == event.participantId);
    if (index != -1) {
      final old = activities[index];
      final newCompleted =
          submission.targetDone ??
          (old.completedSteps + 1).clamp(0, old.totalSteps);
      final newTotal = submission.totalTarget ?? old.totalSteps;
      final newStatus = (newCompleted >= newTotal)
          ? ActivationStatus.selesai
          : old.status;

      final updatedReports = List<ActivationReport>.from(old.reports)
        ..add(_toReport(submission));

      activities[index] = old.copyWith(
        reports: updatedReports,
        completedSteps: newCompleted,
        totalSteps: newTotal,
        status: newStatus,
      );

      emit(state.copyWith(activities: activities));
    }

    event.onSuccess?.call();
  }

  ActivationReport _toReport(ActivationSubmissionEntity submission) {
    final photos = <String>[];
    final videos = <String>[];
    for (final attachment in submission.attachments) {
      if (_isVideoAttachment(attachment.mimeType)) {
        final fileUrl = attachment.fileUrl ?? '';
        if (fileUrl.isNotEmpty) videos.add(fileUrl);
        continue;
      }
      final url = attachment.fileUrl ?? attachment.filePath ?? '';
      if (url.isNotEmpty) photos.add(url);
    }

    return ActivationReport(
      id: submission.id.toString(),
      photoUrls: photos,
      videoUrls: videos,
      submittedAt:
          DateTime.tryParse(submission.createdAt ?? '') ?? DateTime.now(),
      latitude: 0.0,
      longitude: 0.0,
      notes: submission.notes,
      recipientName: submission.receiverName,
      recipientNik: submission.receiverNik,
    );
  }

  Future<bool> _enqueueReport(
    SubmitActivationReportApiEvent event,
    Emitter<ActivationState> emit,
  ) async {
    try {
      final userId = await _currentUserId();
      if (userId == null) return false;

      final queued = await pendingReportStore.enqueue(
        userId: userId,
        participantId: event.participantId,
        activityTitle: event.activityTitle,
        attachments: event.attachments,
        notes: event.notes,
        receiverNik: event.receiverNik,
        receiverName: event.receiverName,
      );
      emit(state.copyWith(pendingReports: [...state.pendingReports, queued]));
      return true;
    } catch (e, s) {
      AppLogger.e(
        '[ACTIVATION_BLOC] Gagal menyimpan antrean laporan: $e',
        e,
        s,
      );
      return false;
    }
  }

  Future<String?> _currentUserId() async =>
      (await authLocalDatasource.getUser())?.id.toString();

  Future<List<PendingActivationReportModel>> _visiblePendingReports() async {
    final userId = await _currentUserId();
    final reports = await pendingReportStore.getPending();
    return reports.where((report) => report.belongsTo(userId)).toList();
  }

  Future<void> _onSyncPendingReports(
    SyncPendingReportsEvent event,
    Emitter<ActivationState> emit,
  ) async {
    if (state.isSyncingPending) return;

    final visible = await _visiblePendingReports();
    final pending = event.reportId == null
        ? visible
        : visible.where((report) => report.id == event.reportId).toList();
    if (pending.isEmpty) {
      emit(state.copyWith(pendingReports: visible));
      return;
    }

    emit(state.copyWith(pendingReports: visible, isSyncingPending: true));

    var uploaded = 0;
    final uploadedParticipants = <String>{};
    for (final report in pending) {
      final result = await submitActivationReportUsecase(
        participantId: report.participantId,
        attachments: report.attachmentPaths.map(File.new).toList(),
        notes: report.notes,
        receiverNik: report.receiverNik,
        receiverName: report.receiverName,
      );

      if (result.isRight) {
        await pendingReportStore.remove(report.id);
        uploaded++;
        uploadedParticipants.add(report.participantId);
      } else {
        await pendingReportStore.markError(report.id, result.left.message);
      }
    }

    emit(
      state.copyWith(
        pendingReports: await _visiblePendingReports(),
        isSyncingPending: false,
      ),
    );

    if (uploaded > 0) {
      add(const LoadActivationActivitiesEvent());
      for (final participantId in uploadedParticipants) {
        add(LoadActivationSubmissionsEvent(participantId: participantId));
      }
    }
  }

  Future<void> _onDeletePendingReport(
    DeletePendingReportEvent event,
    Emitter<ActivationState> emit,
  ) async {
    await pendingReportStore.remove(event.id);
    emit(
      state.copyWith(
        pendingReports: state.pendingReports
            .where((report) => report.id != event.id)
            .toList(),
      ),
    );
  }

  bool _isVideoAttachment(String? mimeType) =>
      (mimeType ?? '').toLowerCase().startsWith('video');

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
