import 'package:equatable/equatable.dart';
import '../../domain/entities/member_dashboard_entity.dart';

abstract class MemberDashboardState extends Equatable {
  const MemberDashboardState();

  @override
  List<Object?> get props => [];
}

class MemberDashboardInitial extends MemberDashboardState {
  const MemberDashboardInitial();
}

class MemberDashboardLoading extends MemberDashboardState {
  const MemberDashboardLoading();
}

class MemberDashboardLoaded extends MemberDashboardState {
  final MemberDashboardEntity dashboard;
  final bool isRefreshing;

  const MemberDashboardLoaded({
    required this.dashboard,
    this.isRefreshing = false,
  });

  MemberDashboardLoaded copyWith({
    MemberDashboardEntity? dashboard,
    bool? isRefreshing,
  }) {
    return MemberDashboardLoaded(
      dashboard: dashboard ?? this.dashboard,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [dashboard, isRefreshing];
}

class MemberDashboardError extends MemberDashboardState {
  final String message;

  const MemberDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
