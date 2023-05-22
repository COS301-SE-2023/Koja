import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/screens/login_screen.dart';

void main() {
  testWidgets('Login elevated button text test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    final getStartedButtonFinder = find.widgetWithText(ElevatedButton, 'Get Started');
    final signInButtonFinder = find.widgetWithText(ElevatedButton, 'Sign In');

    expect(getStartedButtonFinder, findsOneWidget);
    expect(signInButtonFinder, findsOneWidget);
  });
}