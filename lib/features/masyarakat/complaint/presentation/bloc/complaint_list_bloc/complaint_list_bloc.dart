import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_public_complaints_usecase.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'complaint_list_event.dart';
part 'complaint_list_state.dart';

class ComplaintListBloc extends Bloc<ComplaintListEvent, ComplaintListState> {
  static const int _perPage = 15;

  final GetPublicComplaintsUsecase _getComplaints;

  int _generation = 0;
  String? _status;
  String? _category;
  String? _query;

  ComplaintListBloc({required GetPublicComplaintsUsecase getComplaints})
    : _getComplaints = getComplaints,
      super(const ComplaintListState()) {
    on<FetchComplaintsEvent>(_onFetch);
    on<LoadMoreComplaintsEvent>(_onLoadMore);
  }

  Future<void> _onFetch(
    FetchComplaintsEvent event,
    Emitter<ComplaintListState> emit,
  ) async {
    final generation = ++_generation;
    _status = event.status;
    _category = event.category;
    _query = event.query;

    if (!event.isRefresh) {
      emit(state.copyWith(status: ComplaintListStatus.loading));
    }

    final result = await _getComplaints(
      page: 1,
      perPage: _perPage,
      status: _status,
      category: _category,
      query: _query,
    );
    if (generation != _generation) return;

    result.fold(
      (failure) {
        AppLogger.e(
          '[COMPLAINT_LIST_BLOC] Gagal memuat pengaduan publik: ${failure.message}',
        );
        emit(
          state.copyWith(
            status: ComplaintListStatus.failure,
            errorMessage: failure.message,
            items: const [],
            isLoadingMore: false,
          ),
        );
      },
      (paginated) => emit(
        state.copyWith(
          status: ComplaintListStatus.loaded,
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
    LoadMoreComplaintsEvent event,
    Emitter<ComplaintListState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) return;
    if (state.status != ComplaintListStatus.loaded) return;

    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getComplaints(
      page: state.currentPage + 1,
      perPage: _perPage,
      status: _status,
      category: _category,
      query: _query,
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
