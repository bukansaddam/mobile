import 'package:akar/features/masyarakat/main/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MainBloc starts at tab 0 and updates selectedIndex on MainTabChanged', () async {
    final bloc = MainBloc();
    expect(bloc.state.selectedIndex, 0);

    bloc.add(const MainTabChanged(3));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.selectedIndex, 3);

    await bloc.close();
  });
}
