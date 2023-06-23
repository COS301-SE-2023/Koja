import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'providers/event_provider.dart';
// import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/navigation_management_screen.dart';

void main() {
  runApp(const KojaApp());
}

class KojaApp extends StatelessWidget {
  const KojaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>(
          create: (context) => EventProvider(),
        ),
        // ChangeNotifierProvider<ThemeProvider>(
        //   create: (context) => ThemeProvider(),
        // ),
      ],
      child: Builder(
        builder: (context) {
          // final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Koja',
            // themeMode: themeProvider.themeMode,
            // theme: MyTheme.lightTheme,
            // darkTheme: MyTheme.darkTheme,
            theme: ThemeData(       
              useMaterial3: true,
            ),
            home: const SplashScreen(),
            // (kDebugMode) ? const NavigationScreen() : const Login(),
            routes: {
              Login.routeName: (ctx) => const Login(),
              Profile.routeName: (ctx) => const Profile(),
              Home.routeName: (ctx) => const Home(),
              NavigationScreen.routeName: (ctx) => const NavigationScreen(),
            },
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      nextScreen: const Login(),
      splash: Scaffold(
        body: Container(
          color: Colors.blue.shade700,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/koja.png', height: 200, width: 100,),
              Text('Koja',
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                )
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade700,
      splashTransition: SplashTransition.fadeTransition,
      centered: true,
    );
  }
}