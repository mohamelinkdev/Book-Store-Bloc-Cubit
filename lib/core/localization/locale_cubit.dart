import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:book_store/core/constants/hive_constants.dart';
import 'package:book_store/core/localization/locale_event.dart';

class LocaleCubit extends Bloc<LocaleEvent, Locale> {
  static const _localeKey = 'app_locale';

  LocaleCubit() : super(_loadInitialLocale()) {
    on<ToggleLocaleEvent>(_onToggle);
    on<SetLocaleEvent>(_onSetLocale);
  }

  static Locale _loadInitialLocale() {
    final box = Hive.box(HiveConstants.settingsBox);
    final savedLocale = box.get(_localeKey);
    if (savedLocale != null && savedLocale is String) {
      return Locale(savedLocale);
    }
    return const Locale('en');
  }

  Future<void> _onToggle(ToggleLocaleEvent event, Emitter<Locale> emit) async {
    if (state.languageCode == 'en') {
      await _setAndSaveLocale(const Locale('ar'), emit);
    } else {
      await _setAndSaveLocale(const Locale('en'), emit);
    }
  }

  Future<void> _onSetLocale(SetLocaleEvent event, Emitter<Locale> emit) async {
    await _setAndSaveLocale(event.locale, emit);
  }

  Future<void> _setAndSaveLocale(Locale locale, Emitter<Locale> emit) async {
    final box = Hive.box(HiveConstants.settingsBox);
    await box.put(_localeKey, locale.languageCode);
    emit(locale);
  }
}
