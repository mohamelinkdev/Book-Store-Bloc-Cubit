import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:book_store/core/constants/hive_constants.dart';
import 'package:book_store/core/theme/theme_mode_event.dart';

class ThemeModeCubit extends Bloc<ThemeModeEvent, ThemeMode> {
  static const _themeKey = 'app_theme_mode';

  ThemeModeCubit() : super(_loadInitialTheme()) {
    on<ToggleThemeEvent>(_onToggle);
  }

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

  Future<void> _onToggle(ToggleThemeEvent event, Emitter<ThemeMode> emit) async {
    final newMode = switch (state) {
      ThemeMode.system =>
        _systemBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };

    final box = Hive.box(HiveConstants.settingsBox);
    await box.put(_themeKey, newMode.name);
    emit(newMode);
  }
}
