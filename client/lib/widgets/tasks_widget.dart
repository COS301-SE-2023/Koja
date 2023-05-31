import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../Utils/constants_util.dart';
import '../Utils/event_data_source_util.dart';
import 'event_editing_widget.dart';
import 'event_provider.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    //This checks if the selected date has any events
    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text(
          'No events',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway'
          ),
        ),
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        // todayHighlightColor: Colors.blue,
        // todayTextStyle: const TextStyle(
        //   color: Colors.blue,
        //   fontWeight: FontWeight.bold,
        // ),
        timeTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      child: SfCalendar(
        dataSource: EventDataSource(provider.events),
        initialSelectedDate: provider.selectedDate,
        //Builds the events on the calendar
        appointmentBuilder: appointmentBuilder,
        initialDisplayDate: provider.selectedDate,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: const BoxDecoration(
          color: Color.fromARGB(0, 255, 0, 0),
          // border: Border.all(color: Colors.black, width: 2),
          // borderRadius: BorderRadius.circular(12),
        ),
        onTap: (details) {
          if (details.appointments == null) {
            return;
          }

          final event = details.appointments!.first;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventEditing(
                event: event,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget appointmentBuilder(
    BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          event.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Raleway'
          ),
        ),
      ),
    );
  }
}
