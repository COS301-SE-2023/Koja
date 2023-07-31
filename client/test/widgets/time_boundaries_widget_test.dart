import 'package:client/providers/context_provider.dart';
import 'package:client/widgets/time_boundaries_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:client/Utils/event_util.dart';


void main() {
  testWidgets('TimeBoundaries widget test', (WidgetTester tester) async {
    // Create a mock EventProvider and wrap the TimeBoundaries widget with it using the Provider.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ContextProvider>(
            create: (_) => MockEventProvider(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: TimeBoundaries(),
          ),
        ),
      ),
    );

    // Verify that the title and subtitle are rendered correctly.
    expect(find.text("Times Boundaries "), findsOneWidget);
    expect(
        find.text(
            "Click here to add time boundaries for each category, select category and then click +\n\nAfter adding time boundary for a category, you can swipe to the left to edit or delete a boundary."),
        findsOneWidget);

    //expect(find.byType(IconButton), findsOneWidget );
    // Verify that the dropdown menu and add button are rendered correctly.
    //expect(find.byType(DropdownButton<String>), findsOneWidget);
    //expect(find.byKey(Key('addButton')), findsOneWidget);

    // Tap on the add button and check if the SetBoundary dialog is displayed.
    //await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    //expect(find.byType(SetBoundary), findsOneWidget);

    // Close the SetBoundary dialog.
    //Navigator.pop(tester.element(find.byType(SetBoundary)));

    // Verify that the TimeCategory widgets are rendered correctly.
    // expect(find.byType(TimeCategory), findsNWidgets(2)); // Adjust the number of widgets based on your test data.
    //
    // // Tap on the delete button of the first TimeCategory widget and check if it is deleted.
    // await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    // await tester.pumpAndSettle();
    // expect(find.byType(TimeCategory), findsOneWidget); // Verify that the widget is removed.
    //
    // // Tap on the edit button of the first TimeCategory widget and check if the SetBoundary dialog is displayed.
    // await tester.tap(find.byIcon(Icons.edit).first);
    // await tester.pumpAndSettle();
    // expect(find.byType(SetBoundary), findsOneWidget);
    //TODO : Add more tests here
  });
}

class MockEventProvider extends ContextProvider {
  // Implement mock methods or properties of your EventProvider if needed for testing.
  // For example, you can mock the `timeSlots` map and return some predefined values.
  @override
  Map<String, TimeSlot?> timeSlots = {
    'School': TimeSlot(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 1)), bookable: false,
    ),
    'Work': TimeSlot(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)), bookable: false,
    ),
  };
}
