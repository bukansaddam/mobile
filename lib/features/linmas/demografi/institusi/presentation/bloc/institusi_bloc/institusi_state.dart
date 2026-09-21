part of 'institusi_bloc.dart';

abstract class InstitusiState extends Equatable {
  const InstitusiState();

  @override
  List<Object?> get props => [];
}

class InstitusiInitial extends InstitusiState {}

class InstitusiLoading extends InstitusiState {}

class InstitusiLoaded extends InstitusiState {
  final InstitusiPaginatedEntity? paginated;
  final List<InstitusiCategoryEntity>? categories;

  const InstitusiLoaded([this.paginated, this.categories]);

  @override
  List<Object?> get props => [paginated, categories];
}

class InstitusiFailure extends InstitusiState {
  final String message;

  const InstitusiFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InstitusiActionLoading extends InstitusiState {}

class InstitusiActionSuccess extends InstitusiState {
  final InstitusiEntity? institusi;
  final String message;

  const InstitusiActionSuccess({this.institusi, required this.message});

  @override
  List<Object?> get props => [institusi, message];
}

class InstitusiActionFailure extends InstitusiState {
  final String message;

  const InstitusiActionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
