import 'dart:ui';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get getIsDarkMode {
    if (themeMode == ThemeMode.system) {
      // Directly return the result of the comparison
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void resetTheme() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }
}
