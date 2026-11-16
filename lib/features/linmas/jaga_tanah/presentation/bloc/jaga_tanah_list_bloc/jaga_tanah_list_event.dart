part of 'jaga_tanah_list_bloc.dart';

abstract class JagaTanahListEvent extends Equatable {
  const JagaTanahListEvent();

  @override
  List<Object?> get props => [];
}

class FetchJagaTanahReportsEvent extends JagaTanahListEvent {
  final bool isRefresh;

  const FetchJagaTanahReportsEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class LoadMoreJagaTanahReportsEvent extends JagaTanahListEvent {
  const LoadMoreJagaTanahReportsEvent();
}

class SearchJagaTanahReportsEvent extends JagaTanahListEvent {
  final String query;

  const SearchJagaTanahReportsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyJagaTanahFilterEvent extends JagaTanahListEvent {
  final String? status;
  final String? category;

  const ApplyJagaTanahFilterEvent({this.status, this.category});

  @override
  List<Object?> get props => [status, category];
}

class FetchJagaTanahCategoriesEvent extends JagaTanahListEvent {
  final bool force;

  const FetchJagaTanahCategoriesEvent({this.force = false});

  @override
  List<Object?> get props => [force];
}
