import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Utils/constants_util.dart';
import '../providers/event_provider.dart';

import '../widgets/tasks_block_widget.dart';
import '../widgets/upcoming_events_widgets.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late EventProvider _eventProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the EventProvider instance from the provider
    _eventProvider = Provider.of<EventProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    int getEventsOnPresentDay() {
      // Get the selected date from the EventProvider
      final selectedDate = _eventProvider.selectedDate;

      // Calculate the start and end dates for the range
      final startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endDate = startDate.add(Duration(days: 1));

      // Filter the events to get the events within the range
      final eventsInRange = _eventProvider.eventsOfSelectedDate
          .where((event) =>
              event.from.isAfter(startDate) && event.from.isBefore(endDate))
          .toList();

      return eventsInRange.length;
    }



    int getEventsOnPresentWeek() {
      // Get the selected date from the EventProvider
      final selectedDate = _eventProvider.selectedDate;

      // Determine the first day of the week based on your configuration
      const int mondayIndex = 1;
      final int firstDayOfWeek = (DateTime.monday + 7 - mondayIndex) % 7;

      // Calculate the start and end dates of the present week
      final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - firstDayOfWeek));
      final endOfWeek = selectedDate.add(Duration(days: 7 - selectedDate.weekday));

      // Filter the events to get the events within the present week (date part only)
      final eventsOnPresentWeek = _eventProvider.events.where((event) {
        final eventDate = DateTime(event.from.year, event.from.month, event.from.day);
        return eventDate.isAfter(startOfWeek) && eventDate.isBefore(endOfWeek);
      }).toList();

      return eventsOnPresentWeek.length;
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkBlue,
        actions: [
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TaskOverviewBlock()
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*  The First Block which gives a summary of the tasks pending and total*/
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 75,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TasksBlock(
                    todayTasks: getEventsOnPresentDay(),weekTasks: getEventsOnPresentWeek(),
                  )
                ),
              ),
              /*  The Second Block which gives a least busy and busiest day of the week */
              // Center(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width * 0.95,
              //     height: 75,
              //     margin: const EdgeInsets.all(4.0),
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: const BusyDaysBlock(),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: UpcomingHeader()
          ),
          Center(child: events(context)),
        ],
      ),
    );

  }

  Expanded events(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: UpcomingEvents(eventProvider: _eventProvider,),
          ),
        ),
      ),
    );
  }
}

class TaskOverviewBlock extends StatelessWidget {
  const TaskOverviewBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          'Tasks Overview',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class UpcomingHeader extends StatelessWidget {
  const UpcomingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          'Upcoming Tasks',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}