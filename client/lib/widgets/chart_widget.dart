import 'package:flutter/material.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
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
          child: Text('Chart'),
        ),
    );
  }
}

class ChartData{
  late final String day;
  late final int value;
  ChartData(this.day, this.value);
}