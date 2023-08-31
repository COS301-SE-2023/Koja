import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:koja/providers/service_provider.dart';
import 'package:koja/screens/suggestions_screens.dart';
import 'package:provider/provider.dart';

void main() {
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });

  testWidgets('SuggestionsTasksScreen widget test', (WidgetTester tester) async {

    final serviceProvider = ServiceProvider();
    final contextProvider = ContextProvider();


    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ServiceProvider>.value(
            value: serviceProvider,
          ),
          ChangeNotifierProvider<ContextProvider>.value(
            value: contextProvider,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SuggestionsTasksScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(SuggestionsTasksScreen), findsOneWidget);

  });
}
