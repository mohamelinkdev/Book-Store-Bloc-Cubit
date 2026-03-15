import 'package:flutter/material.dart';

sealed class LocaleEvent {}

class ToggleLocaleEvent extends LocaleEvent {}

class SetLocaleEvent extends LocaleEvent {
  final Locale locale;
  SetLocaleEvent(this.locale);
}
