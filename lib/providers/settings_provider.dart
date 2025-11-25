import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  static const String _pushKey = 'pushNotificationsEnabled';
  static const String _emailKey = 'emailNewsletterEnabled';

  bool _pushNotificationsEnabled = false;
  bool _emailNewsletterEnabled = false;

  SettingsProvider(this.sharedPreferences) {
    _load();
  }

  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get emailNewsletterEnabled => _emailNewsletterEnabled;

  void _load() {
    _pushNotificationsEnabled = sharedPreferences.getBool(_pushKey) ?? false;
    _emailNewsletterEnabled = sharedPreferences.getBool(_emailKey) ?? false;
    notifyListeners();
  }

  Future<void> setPushNotificationsEnabled(bool value) async {
    _pushNotificationsEnabled = value;
    await sharedPreferences.setBool(_pushKey, value);
    notifyListeners();
  }

  Future<void> setEmailNewsletterEnabled(bool value) async {
    _emailNewsletterEnabled = value;
    await sharedPreferences.setBool(_emailKey, value);
    notifyListeners();
  }
}
