// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class settingslist extends StatefulWidget {
  const settingslist({super.key});

  @override
  _settingslistState createState() => _settingslistState();
}

class _settingslistState extends State<settingslist> {
  List<String> parentItems = [
    'Upcoming Events',
    'Suggested Events',
    'Completed Events'
  ];
  Map<String, List<Widget>> childItems = {
    'Upcoming Events': [
      Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color: Colors.deepPurple,
        ),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: const Text('Attend Scrum asjhasjsaj',
              style: TextStyle(color: Colors.black)),
        ),
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color: Colors.deepPurple,
        ),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: const Text('Complete Sprint 1',
              style: TextStyle(color: Colors.black)),
        ),
      ),
    ],
    'Suggested Events': [
      Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color: Colors.deepPurple,
        ),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: const Text('Complete Project Task 1',
              style: TextStyle(color: Colors.black)),
        ),
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color: Colors.deepPurple,
        ),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: const Text('Attend Scrum Meeting',
              style: TextStyle(color: Colors.black)),
        ),
      ),
    ],
    'Completed Events': [
      Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color: Colors.deepPurple,
        ),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: const Text('Understand Flutter Layouts',
              style: TextStyle(color: Colors.black)),
        ),
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color: Colors.deepPurple,
        ),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: const Text('Get Started with Flutter',
              style: TextStyle(color: Colors.black)),
        ),
      ),
    ],
  };

  List<bool> isExpandedList = List<bool>.filled(3, false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: parentItems.length,
        itemBuilder: (context, index) {
          final parentItem = parentItems[index];
          final children = childItems[parentItem];

          return ExpansionTile(
            title: Text(parentItem,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                )),
            initiallyExpanded: isExpandedList[index],
            onExpansionChanged: (value) {
              setState(() {
                isExpandedList[index] = value;
              });
            },
            children: children!.toList(),
          );
        },
      ),
    );
  }
}
