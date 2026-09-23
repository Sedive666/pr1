import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/currency.dart';

class AppSettings {
  static const _themeKey = 'theme_mode';
  static const _fromKey = 'converter_from';
  static const _toKey = 'converter_to';

  SharedPreferences? _prefs;

  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    themeMode.value = switch (_prefs!.getString(_themeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _prefs?.setString(_themeKey, mode.name);
  }

  ({String from, String to}) get currencyPair {
    final from = _prefs?.getString(_fromKey);
    final to = _prefs?.getString(_toKey);
    return (
      from: findCurrency(from)?.code ?? defaultFrom,
      to: findCurrency(to)?.code ?? defaultTo,
    );
  }

  void saveCurrencyPair(String from, String to) {
    _prefs?.setString(_fromKey, from);
    _prefs?.setString(_toKey, to);
  }
}

final appSettings = AppSettings();
