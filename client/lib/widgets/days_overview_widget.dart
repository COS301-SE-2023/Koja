import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/event_data_source_util.dart';
import '../providers/event_provider.dart';



class DaysOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;
    final dataSource = EventDataSource(events);

    // Find the day with the fewest tasks
    DateTime? dayWithFewestTasks;
    int minTaskCount = 0;
    for (final event in events) {
      final date = event.from;
      final tasksOnDate = events.where((e) => e.from.isAtSameMomentAs(date)).length;
      if (tasksOnDate < minTaskCount) {
        minTaskCount = tasksOnDate;
        dayWithFewestTasks = date;
      }
    }

    // Find the day with the most tasks
    DateTime? dayWithMostTasks;
    int maxTaskCount = minTaskCount;
    for (final event in events) {
      final date = event.from;
      final tasksOnDate = events.where((e) => e.from.isAtSameMomentAs(date)).length;
      if (tasksOnDate > maxTaskCount) {
        maxTaskCount = tasksOnDate;
        dayWithMostTasks = date;
      }
    }

    return Column(
      children: [
        Text('Day with Fewest Tasks: ${dayWithFewestTasks?.toString() ?? "None"}'),
        Text('Number of Tasks: $minTaskCount'),
        Text('Day with Most Tasks: ${dayWithMostTasks?.toString() ?? "None"}'),
        Text('Number of Tasks: $maxTaskCount'),
      ],
    );
  }
}
