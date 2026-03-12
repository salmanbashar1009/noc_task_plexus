import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box _settingsBox;

  ThemeBloc() 
      : _settingsBox = Hive.box('settings'),
        super(ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) {
    final bool isDark = _settingsBox.get('isDark', defaultValue: true);
    emit(ThemeLoaded(isDark ? ThemeMode.dark : ThemeMode.light));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final bool isDark = state is ThemeLoaded && (state as ThemeLoaded).themeMode == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    _settingsBox.put('isDark', !isDark);
    emit(ThemeLoaded(newMode));
  }
}
