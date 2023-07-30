import 'package:client/Utils/event_util.dart';
import 'package:client/providers/context_provider.dart';
import 'package:client/widgets/location_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:client/screens/home_screen.dart';

void main() {
  testWidgets('Home widget test', (WidgetTester tester) async {
    // Create a mock EventProvider for testing
    final eventProvider = ContextProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: eventProvider,
          child: Home(),
        ),
      ),
    );

    // Verify that the title 'Home' is displayed in the AppBar
    expect(find.text('Home'), findsOneWidget);

    // Test the 'Tasks Overview' text in TaskOverviewBlock
    expect(find.text('Tasks Overview'), findsOneWidget);

    // Test the 'Upcoming Tasks' text in UpcomingHeader
    expect(find.text('Upcoming Tasks'), findsOneWidget);

    // Test the 'Traveling Times' text in LocationHeader
    expect(find.text('Traveling Times'), findsOneWidget);

    // Test the click on the map icon to show the LocationListWidget
    await tester.tap(find.byIcon(Icons.map_outlined));
    await tester.pumpAndSettle();

    // Verify that the LocationListWidget is displayed
    expect(find.byType(LocationListWidget), findsOneWidget);

    // Test the event count functions
    eventProvider.addEvent(
        Event(
            title: 'Test Event',
            from: DateTime.now(),
            to: DateTime.now().add(Duration(hours: 1)),
        )
    );
    eventProvider.addEvent(
        Event(
            title: 'Test Event 2',
            from: DateTime.now().add(Duration(days: 2)),
            to: DateTime.now().add(Duration(days: 2, hours: 1)),
        )
    );

    // Trigger a rebuild with the new event data
    await tester.pump();

    //TODO
    // // Test the getEventsOnPresentDay function
    // expect(find.descendant(
    //   of: find.byType(TasksBlock),
    //   matching: find.text('1'),
    // ), findsOneWidget); // Assuming 1 event is on the present day
    //
    // // Test the getEventsOnPresentWeek function
    // expect(find.descendant(
    //   of: find.byType(TasksBlock),
    //   matching: find.text('2'),
    // ), findsOneWidget); // Assuming 2 events are on the present week
  });
}
