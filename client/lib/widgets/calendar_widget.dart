import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Utils/event_data_source_util.dart';
<<<<<<< HEAD
import 'event_provider.dart';
=======
import '../providers/event_provider.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
import 'tasks_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
<<<<<<< HEAD
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {

=======
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return SfCalendar(
<<<<<<< HEAD
      //This sets the view of the calendar to month view
      view: CalendarView.month,

      showNavigationArrow: true,
      showDatePickerButton: true,
      showWeekNumber: true,

      allowDragAndDrop: true,

      //Ths displays the events on the calendar
      dataSource: EventDataSource(events),

      //This initialises the calendar to the current date
      initialSelectedDate: DateTime.now(),

      //Save the date of the event when the user taps on the calendar
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context, 
          builder: (context) => const TasksWidget()
        );
      }

    );
  }
}
=======
        //This sets the view of the calendar to month view

        view: CalendarView.week,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
        ],
        initialDisplayDate: DateTime.now(),
        showNavigationArrow: true,
        allowDragAndDrop: true,
        firstDayOfWeek: 1,

        //Ths displays the events on the calendar
        dataSource: EventDataSource(eventProvider.events),

        //This initialises the calendar to the current date
        initialSelectedDate: DateTime.now(),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: 50,
          timeInterval: Duration(minutes: 30),
          timeFormat: 'HH:mm',
        ),

        //Save the date of the event when the user taps on the calendar
        onTap: (details) {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.setDate(details.date!);
          showModalBottomSheet(
              context: context, builder: (context) => const TasksWidget());
        });
  }
}
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
