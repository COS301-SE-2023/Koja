import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Utils/event_data_source_util.dart';
import 'event_provider.dart';
import 'tasks_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
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

      //Save the date of the userEvent when the user taps on the calendar
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