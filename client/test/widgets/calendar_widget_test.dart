import 'package:client/widgets/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:client/providers/event_provider.dart';
import 'package:client/widgets/calendar_widget.dart';

void main() {
  testWidgets('CalendarWidget Test', (WidgetTester tester) async {
    // Create a mock EventProvider
    final eventProvider = EventProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<EventProvider>.value(
          value: eventProvider,
          child: CalendarWidget(),
        ),
      ),
    );

   
  });
}

