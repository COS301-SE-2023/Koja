import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';

class UpcomingEvents extends StatelessWidget {
  final EventProvider eventProvider;

  const UpcomingEvents({required this.eventProvider});

  @override
  Widget build(BuildContext context) {
    final events = eventProvider.events;
    final currentTime = DateTime.now();
    final upcomingEvents = events.where((event) => event.from.isAfter(currentTime)).toList();

    final eventList = upcomingEvents.take(5).toList();

    return ListView.builder(
      itemCount: eventList.length,
      itemBuilder: (context, index) {
        final event = eventList[index];
        final formattedTime = DateFormat('hh:mm a').format(event.from);
        return ListTile(
          title: Text(event.title),
          subtitle: Text(formattedTime),
          
        );
      },
    );
  }
}
