import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Utils/constants_util.dart';
import '../providers/event_provider.dart';
import 'package:icons_plus/icons_plus.dart';

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

  int getEventsOnPresentDay() {
    // Get the selected date from the EventProvider
    final selectedDate = _eventProvider.selectedDate;

    // Filter the events to get the events on the selected date
    final eventsOnSelectedDate = _eventProvider.eventsOfSelectedDate
        .where((event) =>
            event.from.year == selectedDate.year &&
            event.from.month == selectedDate.month &&
            event.from.day == selectedDate.day)
        .toList();

    return eventsOnSelectedDate.length;
  }

  int getEventsOnPresentWeek() {
    // Get the selected date from the EventProvider
    final selectedDate = _eventProvider.selectedDate;

    // Calculate the start and end dates of the present week
    final startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final endOfWeek =
        selectedDate.add(Duration(days: 7 - selectedDate.weekday));

    // Filter the events to get the events within the present week
    final eventsOnPresentWeek = _eventProvider.events
        .where((event) =>
            event.from.isAfter(startOfWeek) && event.from.isBefore(endOfWeek))
        .toList();

    return eventsOnPresentWeek.length;
  }

  @override
  Widget build(BuildContext context) {
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
          // ChangeTheme()
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
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 75,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const BusyDaysBlock(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: UpcomingHeader()
          ),
          events(context),
        ],
      ),
    );
  }

  Expanded events(BuildContext context) {
    EventProvider? events;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.all(4.0),
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
          'Upcoming Events',
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



/*  The Second Block which gives a summary of the Days with tight and flexible schedules */
class BusyDaysBlock extends StatelessWidget {
  const BusyDaysBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Bootstrap.activity,
                      color: Colors.black,
                      size: 26,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Busiest Day",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          'Tuesday',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Bootstrap.battery_charging,
                      color: Colors.black,
                      size: 26,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Least Busy Day",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          'Sunday',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
