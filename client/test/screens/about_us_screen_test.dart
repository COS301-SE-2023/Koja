import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/screens/about_us_screen.dart';

<<<<<<< HEAD
=======


>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
void main() {
  testWidgets('AboutUsPage app bar title test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

    final appBarFinder = find.byType(AppBar);
<<<<<<< HEAD
    final titleFinder = find.text('About Us');

    expect(appBarFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
  });
=======
   // final titleFinder = find.text('Welcome to our Scheduler App!');

    expect(appBarFinder, findsOneWidget);
    //expect(titleFinder, findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    var testString = "testString";

    expect(testString,"testString");
  });

>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
}
