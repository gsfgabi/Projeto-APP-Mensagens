import 'package:flutter/material.dart';

class AppController extends ValueNotifier<bool> {
  static final AppController instance = AppController._internal();

  AppController._internal() : super(false);

  bool get darkTheme => value;

  void changeTheme() {
    value = !value;
  }
}