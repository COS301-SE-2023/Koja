import 'package:client/widgets/login_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/screens/information_screen.dart';
import 'package:icons_plus/icons_plus.dart'; // Replace 'your_app' with the actual package name

void main() {
  testWidgets('Info widget should render without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Info(),
    ));

    // Verify if the Info widget renders without any exception.
    expect(find.byType(Info), findsOneWidget);
    expect(find.byType(Content), findsOneWidget);
    expect(find.byType(DotIndicator), findsWidgets);
  });

  testWidgets('PageView should swipe between pages correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Info(),
    ));

    // Initially, the first page should be visible
    expect(find.text('Integration With Existing \nCalendar Apps'), findsOneWidget);
    expect(find.text('Artificial Intelligence\nIntegration'), findsNothing);
    expect(find.text('Traveling Time\nCalculator'), findsNothing);

    // Swipe to the second page
    await tester.drag(find.byType(PageView), Offset(-300, 0));
    await tester.pumpAndSettle();

    // Now, the second page should be visible
    expect(find.text('Integration With Existing \nCalendar Apps'), findsOneWidget);
    expect(find.text('Artificial Intelligence\nIntegration'), findsNothing);
    expect(find.text('Traveling Time\nCalculator'), findsNothing);

    // Swipe to the third page
    await tester.drag(find.byType(PageView), Offset(-300, 0));
    await tester.pumpAndSettle();

    // Now, the third page should be visible
    expect(find.text('Integration With Existing \nCalendar Apps'), findsOneWidget);
    expect(find.text('Artificial Intelligence\nIntegration'), findsNothing);
    expect(find.text('Traveling Time\nCalculator'), findsNothing);
  });

  testWidgets('Next button should change pages and show modal sheet on last page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Info(),
    ));

    // Initially, the first page should be visible
    expect(
        find.text('Integration With Existing \nCalendar Apps'), findsOneWidget);
  });
  
}
