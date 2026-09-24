import 'package:equatable/equatable.dart';

abstract class MemberDashboardEvent extends Equatable {
  const MemberDashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchMemberDashboardEvent extends MemberDashboardEvent {
  const FetchMemberDashboardEvent();
}

class RefreshMemberDashboardEvent extends MemberDashboardEvent {
  const RefreshMemberDashboardEvent();
}
