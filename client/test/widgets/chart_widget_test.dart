import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/widgets/chart_widget.dart';

void main() {
  testWidgets('ChartWidget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ChartWidget(),
    ));

    // Verify the existence of the ChartWidget
    expect(find.byType(ChartWidget), findsOneWidget);

    // Verify the existence of the chart text
    expect(find.text('Chart'), findsOneWidget);
  });
}
