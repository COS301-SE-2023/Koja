import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koja/widgets/user_details_widget.dart';

void main() {
  testWidgets('UserDetails Widget Test', (WidgetTester tester) async {
    const String profile = 'assets/icons/coffee.png';
    const String email = 'user@example.com';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserDetails(
            profile: profile,
            email: email,
          ),
        ),
      ),
    );

    // Find the profile picture widget
    final profilePictureFinder = find.byType(CircleAvatar);
    expect(profilePictureFinder, findsOneWidget);

    // Find the email text widget
    final emailTextFinder = find.text(email);
    expect(emailTextFinder, findsOneWidget);
  });
}
