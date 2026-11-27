import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// Mengelola mode tema aplikasi (sistem, terang, gelap) secara persisten.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String themeModeKey = 'app_theme_mode';

  final SharedPreferences sharedPreferences;

  ThemeBloc({required this.sharedPreferences})
    : super(ThemeState(themeMode: _readThemeMode(sharedPreferences))) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeModeEvent>(_onChangeThemeMode);
  }

  static ThemeMode _readThemeMode(SharedPreferences prefs) {
    switch (prefs.getString(themeModeKey)) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  static String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  void _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) {
    emit(ThemeState(themeMode: _readThemeMode(sharedPreferences)));
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeModeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await sharedPreferences.setString(
      themeModeKey,
      _encodeThemeMode(event.themeMode),
    );
    emit(ThemeState(themeMode: event.themeMode));
  }
}
