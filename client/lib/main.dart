import 'package:client/providers/Theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'providers/event_provider.dart';
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
        ChangeNotifierProvider<EventProvider>(create: (context) => EventProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
      ],
      builder: (context, _) {
        
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp
        (
            debugShowCheckedModeBanner: false,
            title: 'Koja',
            themeMode: themeProvider.themeMode,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            home: (kDebugMode) ? const NavigationScreen() : const Login(),
            routes: {
              Login.routeName: (ctx) => const Login(),
              Profile.routeName: (ctx) => const Profile(),
              Home.routeName: (ctx) => const Home(),
              NavigationScreen.routeName: (ctx) => const NavigationScreen(),
            },   
        );
      },
    );
  }
}