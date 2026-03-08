import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(ThemeMode.system);

  Brightness get _systemBrightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  void toggle() {
    emit(switch (state) {
      ThemeMode.system =>
        _systemBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    });
  }
}
