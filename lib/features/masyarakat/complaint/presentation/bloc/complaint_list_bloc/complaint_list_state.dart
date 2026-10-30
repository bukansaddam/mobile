part of 'complaint_list_bloc.dart';

enum ComplaintListStatus { initial, loading, loaded, failure }

class ComplaintListState extends Equatable {
  final ComplaintListStatus status;
  final List<ComplaintReportEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  const ComplaintListState({
    this.status = ComplaintListStatus.initial,
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ComplaintListState copyWith({
    ComplaintListStatus? status,
    List<ComplaintReportEntity>? items,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ComplaintListState(
      status: status ?? this.status,
      items: items ?? this.items,
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
    currentPage,
    lastPage,
    total,
    hasReachedMax,
    isLoadingMore,
    errorMessage,
  ];
}
