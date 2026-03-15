import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:book_store/core/constants/hive_constants.dart';

class ThemeModeViewModel extends Cubit<ThemeMode> {
  static const _themeKey = 'app_theme_mode';

  ThemeModeViewModel() : super(_loadInitialTheme());

  static ThemeMode _loadInitialTheme() {
    final box = Hive.box(HiveConstants.settingsBox);
    final savedTheme = box.get(_themeKey);
    if (savedTheme != null && savedTheme is String) {
      return ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  Brightness get _systemBrightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  void toggle() {
    final newMode = switch (state) {
      ThemeMode.system =>
        _systemBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    
    _setAndSaveTheme(newMode);
  }

  Future<void> _setAndSaveTheme(ThemeMode mode) async {
    final box = Hive.box(HiveConstants.settingsBox);
    await box.put(_themeKey, mode.name);
    emit(mode);
  }
}
