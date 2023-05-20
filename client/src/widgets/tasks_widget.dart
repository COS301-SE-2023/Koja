import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../Utils/event_data_source_util.dart';
import 'event_provider.dart';
import 'event_viewing_widget.dart';

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
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialSelectedDate: provider.selectedDate,
        //Builds the events on the calendar
        appointmentBuilder: appointmentBuilder,
        initialDisplayDate: provider.selectedDate,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: const BoxDecoration(
          color: Colors.transparent,
          // border: Border.all(color: Colors.black, width: 2),
          // borderRadius: BorderRadius.circular(12),
        ),
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.appointments == null) {
           return;
          }

          final event = calendarTapDetails.appointments!.first;
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => EventViewing(event: event),
            ),
          );

        },
      ),

    );
    
  }

  Widget appointmentBuilder(
    BuildContext context, 
    CalendarAppointmentDetails calendarAppointmentDetails) {
      final event = calendarAppointmentDetails.appointments.first;
      return Container(
        width: calendarAppointmentDetails.bounds.width,
        height: calendarAppointmentDetails.bounds.height,
        decoration: BoxDecoration(
          color: event.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            event.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  }
}
