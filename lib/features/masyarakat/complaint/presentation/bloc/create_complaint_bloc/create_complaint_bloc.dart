import 'dart:io';

import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/create_complaint_usecase.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_complaint_event.dart';
part 'create_complaint_state.dart';

class CreateComplaintBloc
    extends Bloc<CreateComplaintEvent, CreateComplaintState> {
  final CreateComplaintUsecase _createComplaint;
  final OfflineQueueLocalDatasource? _offlineQueue;
  final AuthLocalDatasource? _authLocalDatasource;

  CreateComplaintBloc({
    required CreateComplaintUsecase createComplaint,
    OfflineQueueLocalDatasource? offlineQueue,
    AuthLocalDatasource? authLocalDatasource,
  }) : _createComplaint = createComplaint,
       _offlineQueue = offlineQueue,
       _authLocalDatasource = authLocalDatasource,
       super(const CreateComplaintInitial()) {
    on<SubmitComplaintEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitComplaintEvent event,
    Emitter<CreateComplaintState> emit,
  ) async {
    if (state is CreateComplaintSubmitting) return;

    emit(const CreateComplaintSubmitting());

    final result = await _createComplaint(
      title: event.title,
      description: event.description,
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
      attachments: event.attachments,
      category: event.category,
      categoryId: event.categoryId,
      isInsidentil: event.isInsidentil,
    );

    await result.fold((failure) async {
      if (failure.isRetryable && _offlineQueue != null) {
        try {
          final userId = _authLocalDatasource?.getCachedUserId() ?? 'anonymous';
          final payload = <String, dynamic>{
            'title': event.title,
            'description': event.description,
            'address': event.address,
            'latitude': event.latitude,
            'longitude': event.longitude,
            'category': event.category,
            'category_id': event.categoryId,
            'is_insidentil': event.isInsidentil,
          };

          await _offlineQueue.enqueue(
            userId: userId,
            featureType: OfflineFeatureType.complaint,
            payload: payload,
            attachments: event.attachments,
          );

          AppLogger.i('[COMPLAINT_BLOC] Pengaduan disimpan ke antrean offline');
          emit(CreateComplaintQueuedOffline(title: event.title));
          return;
        } catch (e) {
          AppLogger.e('[COMPLAINT_BLOC] Gagal antrekan offline: $e');
        }
      }

      AppLogger.e('[COMPLAINT_BLOC] Kirim pengaduan gagal: ${failure.message}');
      emit(CreateComplaintFailure(failure.message));
    }, (report) async => emit(CreateComplaintSuccess(report)));
  }
}
