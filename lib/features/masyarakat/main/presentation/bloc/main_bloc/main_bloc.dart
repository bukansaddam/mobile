import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<MainTabChanged>(_onTabChanged);
  }

  void _onTabChanged(MainTabChanged event, Emitter<MainState> emit) {
    if (state.selectedIndex != event.index) {
      emit(state.copyWith(selectedIndex: event.index));
    }
  }
}
