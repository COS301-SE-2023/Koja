import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../Utils/constants_util.dart';
import '../providers/context_provider.dart';

class UpcomingEvents extends StatelessWidget {
  final ContextProvider eventProvider;

  const UpcomingEvents({required this.eventProvider});

  @override
  Widget build(BuildContext context) {
    final events = eventProvider.events;
    final currentTime = DateTime.now();
    final upcomingEvents = events
        .where((event) =>
            event.from.isAfter(currentTime) ||
            (event.from.isBefore(currentTime) && event.to.isAfter(currentTime)))
        .toList();

    final eventList = upcomingEvents.take(6).toList();

    eventList.sort((a, b) {
      final dateTimeComparison = a.from.compareTo(b.from);
      return dateTimeComparison;
    });

    int itemCount = eventList.length;

    return Visibility(
      visible: itemCount > 0,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final event = eventList[index];
          final fromformattedTime = DateFormat('HH:mm').format(event.from);
          final toformattedTime = DateFormat('HH:mm').format(event.to);
          final formattedDate = DateFormat('EEEE').format(event.from);

          if (index == 0 &&
              eventList[index].from.isBefore(currentTime) &&
              eventList[index].to.isAfter(currentTime)) {
            return ListTile(
              leading: Container(
                height: 70,
                width: 50,
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    event.from.day.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formattedDate),
                  Row(
                    children: [
                      Text(fromformattedTime),
                      const Text(' - '),
                      Text(toformattedTime),
                    ],
                  ),
                ],
              ),
            );
          }
          return ListTile(
            leading: Container(
              height: 70,
              width: 50,
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  event.from.day.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedDate),
                Row(
                  children: [
                    Text(fromformattedTime),
                    const Text(' - '),
                    Text(toformattedTime),
                  ],
                ),
              ],
            ),
          );
        },
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
