import 'package:akar/features/linmas/announcement/domain/usecases/get_announcements_usecase.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUsecase getAnnouncementsUsecase;

  AnnouncementBloc({required this.getAnnouncementsUsecase})
    : super(const AnnouncementState()) {
    on<FetchAnnouncements>(_onFetchAnnouncements);
    on<FetchBannerAnnouncements>(_onFetchBannerAnnouncements);
    on<LoadMoreAnnouncements>(_onLoadMoreAnnouncements);
  }

  Future<void> _onFetchAnnouncements(
    FetchAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(
        state.copyWith(
          status: AnnouncementStatus.loading,
          selectedCategory: event.category,
          isPinnedFilter: event.isPinned,
        ),
      );
    }

    final result = await getAnnouncementsUsecase(
      category: event.category ?? state.selectedCategory,
      isPinned: event.isPinned ?? state.isPinnedFilter,
      page: 1,
      perPage: 10,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AnnouncementStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paginated) => emit(
        state.copyWith(
          status: AnnouncementStatus.loaded,
          announcements: paginated.data,
          currentPage: paginated.currentPage,
          lastPage: paginated.lastPage,
          hasReachedMax: paginated.currentPage >= paginated.lastPage,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> _onFetchBannerAnnouncements(
    FetchBannerAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(state.copyWith(bannerStatus: AnnouncementStatus.loading));

    final result = await getAnnouncementsUsecase(
      category: event.category,
      isPinned: true,
      page: 1,
      perPage: 10,
    );

    result.fold(
      (failure) => emit(state.copyWith(bannerStatus: AnnouncementStatus.error)),
      (paginated) => emit(
        state.copyWith(
          bannerStatus: AnnouncementStatus.loaded,
          bannerAnnouncements: paginated.data,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreAnnouncements(
    LoadMoreAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await getAnnouncementsUsecase(
      category: state.selectedCategory,
      isPinned: state.isPinnedFilter,
      page: nextPage,
      perPage: 10,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (paginated) => emit(
        state.copyWith(
          status: AnnouncementStatus.loaded,
          announcements: List.of(state.announcements)..addAll(paginated.data),
          currentPage: paginated.currentPage,
          lastPage: paginated.lastPage,
          hasReachedMax: paginated.currentPage >= paginated.lastPage,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
