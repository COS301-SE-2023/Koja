import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:koja/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/context_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/navigation_management_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(KojaApp());
}

class KojaApp extends StatelessWidget {
  KojaApp({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContextProvider>(
          create: (context) => ContextProvider(),
        ),
        FutureProvider<ServiceProvider>(
          create: (context) => ServiceProvider().init(),
          initialData: ServiceProvider(),
        )
      ],
      child: Builder(
        builder: (context) {
          final provider = Provider.of<ContextProvider>(context, listen: false);
          provider.setScaffoldKey(scaffoldKey);
          provider.setNavigationKey(navigatorKey);
          return MaterialApp(
            navigatorKey: navigatorKey,
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
                height : 200,
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
}
