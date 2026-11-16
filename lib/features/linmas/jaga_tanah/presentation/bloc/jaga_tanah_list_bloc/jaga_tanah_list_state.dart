part of 'jaga_tanah_list_bloc.dart';

enum JagaTanahListStatus { initial, loading, loaded, failure }

class JagaTanahListState extends Equatable {
  final JagaTanahListStatus status;
  final List<ComplaintReportEntity> items;
  final List<ComplaintReportEntity> filteredItems;
  final String searchQuery;
  final String? statusFilter;
  final String? categoryFilter;
  final List<JagaTanahCategoryEntity> categories;
  final bool isLoadingCategories;
  final String? categoryError;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  const JagaTanahListState({
    this.status = JagaTanahListStatus.initial,
    this.items = const [],
    this.filteredItems = const [],
    this.searchQuery = '',
    this.statusFilter,
    this.categoryFilter,
    this.categories = const [],
    this.isLoadingCategories = false,
    this.categoryError,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  int get activeFilterCount =>
      (statusFilter != null ? 1 : 0) + (categoryFilter != null ? 1 : 0);

  bool get hasActiveFilter => activeFilterCount > 0;

  JagaTanahListState copyWith({
    JagaTanahListStatus? status,
    List<ComplaintReportEntity>? items,
    List<ComplaintReportEntity>? filteredItems,
    String? searchQuery,
    String? statusFilter,
    bool clearStatusFilter = false,
    String? categoryFilter,
    bool clearCategoryFilter = false,
    List<JagaTanahCategoryEntity>? categories,
    bool? isLoadingCategories,
    String? categoryError,
    bool clearCategoryError = false,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return JagaTanahListState(
      status: status ?? this.status,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      categoryFilter: clearCategoryFilter
          ? null
          : (categoryFilter ?? this.categoryFilter),
      categories: categories ?? this.categories,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      categoryError: clearCategoryError
          ? null
          : (categoryError ?? this.categoryError),
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    filteredItems,
    searchQuery,
    statusFilter,
    categoryFilter,
    categories,
    isLoadingCategories,
    categoryError,
    currentPage,
    lastPage,
    total,
    hasReachedMax,
    isLoadingMore,
    errorMessage,
  ];
}
