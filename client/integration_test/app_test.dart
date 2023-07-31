import 'package:client/main.dart';
import 'package:client/providers/context_provider.dart';
import 'package:client/providers/service_provider.dart';
import 'package:client/screens/information_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/widgets/login_modal_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });

  group('App Flow Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets("Splash Screen shows when the app starts", (WidgetTester tester) async{
      await tester.pumpWidget(KojaApp());
      await tester.pumpAndSettle();
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('Login and Info widgets integration test', (WidgetTester tester) async {
      await tester.pumpWidget(KojaApp());
      await tester.pumpAndSettle();
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for some time to let the splash screen animation finish.
      await tester.pumpAndSettle(Duration(seconds: 5));

      //pump the login widget
      await tester.pumpWidget( const MaterialApp(home: Login()));

      // Verify that Login screen appears after the splash screen.
      expect(find.byType(Login), findsOneWidget);

      //check if the text is displayed correctly
      expect(find.text("Say Goodbye To A \nMessy Schedule"), findsOneWidget);

      // Verify that both button appears on the Login screen.
      expect(find.widgetWithText(ElevatedButton,"Learn More"), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,"Get Started"), findsOneWidget);

      //Tap the Learn More button and wait for the Info widget to appear.
      await tester.tap(find.widgetWithText(ElevatedButton, "Learn More"));
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Pump the Info widget.
      await tester.pumpWidget(MaterialApp(home: Info()));
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify that the Info widget appears.
      expect(find.byType(Info), findsOneWidget);

      // Verify that the first page of the Info widget appears.
      expect(find.text('Integration With Existing \nCalendar Apps'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Tap the Next button and wait for the second page of the Info widget to appear.
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Verify that the second page of the Info widget appears.
      expect(find.text('Artificial Intelligence\nIntegration'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Tap the Next button and wait for the third page of the Info widget to appear.
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Verify that the third page of the Info widget appears.
      expect(find.text('Traveling Time\nCalculator'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

    });
    testWidgets("Sign-in integration test", (WidgetTester tester) async {
      final serviceProvider = ServiceProvider();
      final contextProvider = ContextProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ServiceProvider>.value(
              value: serviceProvider,
            ),
            ChangeNotifierProvider<ContextProvider>.value(
              value: contextProvider,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: KojaApp(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for some time to let the splash screen animation finish.
      await tester.pumpAndSettle(Duration(seconds: 5));

      //pump the login widget
      await tester.pumpWidget( const MaterialApp(home: Login()));
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ServiceProvider>.value(
              value: serviceProvider,
            ),
            ChangeNotifierProvider<ContextProvider>.value(
              value: contextProvider,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Login(),
            ),
          ),
        ),
      );

      // Verify that Login screen appears after the splash screen.
      expect(find.byType(Login), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Get Started"), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, "Get Started"));
      await tester.pumpAndSettle(Duration(seconds: 2));
      // pump the login modal widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ServiceProvider>.value(
              value: serviceProvider,
            ),
            ChangeNotifierProvider<ContextProvider>.value(
              value: contextProvider,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: LoginModal(),
            ),
          ),
        ),
      );
      expect(find.widgetWithText(ElevatedButton, "Debug Mode Route"), findsAtLeastNWidgets(1));

      await tester.tap(find.widgetWithText(ElevatedButton, "Debug Mode Route").at(1), warnIfMissed: false);
      await tester.pumpAndSettle(Duration(seconds: 2));


    });
  });


  //TODO: Add integration tests here
}

