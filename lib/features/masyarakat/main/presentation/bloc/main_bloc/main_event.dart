part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object?> get props => [];
}

class MainTabChanged extends MainEvent {
  final int index;

  const MainTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}
