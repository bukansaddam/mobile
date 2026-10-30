part of 'my_complaint_list_bloc.dart';

abstract class MyComplaintListEvent extends Equatable {
  const MyComplaintListEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyComplaintsEvent extends MyComplaintListEvent {
  final bool isRefresh;

  const FetchMyComplaintsEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class LoadMoreMyComplaintsEvent extends MyComplaintListEvent {
  const LoadMoreMyComplaintsEvent();
}
