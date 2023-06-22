import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../Utils/constants_util.dart';
import '../Utils/event_data_source_util.dart';
import '../providers/event_provider.dart';
import 'event_editing_widget.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  TasksWidgetState createState() => TasksWidgetState();
}

class TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    //This checks if the selected date has any events
    if (selectedEvents.isEmpty) {
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
                  fontFamily: 'Raleway'
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/animations/empty.json',
              height: 200, width: 300,
              // repeat: false,
            ),
          ),
        ],
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
      child: Column(
        children: [
          Center(
            child: Text(
              event.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Raleway'
              ),
            ),
            
          ),
          Expanded(
            child: Center(
              child: Text(
                event.location,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Raleway'
                ),
                maxLines: 1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
