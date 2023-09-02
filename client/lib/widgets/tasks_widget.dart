import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../Utils/constants_util.dart';
import '../Utils/event_data_source_util.dart';
import '../providers/context_provider.dart';
import 'event_editing_widget.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  TasksWidgetState createState() => TasksWidgetState();
}

class TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContextProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    DateTime selectedDate = DateTime(
      provider.selectedDate.year,
      provider.selectedDate.month,
      provider.selectedDate.day,
    );

    var count = 0;

    for (var event in selectedEvents) {
        DateTime eventDate = event.from;
        DateTime eventDay = DateTime(eventDate.year, eventDate.month, eventDate.day);

        if (eventDay == selectedDate) {
          count++;
        }
    }

    if (count == 0) {
      return Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'No Tasks Found',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/animations/empty.json',
              height: 200,
              width: 300,
            ),
          ),
        ],
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      child: SfCalendar(
        dataSource: EventDataSource(provider.events),
        initialSelectedDate: provider.selectedDate,

        timeSlotViewSettings: TimeSlotViewSettings(
          timeIntervalHeight: 60,
          timeInterval: Duration(minutes: 30),
          timeFormat: 'HH:mm',
        ),
        //Builds the events on the calendar
        appointmentBuilder: appointmentBuilder,

        initialDisplayDate: provider.selectedDate,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: const BoxDecoration(
          color: Color.fromARGB(0, 255, 0, 0),
        ),
        onTap: (details) {
          if (details.appointments == null) {
            return;
          }

          final userEvent = details.appointments!.first;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EventEditing(event: userEvent);
            },
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
              color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),
        ),
      ),
    );
  }
}
