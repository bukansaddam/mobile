part of 'main_bloc.dart';

class MainState extends Equatable {
  final int selectedIndex;

  const MainState({this.selectedIndex = 0});

  MainState copyWith({int? selectedIndex}) {
    return MainState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object?> get props => [selectedIndex];
}
