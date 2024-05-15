import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool darkTheme = false;
  void changeTheme() {
    darkTheme = !darkTheme;
    notifyListeners();
  }

  // Widget getThemeIcon() {
  //   return darkTheme
  //       ? SvgPicture.asset('assets/images/moon.svg')
  //       : SvgPicture.asset('assets/images/sun.svg');
  // }
}
