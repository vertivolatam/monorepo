import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider de SharedPreferences (resuelve async, hidrata al ThemeNotifier).
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// Estado del tema de la aplicación (abstracción estilo AltruPets_UI).
enum AppThemeMode {
  light,
  dark,
  system;

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

/// Notifier Riverpod del tema con persistencia en SharedPreferences.
/// Default: dark (decisión de producto Vertivo).
class ThemeNotifier extends Notifier<ThemeMode> {
  static const String _themeModeKey = 'vertivo_theme_mode';
  SharedPreferences? _prefs;

  @override
  ThemeMode build() => ThemeMode.dark;

  void init(SharedPreferences prefs) {
    _prefs = prefs;
    final saved = prefs.getString(_themeModeKey);
    if (saved != null) state = _fromString(saved);
  }

  ThemeMode get themeMode => state;

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs?.setString(_themeModeKey, mode.name);
    state = mode.themeMode;
  }

  AppThemeMode get currentAppThemeMode {
    switch (state) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
        return AppThemeMode.system;
    }
  }

  ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

final themeNotifierProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeNotifierProvider);
});
