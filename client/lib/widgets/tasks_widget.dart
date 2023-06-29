import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:lottie/lottie.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../Utils/constants_util.dart';
import '../Utils/event_data_source_util.dart';
<<<<<<< HEAD
import 'event_editing_widget.dart';
import 'event_provider.dart';
=======
import '../providers/event_provider.dart';
import 'event_editing_widget.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
<<<<<<< HEAD
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
=======
  TasksWidgetState createState() => TasksWidgetState();
}

class TasksWidgetState extends State<TasksWidget> {
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    //This checks if the selected date has any events
    if (selectedEvents.isEmpty) {
<<<<<<< HEAD
      return const Center(
        child: Text(
          'No events',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
=======
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
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
<<<<<<< HEAD
        // todayHighlightColor: Colors.blue,
        // todayTextStyle: const TextStyle(
        //   color: Colors.blue,
        //   fontWeight: FontWeight.bold,
        // ),
=======
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        timeTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      child: SfCalendar(
<<<<<<< HEAD
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialSelectedDate: provider.selectedDate,
=======
        dataSource: EventDataSource(provider.events),
        initialSelectedDate: provider.selectedDate,

        timeSlotViewSettings: TimeSlotViewSettings(
          timeIntervalHeight: 60,
          timeInterval: Duration(minutes: 30),
          timeFormat: 'HH:mm',
        ),
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        //Builds the events on the calendar
        appointmentBuilder: appointmentBuilder,
        initialDisplayDate: provider.selectedDate,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: const BoxDecoration(
<<<<<<< HEAD
          color: Colors.transparent,
          // border: Border.all(color: Colors.black, width: 2),
          // borderRadius: BorderRadius.circular(12),
=======
          color: Color.fromARGB(0, 255, 0, 0),
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        ),
        onTap: (details) {
          if (details.appointments == null) {
            return;
          }

<<<<<<< HEAD
          final event = details.appointments!.first;
=======
          final userEvent = details.appointments!.first;
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventEditing(
<<<<<<< HEAD
                event: event,
=======
                event: userEvent,
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
              ),
            ),
          );
        },
      ),
    );
  }

  Widget appointmentBuilder(
<<<<<<< HEAD
      BuildContext context, CalendarAppointmentDetails details) {
=======
    BuildContext context, CalendarAppointmentDetails details) {
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: darkBlue,
<<<<<<< HEAD
        borderRadius: BorderRadius.circular(12),
=======
        borderRadius: BorderRadius.circular(8),
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
      ),
      child: Center(
        child: Text(
          event.title,
          style: const TextStyle(
            color: Colors.white,
<<<<<<< HEAD
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
=======
            fontSize: 15,
            fontFamily: 'Raleway'
          ),
        ),     
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
      ),
    );
  }
}
