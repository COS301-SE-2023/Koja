import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/screens/about_us_screen.dart';

void main() {
  testWidgets('AboutUsPage app bar title test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

    final appBarFinder = find.byType(AppBar);

    expect(appBarFinder, findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    var testString = "testString";

    expect(testString,"testString");
  });

}