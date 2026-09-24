import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_member_dashboard_usecase.dart';
import 'member_dashboard_event.dart';
import 'member_dashboard_state.dart';

class MemberDashboardBloc
    extends Bloc<MemberDashboardEvent, MemberDashboardState> {
  final GetMemberDashboardUsecase getMemberDashboardUsecase;

  MemberDashboardBloc({required this.getMemberDashboardUsecase})
    : super(const MemberDashboardInitial()) {
    on<FetchMemberDashboardEvent>(_onFetchMemberDashboard);
    on<RefreshMemberDashboardEvent>(_onRefreshMemberDashboard);
  }

  Future<void> _onFetchMemberDashboard(
    FetchMemberDashboardEvent event,
    Emitter<MemberDashboardState> emit,
  ) async {
    emit(const MemberDashboardLoading());
    final result = await getMemberDashboardUsecase();
    result.fold(
      (failure) => emit(MemberDashboardError(failure.message)),
      (dashboard) => emit(MemberDashboardLoaded(dashboard: dashboard)),
    );
  }

  Future<void> _onRefreshMemberDashboard(
    RefreshMemberDashboardEvent event,
    Emitter<MemberDashboardState> emit,
  ) async {
    if (state is MemberDashboardLoaded) {
      final current = state as MemberDashboardLoaded;
      emit(current.copyWith(isRefreshing: true));
    }
    final result = await getMemberDashboardUsecase();
    result.fold((failure) {
      if (state is MemberDashboardLoaded) {
        emit((state as MemberDashboardLoaded).copyWith(isRefreshing: false));
      } else {
        emit(MemberDashboardError(failure.message));
      }
    }, (dashboard) => emit(MemberDashboardLoaded(dashboard: dashboard)));
  }
}
