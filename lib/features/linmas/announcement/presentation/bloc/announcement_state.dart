import 'package:akar/features/linmas/announcement/domain/entities/announcement_entity.dart';
import 'package:equatable/equatable.dart';

enum AnnouncementStatus { initial, loading, loaded, error }

class AnnouncementState extends Equatable {
  final AnnouncementStatus status;
  final List<AnnouncementEntity> announcements;
  final List<AnnouncementEntity> bannerAnnouncements;
  final AnnouncementStatus bannerStatus;
  final int currentPage;
  final int lastPage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? selectedCategory;
  final bool? isPinnedFilter;

  const AnnouncementState({
    this.status = AnnouncementStatus.initial,
    this.announcements = const [],
    this.bannerAnnouncements = const [],
    this.bannerStatus = AnnouncementStatus.initial,
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.selectedCategory,
    this.isPinnedFilter,
  });

  AnnouncementState copyWith({
    AnnouncementStatus? status,
    List<AnnouncementEntity>? announcements,
    List<AnnouncementEntity>? bannerAnnouncements,
    AnnouncementStatus? bannerStatus,
    int? currentPage,
    int? lastPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
    String? selectedCategory,
    bool? isPinnedFilter,
  }) {
    return AnnouncementState(
      status: status ?? this.status,
      announcements: announcements ?? this.announcements,
      bannerAnnouncements: bannerAnnouncements ?? this.bannerAnnouncements,
      bannerStatus: bannerStatus ?? this.bannerStatus,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isPinnedFilter: isPinnedFilter ?? this.isPinnedFilter,
    );
  }

  @override
  List<Object?> get props => [
    status,
    announcements,
    bannerAnnouncements,
    bannerStatus,
    currentPage,
    lastPage,
    hasReachedMax,
    isLoadingMore,
    errorMessage,
    selectedCategory,
    isPinnedFilter,
  ];
}
