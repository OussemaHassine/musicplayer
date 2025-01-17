import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_player/themes/dark_mode.dart';
import 'package:music_player/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeKey = 'isDarkMode';

  // Default to light mode initially
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    initializeTheme(); // Automatically load theme during initialization
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemePreference(themeData == darkMode); // Save the updated preference
    notifyListeners();
  }

  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }

  Future<void> initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false; // Default to light mode
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners(); // Update listeners after loading
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }
}
