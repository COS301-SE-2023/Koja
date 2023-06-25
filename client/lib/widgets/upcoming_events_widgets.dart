import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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

    eventList.sort((a, b) {
      // Compare the dates first
      final dateTimeComparison = a.from.compareTo(b.from);
      return dateTimeComparison;
    });

    int itemCount = eventList.length; // Replace with your actual item count

    return Visibility(
      visible: itemCount > 0, // Show the ListView if itemCount is greater than 0
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final event = eventList[index];
          final FromformattedTime = DateFormat('HH: mm').format(event.from);
          final ToformattedTime = DateFormat('HH: mm').format(event.to);
          final formattedDate = DateFormat('EEEE, MMM d').format(event.from);
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title),
                Row(
                  children: [
                    Text(FromformattedTime),
                    const Text(' - '),
                    Text(ToformattedTime),
                  ],
                ),
              ],
            ),
          );
        }
      ),
      replacement: Lottie.asset(
        'assets/animations/empty.json',
        height: 150,
        width: 300,
        repeat: false,
      ),
    );

  }
}
