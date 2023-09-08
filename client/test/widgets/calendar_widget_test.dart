import 'package:koja/widgets/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:koja/providers/context_provider.dart';
import 'package:koja/widgets/calendar_widget.dart';

void main() {
  testWidgets('CalendarWidget Test', (WidgetTester tester) async {
    // Create a mock EventProvider
    final eventProvider = ContextProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ContextProvider>.value(
          value: eventProvider,
          child: Scaffold(
            body: const CalendarWidget(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(Duration(seconds: 1));
    // Verify that the CalendarWidget is displayed
    expect(find.byType(CalendarWidget), findsOneWidget);

    // Verify that the SfCalendar is displayed
    expect(find.byType(SfCalendar), findsAtLeastNWidgets(0));

    // Verify that the TasksWidget is displayed
    expect(find.byType(TasksWidget), findsAtLeastNWidgets(0));

    // Verify that the initial selected date is not null
    expect(eventProvider.selectedDate, isNotNull);
  });
}

