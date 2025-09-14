import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  static const String _themeModeKey = 'themeMode';
  static const String _primaryColorKey = 'primaryColor';

  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = Colors.blue;

  ThemeProvider(this.sharedPreferences) {
    _loadThemeMode();
    _loadPrimaryColor();
  }

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  ThemeData get themeData => ThemeData.light().copyWith(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor, brightness: Brightness.light),
      );

  ThemeData get darkThemeData => ThemeData.dark().copyWith(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor, brightness: Brightness.dark),
      );

  void _loadThemeMode() {
    final themeModeString = sharedPreferences.getString(_themeModeKey);
    if (themeModeString == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeModeString == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void _loadPrimaryColor() {
    final colorValue = sharedPreferences.getInt(_primaryColorKey);
    if (colorValue != null) {
      _primaryColor = Color(colorValue);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await sharedPreferences.setString(_themeModeKey, themeMode.toString().split('.').last);
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    await sharedPreferences.setInt(_primaryColorKey, color.hashCode);
    notifyListeners();
  }
}
