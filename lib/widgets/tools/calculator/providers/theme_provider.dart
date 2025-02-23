import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider(this.themeMode) {
    _loadTheme();
  }
  
  ThemeMode themeMode;

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDarkMode') ?? false;
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  String switchToText(BuildContext context) {
    return 'Switch to ${Theme.of(context).brightness == Brightness.dark ? 'Light' : 'Dark'}';
  }

  Future<void> toggleTheme(bool isDark) async {
    try {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDark);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  // Add this getter for smooth theme transition
  Duration get themeSwitchDuration => const Duration(milliseconds: 300);
}
