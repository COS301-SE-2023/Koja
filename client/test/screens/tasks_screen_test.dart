import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/screens/tasks_screen.dart';
import 'package:client/providers/event_provider.dart';

void main() {
  testWidgets('Tasks Screen Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(
              create: (_) => EventProvider(),
            ),
          ],
          child: Tasks(),
        ),
      ),
    );

    // Verify the existence of the Tasks screen
    expect(find.byType(Tasks), findsOneWidget);

    // Verify the existence of the app bar title
    expect(find.text('Tasks'), findsOneWidget);

    // Verify the existence of the Current tab
    expect(find.text('Current'), findsOneWidget);

  });
}
