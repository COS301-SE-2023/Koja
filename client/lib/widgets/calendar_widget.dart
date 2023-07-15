import 'package:client/widgets/event_viewing_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Utils/event_data_source_util.dart';
import '../Utils/event_util.dart';
import '../providers/event_provider.dart';
import 'tasks_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

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

          // Event event = provider.getEventByDate(details.date!);

          // showModalBottomSheet(
          //   showDragHandle: true,
          //   isDismissible: true,
          //   isScrollControlled: true,
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(20.0),
          //       topRight: Radius.circular(20.0),
          //     ),
          //   ),
          //   context: context,
          //   builder: (context) => EventViewing(event: event),
          // );
        });
  }
}
