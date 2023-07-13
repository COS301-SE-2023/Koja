import 'package:client/widgets/time_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  testWidgets('TimeCategory Widget Test', (WidgetTester tester) async {
    bool deletePressed = false;
    bool editPressed = false;

    final category = 'School';
    final startTime = '9:00 AM';
    final endTime = '10:00 AM';

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: TimeCategory(
            category,
            startTime,
            endTime,
                (BuildContext context) {
              deletePressed = true;
            },
                (BuildContext context) {
              editPressed = true;
            },
          ),
        ),
      ),
    );

  });
}
