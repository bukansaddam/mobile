import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_category_option.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_incident_categories_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_my_complaints_usecase.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_complaint_list_event.dart';
part 'my_complaint_list_state.dart';

class MyComplaintListBloc
    extends Bloc<MyComplaintListEvent, MyComplaintListState> {
  static const int _perPage = 15;
  static const int _incidentPerPage = 20;

  final GetMyComplaintsUsecase _getMyComplaints;
  final GetIncidentCategoriesUsecase? _getIncidentCategories;

  int _generation = 0;

  MyComplaintListBloc({
    required GetMyComplaintsUsecase getMyComplaints,
    GetIncidentCategoriesUsecase? getIncidentCategories,
  }) : _getMyComplaints = getMyComplaints,
       _getIncidentCategories = getIncidentCategories,
       super(const MyComplaintListState()) {
    on<FetchMyComplaintsEvent>(_onFetch);
    on<LoadMoreMyComplaintsEvent>(_onLoadMore);
    on<SearchMyComplaintsEvent>(_onSearch);
    on<ApplyMyComplaintFilterEvent>(_onApplyFilter);
    on<FetchIncidentCategoriesEvent>(_onFetchCategories);
  }

  Future<void> _onFetch(
    FetchMyComplaintsEvent event,
    Emitter<MyComplaintListState> emit,
  ) async {
    final generation = ++_generation;

    if (!event.isRefresh || state.status == MyComplaintListStatus.failure) {
      emit(
        state.copyWith(
          status: MyComplaintListStatus.loading,
          isInsidentil: event.isInsidentil,
        ),
      );
    }

    final result = await _getMyComplaints(
      page: 1,
      perPage: event.isInsidentil ? _incidentPerPage : _perPage,
      isInsidentil: event.isInsidentil,
      status: state.statusFilter,
      category: state.categoryFilter,
    );
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
            isInsidentil: event.isInsidentil,
            isLoadingMore: false,
          ),
        );
      },
      (paginated) {
        final items = List<ComplaintReportEntity>.unmodifiable(paginated.data);
        emit(
          state.copyWith(
            status: MyComplaintListStatus.loaded,
            items: items,
            filteredItems: _filterItems(items, state.searchQuery),
            isInsidentil: event.isInsidentil,
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
    LoadMoreMyComplaintsEvent event,
    Emitter<MyComplaintListState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) return;
    if (state.status != MyComplaintListStatus.loaded) return;

    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getMyComplaints(
      page: state.currentPage + 1,
      perPage: state.isInsidentil ? _incidentPerPage : _perPage,
      isInsidentil: state.isInsidentil,
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
    SearchMyComplaintsEvent event,
    Emitter<MyComplaintListState> emit,
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
    ApplyMyComplaintFilterEvent event,
    Emitter<MyComplaintListState> emit,
  ) async {
    final generation = ++_generation;

    emit(
      state.copyWith(
        status: MyComplaintListStatus.loading,
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

    final result = await _getMyComplaints(
      page: 1,
      perPage: state.isInsidentil ? _incidentPerPage : _perPage,
      isInsidentil: state.isInsidentil,
      status: event.status,
      category: event.category,
    );
    if (generation != _generation) return;

    result.fold(
      (failure) {
        AppLogger.e(
          '[COMPLAINT_LIST_BLOC] Gagal menerapkan filter: ${failure.message}',
        );
        emit(
          state.copyWith(
            status: MyComplaintListStatus.failure,
            errorMessage: failure.message,
            isLoadingMore: false,
          ),
        );
      },
      (paginated) {
        final items = List<ComplaintReportEntity>.unmodifiable(paginated.data);
        emit(
          state.copyWith(
            status: MyComplaintListStatus.loaded,
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
    FetchIncidentCategoriesEvent event,
    Emitter<MyComplaintListState> emit,
  ) async {
    final usecase = _getIncidentCategories;
    if (usecase == null) return;
    if (state.isLoadingCategories) return;
    if (!event.force && state.categories.isNotEmpty) return;

    emit(state.copyWith(isLoadingCategories: true, clearCategoryError: true));

    final result = await usecase();
    result.fold(
      (failure) {
        AppLogger.e(
          '[COMPLAINT_LIST_BLOC] Gagal memuat kategori: ${failure.message}',
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
          categories: List<ComplaintCategoryOption>.unmodifiable(categories),
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
