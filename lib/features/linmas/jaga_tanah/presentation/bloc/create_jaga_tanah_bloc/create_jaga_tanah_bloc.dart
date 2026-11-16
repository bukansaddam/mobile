import 'dart:io';

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

  CreateJagaTanahBloc({
    required CreateJagaTanahReportUsecase createReport,
    required GetJagaTanahCategoriesUsecase getCategories,
  }) : _createReport = createReport,
       _getCategories = getCategories,
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
    );

    result.fold(
      (failure) {
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
      (report) => emit(
        state.copyWith(
          submitStatus: CreateJagaTanahSubmitStatus.success,
          submittedReport: report,
          clearSubmitError: true,
        ),
      ),
    );
  }
}
