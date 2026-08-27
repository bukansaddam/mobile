part of 'activation_bloc.dart';

enum ActivationSortOption { deadlineTerdekat, terbaru, terlama }

extension ActivationSortOptionExtension on ActivationSortOption {
  String get label {
    switch (this) {
      case ActivationSortOption.deadlineTerdekat:
        return 'Deadline Terdekat';
      case ActivationSortOption.terbaru:
        return 'Terbaru';
      case ActivationSortOption.terlama:
        return 'Terlama';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivationSortOption.deadlineTerdekat:
        return Icons.alarm_rounded;
      case ActivationSortOption.terbaru:
        return Icons.arrow_upward_rounded;
      case ActivationSortOption.terlama:
        return Icons.arrow_downward_rounded;
    }
  }
}

class ActivationState extends Equatable {
  final List<ActivationActivity> activities;
  final String searchQuery;
  final ActivationCategory? selectedCategoryFilter;
  final ActivationStatus? selectedStatusFilter;
  final ActivationSortOption selectedSortOption;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final bool hasMore;

  const ActivationState({
    this.activities = const [],
    this.searchQuery = '',
    this.selectedCategoryFilter,
    this.selectedStatusFilter,
    this.selectedSortOption = ActivationSortOption.deadlineTerdekat,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.hasMore = true,
  });

  bool get hasActiveFilter =>
      selectedCategoryFilter != null ||
      selectedStatusFilter != null ||
      selectedSortOption != ActivationSortOption.deadlineTerdekat;

  List<ActivationActivity> get filteredActivities {
    final list = activities.where((act) {
      if (selectedCategoryFilter != null &&
          act.category != selectedCategoryFilter) {
        return false;
      }
      if (selectedStatusFilter != null && act.status != selectedStatusFilter) {
        return false;
      }
      if (searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final titleMatch = act.title.toLowerCase().contains(query);
        final locMatch = act.location.toLowerCase().contains(query);
        final catMatch = act.category.label.toLowerCase().contains(query);
        final statusMatch = act.status.label.toLowerCase().contains(query);
        return titleMatch || locMatch || catMatch || statusMatch;
      }
      return true;
    }).toList();

    final now = DateTime.now();
    switch (selectedSortOption) {
      case ActivationSortOption.deadlineTerdekat:
        list.sort((a, b) {
          final diffA = a.endDate.difference(now).inSeconds;
          final diffB = b.endDate.difference(now).inSeconds;
          return diffA.compareTo(diffB);
        });
        break;
      case ActivationSortOption.terbaru:
        list.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case ActivationSortOption.terlama:
        list.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
    }

    return list;
  }

  ActivationActivity? getActivityById(String id) {
    try {
      return activities.firstWhere((act) => act.id == id);
    } catch (_) {
      return null;
    }
  }

  ActivationState copyWith({
    List<ActivationActivity>? activities,
    String? searchQuery,
    ActivationCategory? selectedCategoryFilter,
    bool clearCategory = false,
    ActivationStatus? selectedStatusFilter,
    bool clearStatus = false,
    ActivationSortOption? selectedSortOption,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    bool? hasMore,
  }) {
    return ActivationState(
      activities: activities ?? this.activities,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryFilter: clearCategory
          ? null
          : (selectedCategoryFilter ?? this.selectedCategoryFilter),
      selectedStatusFilter: clearStatus
          ? null
          : (selectedStatusFilter ?? this.selectedStatusFilter),
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    activities,
    searchQuery,
    selectedCategoryFilter,
    selectedStatusFilter,
    selectedSortOption,
    isLoading,
    isLoadingMore,
    currentPage,
    hasMore,
  ];
}
