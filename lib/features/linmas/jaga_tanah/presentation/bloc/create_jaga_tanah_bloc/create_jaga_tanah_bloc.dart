import 'dart:io';

import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/create_jaga_tanah_report_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_jaga_tanah_event.dart';
part 'create_jaga_tanah_state.dart';

class CreateJagaTanahBloc
    extends Bloc<CreateJagaTanahEvent, CreateJagaTanahState> {
  final CreateJagaTanahReportUsecase _createReport;
  final GetJagaTanahCategoriesUsecase _getCategories;
  final OfflineQueueLocalDatasource? _offlineQueue;
  final AuthLocalDatasource? _authLocalDatasource;

  CreateJagaTanahBloc({
    required CreateJagaTanahReportUsecase createReport,
    required GetJagaTanahCategoriesUsecase getCategories,
    OfflineQueueLocalDatasource? offlineQueue,
    AuthLocalDatasource? authLocalDatasource,
  }) : _createReport = createReport,
       _getCategories = getCategories,
       _offlineQueue = offlineQueue,
       _authLocalDatasource = authLocalDatasource,
       super(const CreateJagaTanahState()) {
    on<LoadJagaTanahCategoriesEvent>(_onLoadCategories);
    on<SubmitJagaTanahReportEvent>(_onSubmit);
  }

  Future<void> _onLoadCategories(
    LoadJagaTanahCategoriesEvent event,
    Emitter<CreateJagaTanahState> emit,
  ) async {
    if (state.isLoadingCategories) return;
    if (!event.force && state.categories.isNotEmpty) return;

    emit(state.copyWith(isLoadingCategories: true, clearCategoryError: true));

    final result = await _getCategories();
    result.fold(
      (failure) {
        AppLogger.e(
          '[CREATE_JAGA_TANAH_BLOC] Gagal memuat kategori: ${failure.message}',
        );
        emit(
          state.copyWith(
            isLoadingCategories: false,
            categoryError: failure.message,
          ),
        );
      },
      (categories) => emit(
        state.copyWith(
          isLoadingCategories: false,
          categories: List<JagaTanahCategoryEntity>.unmodifiable(categories),
          clearCategoryError: true,
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    SubmitJagaTanahReportEvent event,
    Emitter<CreateJagaTanahState> emit,
  ) async {
    if (state.isSubmitting) return;

    emit(
      state.copyWith(
        submitStatus: CreateJagaTanahSubmitStatus.submitting,
        clearSubmitError: true,
      ),
    );

    final result = await _createReport(
      title: event.title,
      description: event.description,
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
      attachments: event.attachments,
      categoryId: event.categoryId,
      subCategoryId: event.subCategoryId,
      type: event.type,
      locationAccess: event.locationAccess,
      fieldCondition: event.fieldCondition,
      dominantLandCover: event.dominantLandCover,
      visibleUsage: event.visibleUsage,
      usageLevel: event.usageLevel,
      maintenanceStatus: event.maintenanceStatus,
      conditionInfoSource: event.conditionInfoSource,
      tenureInfoSource: event.tenureInfoSource,
      possessionMarkers: event.possessionMarkers,
      conflictInfo: event.conflictInfo,
      boundaryGeojson: event.boundaryGeojson,
      estimatedArea: event.estimatedArea,
      idempotencyKey: event.idempotencyKey,
    );

    await result.fold(
      (failure) async {
        if (failure.isRetryable && _offlineQueue != null) {
          try {
            final userId = _authLocalDatasource?.getCachedUserId() ?? '';
            final payload = {
              'title': event.title,
              'description': event.description,
              'address': event.address,
              'latitude': event.latitude,
              'longitude': event.longitude,
              'category_id': event.categoryId,
              'sub_category_id': event.subCategoryId,
              'type': event.type,
              'location_access': event.locationAccess,
              'field_condition': event.fieldCondition,
              'dominant_land_cover': event.dominantLandCover,
              'visible_usage': event.visibleUsage,
              'usage_level': event.usageLevel,
              'maintenance_status': event.maintenanceStatus,
              'condition_info_source': event.conditionInfoSource,
              'tenure_info_source': event.tenureInfoSource,
              'possession_markers': event.possessionMarkers,
              'conflict_info': event.conflictInfo,
              if (event.boundaryGeojson != null)
                'boundary_geojson': event.boundaryGeojson,
              if (event.estimatedArea != null)
                'estimated_area': event.estimatedArea,
            };

            await _offlineQueue.enqueue(
              userId: userId,
              featureType: OfflineFeatureType.jagaTanah,
              payload: payload,
              attachments: event.attachments,
              clientRequestId: event.idempotencyKey,
            );

            AppLogger.i(
              '[CREATE_JAGA_TANAH_BLOC] Laporan disimpan ke antrean offline',
            );
            emit(
              state.copyWith(
                submitStatus: CreateJagaTanahSubmitStatus.success,
                isQueuedOffline: true,
                clearSubmitError: true,
              ),
            );
            return;
          } catch (e) {
            AppLogger.e('[CREATE_JAGA_TANAH_BLOC] Gagal antrekan offline: $e');
          }
        }

        AppLogger.e(
          '[CREATE_JAGA_TANAH_BLOC] Kirim laporan gagal: ${failure.message}',
        );
        emit(
          state.copyWith(
            submitStatus: CreateJagaTanahSubmitStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (report) async => emit(
        state.copyWith(
          submitStatus: CreateJagaTanahSubmitStatus.success,
          submittedReport: report,
          clearSubmitError: true,
        ),
      ),
    );
  }
}
