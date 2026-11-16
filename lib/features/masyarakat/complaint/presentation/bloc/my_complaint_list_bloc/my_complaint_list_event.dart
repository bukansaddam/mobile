part of 'my_complaint_list_bloc.dart';

abstract class MyComplaintListEvent extends Equatable {
  const MyComplaintListEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyComplaintsEvent extends MyComplaintListEvent {
  final bool isRefresh;
  final bool isInsidentil;

  const FetchMyComplaintsEvent({
    this.isRefresh = false,
    this.isInsidentil = false,
  });

  @override
  List<Object?> get props => [isRefresh, isInsidentil];
}

class LoadMoreMyComplaintsEvent extends MyComplaintListEvent {
  const LoadMoreMyComplaintsEvent();
}

class SearchMyComplaintsEvent extends MyComplaintListEvent {
  final String query;

  const SearchMyComplaintsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyMyComplaintFilterEvent extends MyComplaintListEvent {
  final String? status;
  final String? category;

  const ApplyMyComplaintFilterEvent({this.status, this.category});

  @override
  List<Object?> get props => [status, category];
}

class FetchIncidentCategoriesEvent extends MyComplaintListEvent {
  final bool force;

  const FetchIncidentCategoriesEvent({this.force = false});

  @override
  List<Object?> get props => [force];
}
