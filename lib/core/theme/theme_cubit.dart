import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final saved = prefs.getString('theme_mode');
    switch (saved) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void toggle() {
    final newMode =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);
    _prefs.setString(
        'theme_mode', newMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
