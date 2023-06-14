// import 'dart:html';

import 'package:flutter/material.dart';

// import '../Utils/event_data_source_util.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  ChartWidgetState createState() => ChartWidgetState();
}

class ChartWidgetState extends State<ChartWidget> {
  final List<ChartData> data = [
    ChartData('Mon', 5),
    ChartData('Tue', 25),
    ChartData('Wed', 100),
    ChartData('Thu', 75),
    ChartData('Fri', 40),
    ChartData('Sat', 55),
    ChartData('Sun', 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Column(
            children: [
              Text('Chart'),
              // Assuming you have an instance of EventDataSource called eventDataSource
                // EventDataSource eventDataSource = EventDataSource(List<Event> source);
                // int totalEvents = eventDataSource.appointments?.length ?? 0;
                // print('Total events in the calendar: $totalEvents');

            ],
          ),
        ),
    );
  }
}

class ChartData{
  late final String day;
  late final int value;
  ChartData(this.day, this.value);
}