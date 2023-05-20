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
  runApp(const KojaApp());
}

class KojaApp extends StatelessWidget {
  const KojaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Koja',
        theme: ThemeData(colorScheme: lightColorScheme),
        home: (kDebugMode) ? const NavigationScreen() : const Login(),
        routes: {
          Login.routeName: (ctx) => const Login(),
          Profile.routeName: (ctx) => const Profile(),
          Home.routeName: (ctx) => const Home(),
          Event.routeName: (ctx) => Event(),
          NavigationScreen.routeName: (ctx) => const NavigationScreen()
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