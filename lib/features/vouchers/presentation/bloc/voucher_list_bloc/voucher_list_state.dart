part of 'voucher_list_bloc.dart';

/// Bucket penampung item terpaginasi per kategori status voucher.
class VoucherListBucket extends Equatable {
  final List<VoucherEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasLoaded;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const VoucherListBucket({
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.hasLoaded = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => currentPage < lastPage;

  VoucherListBucket copyWith({
    List<VoucherEntity>? items,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasLoaded,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VoucherListBucket(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    items,
    currentPage,
    lastPage,
    total,
    hasLoaded,
    isInitialLoading,
    isLoadingMore,
    errorMessage,
  ];
}

/// State untuk mengelola daftar voucher dan ringkasan poin.
class VoucherListState extends Equatable {
  final VoucherSummaryEntity? summary;
  final int? initialPointsFallback;
  final VoucherStatus historyFilter;
  final Map<VoucherStatus, VoucherListBucket> buckets;

  const VoucherListState({
    this.summary,
    this.initialPointsFallback,
    this.historyFilter = VoucherStatus.used,
    this.buckets = const {
      VoucherStatus.active: VoucherListBucket(),
      VoucherStatus.used: VoucherListBucket(),
      VoucherStatus.expired: VoucherListBucket(),
    },
  });

  VoucherListBucket get activeBucket =>
      buckets[VoucherStatus.active] ?? const VoucherListBucket();

  VoucherListBucket get usedBucket =>
      buckets[VoucherStatus.used] ?? const VoucherListBucket();

  VoucherListBucket get expiredBucket =>
      buckets[VoucherStatus.expired] ?? const VoucherListBucket();

  VoucherListBucket get currentHistoryBucket =>
      buckets[historyFilter] ?? const VoucherListBucket();

  int get displayedPoints =>
      summary?.currentPoints ?? initialPointsFallback ?? 0;

  VoucherListState copyWith({
    VoucherSummaryEntity? summary,
    int? initialPointsFallback,
    VoucherStatus? historyFilter,
    Map<VoucherStatus, VoucherListBucket>? buckets,
  }) {
    return VoucherListState(
      summary: summary ?? this.summary,
      initialPointsFallback:
          initialPointsFallback ?? this.initialPointsFallback,
      historyFilter: historyFilter ?? this.historyFilter,
      buckets: buckets ?? this.buckets,
    );
  }

  @override
  List<Object?> get props => [
    summary,
    initialPointsFallback,
    historyFilter,
    buckets,
  ];
}
