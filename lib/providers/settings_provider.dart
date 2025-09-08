import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  static const String _navigationRailLabelTypeKey = 'navigationRailLabelType';

  NavigationRailLabelType _navigationRailLabelType = NavigationRailLabelType.all;

  SettingsProvider(this.sharedPreferences) {
    _loadNavigationRailLabelType();
  }

  NavigationRailLabelType get navigationRailLabelType => _navigationRailLabelType;

  void _loadNavigationRailLabelType() {
    final labelTypeString = sharedPreferences.getString(_navigationRailLabelTypeKey);
    if (labelTypeString == 'none') {
      _navigationRailLabelType = NavigationRailLabelType.none;
    } else if (labelTypeString == 'selected') {
      _navigationRailLabelType = NavigationRailLabelType.selected;
    } else {
      _navigationRailLabelType = NavigationRailLabelType.all;
    }
    notifyListeners();
  }

  Future<void> setNavigationRailLabelType(NavigationRailLabelType labelType) async {
    _navigationRailLabelType = labelType;
    await sharedPreferences.setString(_navigationRailLabelTypeKey, labelType.toString().split('.').last);
    notifyListeners();
  }
}
