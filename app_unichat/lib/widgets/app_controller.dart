import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends ValueNotifier<bool> {
  static final AppController instance = AppController._internal();
  static const String _themeKey = 'theme_preference';

  AppController._internal() : super(false) {
    _loadThemeFromPrefs();
  }

  bool get darkTheme => value;

  void setThemeMode(bool isDark) async {
    value = isDark;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDark = prefs.getBool(_themeKey);
    if (isDark != null) {
      value = isDark;
    }
  }
}
