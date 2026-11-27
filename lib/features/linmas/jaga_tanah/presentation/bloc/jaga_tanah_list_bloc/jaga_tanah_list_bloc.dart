import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_my_jaga_tanah_reports_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'jaga_tanah_list_event.dart';
part 'jaga_tanah_list_state.dart';

class JagaTanahListBloc extends Bloc<JagaTanahListEvent, JagaTanahListState> {
  static const int _perPage = 20;

  final GetMyJagaTanahReportsUsecase _getMyReports;
  final GetJagaTanahCategoriesUsecase _getCategories;

  int _generation = 0;

  JagaTanahListBloc({
    required this._getMyReports,
    required this._getCategories,
  }) : super(const JagaTanahListState()) {
    on<FetchJagaTanahReportsEvent>(_onFetch);
    on<LoadMoreJagaTanahReportsEvent>(_onLoadMore);
    on<SearchJagaTanahReportsEvent>(_onSearch);
    on<ApplyJagaTanahFilterEvent>(_onApplyFilter);
    on<FetchJagaTanahCategoriesEvent>(_onFetchCategories);
  }

  Future<void> _onFetch(
    FetchJagaTanahReportsEvent event,
    Emitter<JagaTanahListState> emit,
  ) async {
    final generation = ++_generation;

    if (!event.isRefresh || state.status == JagaTanahListStatus.failure) {
      emit(state.copyWith(status: JagaTanahListStatus.loading));
    }

    final result = await _getMyReports(
      page: 1,
      perPage: _perPage,
      status: state.statusFilter,
      category: state.categoryFilter,
    );
    if (generation != _generation) return;

    result.fold(
      (failure) {
        AppLogger.e(
          '[JAGA_TANAH_LIST_BLOC] Gagal memuat laporan: ${failure.message}',
        );
        emit(
          state.copyWith(
            status: JagaTanahListStatus.failure,
            errorMessage: failure.message,
            isLoadingMore: false,
          ),
        );
      },
      (paginated) {
        final items = List<ComplaintReportEntity>.unmodifiable(paginated.data);
        emit(
          state.copyWith(
            status: JagaTanahListStatus.loaded,
            items: items,
            filteredItems: _filterItems(items, state.searchQuery),
            currentPage: paginated.currentPage,
            lastPage: paginated.lastPage,
            total: paginated.total,
            hasReachedMax: paginated.currentPage >= paginated.lastPage,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMore(
    LoadMoreJagaTanahReportsEvent event,
    Emitter<JagaTanahListState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) return;
    if (state.status != JagaTanahListStatus.loaded) return;

    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getMyReports(
      page: state.currentPage + 1,
      perPage: _perPage,
      status: state.statusFilter,
      category: state.categoryFilter,
    );
    if (generation != _generation) return;

    result.fold((failure) => emit(state.copyWith(isLoadingMore: false)), (
      paginated,
    ) {
      final items = List<ComplaintReportEntity>.unmodifiable([
        ...state.items,
        ...paginated.data,
      ]);
      emit(
        state.copyWith(
          items: items,
          filteredItems: _filterItems(items, state.searchQuery),
          currentPage: paginated.currentPage,
          lastPage: paginated.lastPage,
          total: paginated.total,
          hasReachedMax: paginated.currentPage >= paginated.lastPage,
          isLoadingMore: false,
        ),
      );
    });
  }

  void _onSearch(
    SearchJagaTanahReportsEvent event,
    Emitter<JagaTanahListState> emit,
  ) {
    final query = event.query.trim();
    if (query == state.searchQuery) return;
    emit(
      state.copyWith(
        searchQuery: query,
        filteredItems: _filterItems(state.items, query),
      ),
    );
  }

  Future<void> _onApplyFilter(
    ApplyJagaTanahFilterEvent event,
    Emitter<JagaTanahListState> emit,
  ) async {
    final generation = ++_generation;

    emit(
      state.copyWith(
        status: JagaTanahListStatus.loading,
        statusFilter: event.status,
        clearStatusFilter: event.status == null,
        categoryFilter: event.category,
        clearCategoryFilter: event.category == null,
        items: const [],
        filteredItems: const [],
        isLoadingMore: false,
        clearError: true,
      ),
    );

    final result = await _getMyReports(
      page: 1,
      perPage: _perPage,
      status: event.status,
      category: event.category,
    );
    if (generation != _generation) return;

    result.fold(
      (failure) {
        AppLogger.e(
          '[JAGA_TANAH_LIST_BLOC] Gagal menerapkan filter: ${failure.message}',
        );
        emit(
          state.copyWith(
            status: JagaTanahListStatus.failure,
            errorMessage: failure.message,
            isLoadingMore: false,
          ),
        );
      },
      (paginated) {
        final items = List<ComplaintReportEntity>.unmodifiable(paginated.data);
        emit(
          state.copyWith(
            status: JagaTanahListStatus.loaded,
            items: items,
            filteredItems: _filterItems(items, state.searchQuery),
            currentPage: paginated.currentPage,
            lastPage: paginated.lastPage,
            total: paginated.total,
            hasReachedMax: paginated.currentPage >= paginated.lastPage,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onFetchCategories(
    FetchJagaTanahCategoriesEvent event,
    Emitter<JagaTanahListState> emit,
  ) async {
    if (state.isLoadingCategories) return;
    if (!event.force && state.categories.isNotEmpty) return;

    emit(state.copyWith(isLoadingCategories: true, clearCategoryError: true));

    final result = await _getCategories();
    result.fold(
      (failure) {
        AppLogger.e(
          '[JAGA_TANAH_LIST_BLOC] Gagal memuat kategori: ${failure.message}',
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

  static List<ComplaintReportEntity> _filterItems(
    List<ComplaintReportEntity> source,
    String query,
  ) {
    if (query.isEmpty) return source;
    final lower = query.toLowerCase();
    return List<ComplaintReportEntity>.unmodifiable(
      source.where(
        (item) =>
            item.title.toLowerCase().contains(lower) ||
            item.ticketNumber.toLowerCase().contains(lower) ||
            item.id.toLowerCase().contains(lower) ||
            item.category.toLowerCase().contains(lower) ||
            item.address.toLowerCase().contains(lower) ||
            item.description.toLowerCase().contains(lower),
      ),
    );
  }
}
