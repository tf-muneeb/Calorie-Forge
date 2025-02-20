import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setLightMode() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
}