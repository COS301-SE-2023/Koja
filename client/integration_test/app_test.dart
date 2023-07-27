import 'package:client/main.dart';
import 'package:client/screens/information_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
void main() {
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });

  group('App Flow Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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
    });
  });

  //TODO: Add integration tests here
}

