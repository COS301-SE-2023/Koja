import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:client/screens/suggestions_screens.dart'; // Replace this with your app's main file import.

void main() {
  testWidgets('SuggestionsTasksScreen widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: SuggestionsTasksScreen(),
    ));

    // Verify if the Lottie animation is displayed.
    expect(find.byType(Lottie), findsOneWidget);
    
    // Verify the dimensions of the Lottie widget.
    final lottieElement = tester.firstElement(find.byType(Lottie));
    final lottieHeight = lottieElement.size!.height;
    final lottieWidth = lottieElement.size!.width;

    expect(lottieHeight, 550.0);
    expect(lottieWidth, 300.0);
  });
}
