import 'dart:io';

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

  CreateComplaintBloc({required CreateComplaintUsecase createComplaint})
    : _createComplaint = createComplaint,
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
    );

    result.fold((failure) {
      AppLogger.e('[COMPLAINT_BLOC] Kirim pengaduan gagal: ${failure.message}');
      emit(CreateComplaintFailure(failure.message));
    }, (report) => emit(CreateComplaintSuccess(report)));
  }
}
