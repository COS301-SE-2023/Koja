import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/screens/login_screen.dart';
import 'package:client/screens/information_screen.dart';

void main() {
  testWidgets('Login elevated button text test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));
    final getStartedButtonFinder = find.widgetWithText(ElevatedButton, 'Get Started');
    expect(getStartedButtonFinder, findsOneWidget);
  });

   testWidgets('Login widget should display the correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Login(),
        ),
      );
      expect(find.text("Say Goodbye To A \nMessy Schedule"), findsOneWidget);
      expect(find.text("With Koja, you can easily manage your schedule and events with the help of our advanced strategies, which means less effort from you and more time saving!"), findsOneWidget);
    });

}