import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDark => themeMode == ThemeMode.dark;

  String get backgroundImagePath =>
      isDark ? 'assets/images/dark_bg.png' : 'assets/images/default_bg.png';

  String language = 'en';

  void changeThemeMode(ThemeMode selectedThemeMode) {
    themeMode = selectedThemeMode;
    notifyListeners();
  }

  void changeLanguage(String selectedLanguage) {
    language = selectedLanguage;
    notifyListeners();
  }
}
