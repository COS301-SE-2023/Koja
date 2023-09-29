import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Utils/event_data_source_util.dart';
import '../Utils/event_util.dart';
import '../providers/context_provider.dart';
import 'tasks_widget.dart';

class CalendarWidget extends StatefulWidget {

  final List<Event>? events;

  const CalendarWidget({super.key, this.events});

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<ContextProvider>(context);
    return SfCalendar(
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
      dataSource: (widget.events != null) ? EventDataSource(widget.events!) : EventDataSource(eventProvider.events),

      //This initialises the calendar to the current date
      initialSelectedDate: DateTime.now(),
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeIntervalHeight: 50,
        timeInterval: Duration(minutes: 30),
        timeFormat: 'HH:mm',
      ),

      //Save the date of the event when the user taps on the calendar
      onTap: (details) {
        final provider = Provider.of<ContextProvider>(context, listen: false);
        provider.setDate(details.date!);
        if(widget.events != null) {
          provider.setRecommended(widget.events!);
        }
        showModalBottomSheet(
            context: context, 
            builder: (context) => (widget.events != null) ? TasksWidget(date: details.date!,) : TasksWidget()
        );
      }
    );
  }
}
