import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/screens/about_us_screen.dart';

void main() {
  testWidgets('AboutUsPage app bar title test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

    final appBarFinder = find.byType(AppBar);
    final titleFinder = find.text('About Us');

    expect(appBarFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
  });
}
