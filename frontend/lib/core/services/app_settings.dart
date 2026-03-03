// I-Fridge — App Settings Provider
// ==================================
// Manages language and theme preferences with persistence
// using SharedPreferences. Notifies the widget tree of changes.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  static const String _keyLocale = 'app_locale';
  static const String _keyThemeMode = 'app_theme_mode';

  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.dark;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  /// Supported languages with display names and flags
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {'name': 'English', 'flag': '🇺🇸'},
    'ko': {'name': '한국어', 'flag': '🇰🇷'},
    'uz': {'name': "O'zbekcha", 'flag': '🇺🇿'},
    'ru': {'name': 'Русский', 'flag': '🇷🇺'},
  };

  /// Initialize settings from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_keyLocale) ?? 'en';
    _locale = Locale(localeCode);

    final themeName = prefs.getString(_keyThemeMode) ?? 'dark';
    _themeMode = _themeModeFromString(themeName);
    notifyListeners();
  }

  /// Change app locale
  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, newLocale.languageCode);
    notifyListeners();
  }

  /// Change app theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, _themeModeToString(mode));
    notifyListeners();
  }

  String get currentLanguageName =>
      supportedLanguages[_locale.languageCode]?['name'] ?? 'English';

  String get currentLanguageFlag =>
      supportedLanguages[_locale.languageCode]?['flag'] ?? '🇺🇸';

  String get currentThemeName {
    switch (_themeMode) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.system:
        return 'System';
    }
  }

  ThemeMode _themeModeFromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.dark:
        return 'dark';
    }
  }
}
