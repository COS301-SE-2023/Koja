import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// import your widgets
import 'package:client/widgets/about_us_widget.dart';
import 'package:client/screens/about_us_screen.dart';

// Create a mock navigator
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {

  final mockObserver = MockNavigatorObserver();

  Widget createAboutUsWidgetScreen() => MaterialApp(
    home: AboutUsWidget(),
    navigatorObservers: [mockObserver],
  );

  testWidgets('AboutUsWidget should show correct texts and react on button press',
          (WidgetTester tester) async {

        await tester.pumpWidget(createAboutUsWidgetScreen());

        expect(find.text('Koja'), findsOneWidget);
        expect(find.text('Thanks for choosing Koja, with our application you will get dynamic and personalized recommendations for your next task.'), findsOneWidget);
        expect(find.text('Learn More'), findsOneWidget);
        expect(find.text('Version 0.1.58'), findsOneWidget);

        await tester.tap(find.text('Learn More'));
        await tester.pumpAndSettle();


      });
}
