import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'providers/event_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/navigation_management_screen.dart';

// Import your own MyTheme if applicable
// import 'theme/my_theme.dart';

void main() {
  runApp(const KojaApp());
}

class KojaApp extends StatelessWidget {
  const KojaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<EventProvider>(
      create: (context) => EventProvider(),
      child: Builder(
        builder: (context) {
          // final eventProvider = Provider.of<EventProvider>(context);
          // final themeProvider = ThemeProvider(); 
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Koja',
            // themeMode: themeProvider.themeMode,
            // theme: MyTheme.lightTheme,
            // darkTheme: MyTheme.darkTheme,
            home: (kDebugMode) ? NavigationScreen() : Login(),
            routes: {
              Login.routeName: (ctx) => Login(),
              Profile.routeName: (ctx) => Profile(),
              Home.routeName: (ctx) => Home(),
              NavigationScreen.routeName: (ctx) => NavigationScreen(),
            },
          );
        },
      ),
    );
  }
}
