import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koja/screens/about_us_screen.dart';

void main() {
  testWidgets('AboutUsPage widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

    final appBarFinder = find.byType(AppBar);

    expect(appBarFinder, findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('KOJA'), findsOneWidget);
    expect(find.byType(Container), findsAtLeastNWidgets(5));
    expect(find.byType(SizedBox), findsAtLeastNWidgets(3));
    expect(find.byType(Column), findsAtLeastNWidgets(4));
  });

}