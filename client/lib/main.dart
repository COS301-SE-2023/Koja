<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

=======
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/event_provider.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/navigation_management_screen.dart';
<<<<<<< HEAD
import 'widgets/event_provider.dart';

void main() {
  runApp(const KojaApp());
}

class KojaApp extends StatelessWidget {
  const KojaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        title: 'Koja',
        theme: ThemeData(colorScheme: lightColorScheme),
        home: (kDebugMode) ? const NavigationScreen() : const Login(),
        routes: {
          Login.routeName: (ctx) => const Login(),
          Profile.routeName: (ctx) => const Profile(),
          Home.routeName: (ctx) => const Home(),
          NavigationScreen.routeName: (ctx) => const NavigationScreen(),
=======

void main() {
  runApp(KojaApp());
}

class KojaApp extends StatelessWidget {
  KojaApp({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>(
          create: (context) => EventProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.setScaffoldKey(scaffoldKey);
          return MaterialApp(
            scaffoldMessengerKey: scaffoldKey,
            debugShowCheckedModeBanner: false,
            title: 'Koja',
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: const SplashScreen(),
            routes: {
              Login.routeName: (ctx) => const Login(),
              Profile.routeName: (ctx) => const Profile(),
              Home.routeName: (ctx) => const Home(),
              NavigationScreen.routeName: (ctx) => const NavigationScreen(),
            },
          );
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        },
      ),
    );
  }
<<<<<<< HEAD

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
=======
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.blue.shade700,
      nextScreen: const Login(),
      splash: Scaffold(
        body: Container(
          color: Colors.blue.shade700,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/koja.png',
                height: 200,
                width: 100,
              ),
              Text('Koja',
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                  )),
            ],
          ),
        ),
      ),
      splashTransition: SplashTransition.fadeTransition,
      centered: true,
    );
  }
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
}
