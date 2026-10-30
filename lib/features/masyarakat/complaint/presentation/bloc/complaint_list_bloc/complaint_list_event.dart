part of 'complaint_list_bloc.dart';

abstract class ComplaintListEvent extends Equatable {
  const ComplaintListEvent();

  @override
  List<Object?> get props => [];
}

class FetchComplaintsEvent extends ComplaintListEvent {
  final bool isRefresh;
  final String? status;
  final String? category;
  final String? query;

  const FetchComplaintsEvent({
    this.isRefresh = false,
    this.status,
    this.category,
    this.query,
  });

  @override
  List<Object?> get props => [isRefresh, status, category, query];
}

class LoadMoreComplaintsEvent extends ComplaintListEvent {
  const LoadMoreComplaintsEvent();
}
