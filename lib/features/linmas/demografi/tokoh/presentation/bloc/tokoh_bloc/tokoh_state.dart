part of 'tokoh_bloc.dart';

enum TokohSortOption {
  terbaru('Terbaru', Icons.schedule_rounded),
  namaAz('Nama (A - Z)', Icons.sort_by_alpha_rounded),
  namaZa('Nama (Z - A)', Icons.sort_by_alpha_rounded);

  final String label;
  final IconData icon;

  const TokohSortOption(this.label, this.icon);
}

abstract class TokohState extends Equatable {
  const TokohState();

  @override
  List<Object?> get props => [];
}

class TokohInitial extends TokohState {}

class TokohLoading extends TokohState {}

class TokohLoaded extends TokohState {
  final TokohPaginatedEntity tokohPaginatedEntity;

  const TokohLoaded(this.tokohPaginatedEntity);

  @override
  List<Object?> get props => [tokohPaginatedEntity];
}

class TokohFailure extends TokohState {
  final String message;

  const TokohFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TokohActionLoading extends TokohState {}

class TokohActionSuccess extends TokohState {
  final TokohEntity tokoh;
  final String message;

  const TokohActionSuccess({required this.tokoh, required this.message});

  @override
  List<Object?> get props => [tokoh, message];
}

class TokohActionFailure extends TokohState {
  final String message;

  const TokohActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
