import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier
{
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn)
  {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}


class MyTheme {

  static final lightTheme = ThemeData
  (
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.black,
      error: Colors.red,
    ),
  );

  static final darkTheme = ThemeData
  (
    scaffoldBackgroundColor: Color.fromARGB(255, 8, 23, 233),
    colorScheme: ColorScheme.dark(
      primary: Color.fromARGB(255, 76, 85, 190),
      secondary: Colors.white,
      error: Colors.red,
    ),
  );
}