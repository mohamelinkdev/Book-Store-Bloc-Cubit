import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:book_store/core/constants/hive_constants.dart';

class LocaleViewModel extends Cubit<Locale> {
  static const _localeKey = 'app_locale';

  LocaleViewModel() : super(_loadInitialLocale());

  static Locale _loadInitialLocale() {
    final box = Hive.box(HiveConstants.settingsBox);
    final savedLocale = box.get(_localeKey);
    if (savedLocale != null && savedLocale is String) {
      return Locale(savedLocale);
    }
    return const Locale('en');
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      _setAndSaveLocale(const Locale('ar'));
    } else {
      _setAndSaveLocale(const Locale('en'));
    }
  }

  void setLocale(Locale locale) {
    _setAndSaveLocale(locale);
  }

  Future<void> _setAndSaveLocale(Locale locale) async {
    final box = Hive.box(HiveConstants.settingsBox);
    await box.put(_localeKey, locale.languageCode);
    emit(locale);
  }
}
