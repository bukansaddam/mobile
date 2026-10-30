import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_my_complaints_usecase.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_complaint_list_event.dart';
part 'my_complaint_list_state.dart';

class MyComplaintListBloc
    extends Bloc<MyComplaintListEvent, MyComplaintListState> {
  static const int _perPage = 15;

  final GetMyComplaintsUsecase _getMyComplaints;

  int _generation = 0;

  MyComplaintListBloc({required GetMyComplaintsUsecase getMyComplaints})
    : _getMyComplaints = getMyComplaints,
      super(const MyComplaintListState()) {
    on<FetchMyComplaintsEvent>(_onFetch);
    on<LoadMoreMyComplaintsEvent>(_onLoadMore);
  }

  Future<void> _onFetch(
    FetchMyComplaintsEvent event,
    Emitter<MyComplaintListState> emit,
  ) async {
    final generation = ++_generation;

    if (!event.isRefresh) {
      emit(state.copyWith(status: MyComplaintListStatus.loading));
    }

    final result = await _getMyComplaints(page: 1, perPage: _perPage);
    if (generation != _generation) return;

    result.fold(
      (failure) {
        AppLogger.e(
          '[COMPLAINT_LIST_BLOC] Gagal memuat pengaduan: ${failure.message}',
        );
        emit(
          state.copyWith(
            status: MyComplaintListStatus.failure,
            errorMessage: failure.message,
            isLoadingMore: false,
          ),
        );
      },
      (paginated) => emit(
        state.copyWith(
          status: MyComplaintListStatus.loaded,
          items: paginated.data,
          currentPage: paginated.currentPage,
          lastPage: paginated.lastPage,
          total: paginated.total,
          hasReachedMax: paginated.currentPage >= paginated.lastPage,
          isLoadingMore: false,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreMyComplaintsEvent event,
    Emitter<MyComplaintListState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) return;
    if (state.status != MyComplaintListStatus.loaded) return;

    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getMyComplaints(
      page: state.currentPage + 1,
      perPage: _perPage,
    );
    if (generation != _generation) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (paginated) => emit(
        state.copyWith(
          items: [...state.items, ...paginated.data],
          currentPage: paginated.currentPage,
          lastPage: paginated.lastPage,
          total: paginated.total,
          hasReachedMax: paginated.currentPage >= paginated.lastPage,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
