import 'package:flutter/material.dart';

class AppController extends ValueNotifier<bool> {
  static final AppController instance = AppController._internal();

  AppController._internal() : super(false);

  bool get darkTheme => value;

  void changeTheme() {
    value = !value;
  }

  void setThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        value = false; 
        break;
      case ThemeMode.dark:
        value = true; 
        break;
      case ThemeMode.system:
        break;
    }
  }
}
