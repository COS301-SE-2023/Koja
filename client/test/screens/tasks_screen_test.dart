import 'package:client/screens/suggestions_screens.dart';
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

    // Verify the existence of the Suggestions tab
    expect(find.text('Suggestions'), findsOneWidget);

    // Verify the existence of the CurrentTasksScreen
    expect(find.byType(CurrentTasksScreen), findsOneWidget);

    // Verify the SuggestionsTasksScreen is not present before button is pressed
    expect(find.byType(SuggestionsTasksScreen), findsNothing);

    // Tap on the Suggestions tab
    await tester.tap(find.text('Suggestions'));
    await tester.pumpAndSettle();

    // Verify that the SuggestionTaskScreen is found after the button is pressed
    expect(find.byType(SuggestionsTasksScreen), findsOneWidget);

  });
}
