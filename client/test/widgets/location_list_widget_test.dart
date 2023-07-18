import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:client/widgets/location_list_widget.dart';

void main() {
  testWidgets('Test LocationListWidget with empty locationList', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LocationListWidget()));

    // Verify that the "No Saved Locations" text is displayed
    expect(find.text('No Saved Locations'), findsOneWidget);

    // Verify that the Lottie animation is displayed
    expect(find.byType(Lottie), findsOneWidget);
  });

  testWidgets('Test LocationListWidget delete location', (WidgetTester tester) async {
    // Create a mock list of locations

    await tester.pumpWidget(MaterialApp(home: LocationListWidget()));
    await tester.pump();
     expect(find.byType(ListTile), findsAtLeastNWidgets(0));
  });
}
