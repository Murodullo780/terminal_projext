import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terminal_project/core/constants/pref_const.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({
    required this.themeMode,
    required this.locale,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required Locale initialLocale})
      : super(
          SettingsState(
            themeMode: ThemeMode.light,
            locale: Locale(initialLocale.languageCode),
          ),
        ) {
    _loadTheme();
  }

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    final result = await Permission.camera.request();

    if (result.isGranted) {
      return true;
    }

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(PrefConst.darkMode);
    if (isDarkMode == null) return;
    emit(
      state.copyWith(
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }

  Future<void> setDarkMode(bool isDark) async {
    emit(state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefConst.darkMode, isDark);
  }

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: Locale(locale.languageCode)));
  }
}
