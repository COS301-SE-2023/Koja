// ignore_for_file: prefer_const_constructors
// ignore: library_private_types_in_public_api

//Packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Pages or widgets
import 'screens/login_screen.dart';
import 'screens/event_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/navigation_management_screen.dart';

void main() {
  runApp(KojaApp());
}

class KojaApp extends StatelessWidget {
  const KojaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Koja',
        theme: ThemeData(colorScheme: lightColorScheme),
        home: (kDebugMode) ? NavigationScreen() : Login(),
        routes: {
          Login.routeName: (ctx) => Login(),
          Profile.routeName: (ctx) => Profile(),
          Home.routeName: (ctx) => Home(),
          Event.routeName: (ctx) => Event(),
          NavigationScreen.routeName: (ctx) => NavigationScreen()
        });
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Colors.blueAccent,
    secondary: Colors.blue,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.redAccent,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}
