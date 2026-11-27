import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_detail_usecase.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'jaga_tanah_detail_event.dart';
part 'jaga_tanah_detail_state.dart';

class JagaTanahDetailBloc
    extends Bloc<JagaTanahDetailEvent, JagaTanahDetailState> {
  final GetJagaTanahDetailUsecase _getReportDetail;

  JagaTanahDetailBloc({required this._getReportDetail})
    : super(const JagaTanahDetailState()) {
    on<FetchJagaTanahDetailEvent>(_onFetchDetail);
  }

  Future<void> _onFetchDetail(
    FetchJagaTanahDetailEvent event,
    Emitter<JagaTanahDetailState> emit,
  ) async {
    if (state.status == JagaTanahDetailStatus.loading || state.isRefreshing) {
      return;
    }

    final hasExisting = state.detail != null;
    if (event.isRefresh && hasExisting) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(
        state.copyWith(
          status: JagaTanahDetailStatus.loading,
          isRefreshing: false,
          clearError: true,
        ),
      );
    }

    final result = await _getReportDetail(event.id);

    result.fold(
      (failure) {
        AppLogger.e(
          '[JAGA_TANAH_DETAIL_BLOC] Gagal memuat detail: ${failure.message}',
        );
        emit(
          state.copyWith(
            status: JagaTanahDetailStatus.failure,
            isRefreshing: false,
            errorMessage: failure.message,
          ),
        );
      },
      (detail) {
        emit(
          state.copyWith(
            status: JagaTanahDetailStatus.loaded,
            detail: detail,
            isRefreshing: false,
            clearError: true,
          ),
        );
      },
    );
  }
}
