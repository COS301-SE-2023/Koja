<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:client/widgets/calendar_widget.dart';
import 'package:client/widgets/event_provider.dart';
import 'package:client/widgets/tasks_widget.dart';
void main() {
  testWidgets('CalendarWidget onTap test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => EventProvider()),
        ],
        child: const MaterialApp(
          home: CalendarWidget(),
        ),
      ),
    );

    final calendarFinder = find.byType(SfCalendar);

    expect(calendarFinder, findsOneWidget);

    await tester.tap(calendarFinder);
    await tester.pumpAndSettle();

    expect(find.byType(TasksWidget), findsOneWidget);
  });
}
=======
void main() {}
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
