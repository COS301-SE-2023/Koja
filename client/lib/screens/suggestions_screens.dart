import 'package:flutter/material.dart';
import 'package:koja/Utils/event_util.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../providers/service_provider.dart';

class SuggestionsTasksScreen extends StatefulWidget {
  static const routeName = '/suggestions';

  const SuggestionsTasksScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionsTasksScreen> createState() => _SuggestionsTasksScreenState();
}

class _SuggestionsTasksScreenState extends State<SuggestionsTasksScreen> {

  final List<Event> _mockEventList = <Event>[
    Event(
        title: 'Event 1',
        description: 'Event 1 Description',
        from: DateTime.now().add(Duration(hours: 2)),
        to: DateTime.now().add(Duration(hours: 4)),
        isAllDay: false,
        location: "",
        backgroundColor: Colors.red,
        isDynamic: false),
    Event(
        title: 'Event 2',
        description: 'Event 2 Description',
        from: DateTime.now().add(Duration(hours: 5)),
        to: DateTime.now().add(Duration(hours: 7)),
        isAllDay: false,
        location: "",
        backgroundColor: Colors.red,
        isDynamic: false),
  ];

  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    // final contextProvider = Provider.of<ContextProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SfCalendar(
              view: CalendarView.week,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
              ],
              dataSource: MeetingDataSource(_mockEventList),
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.appointment) {

                  final Event meeting = details.appointments![0] as Event;
                  setState(() {
                    //meeting.changeColor();
                    if (meeting.backgroundColor == Colors.blue){
                      meeting.backgroundColor = Colors.red;
                      meeting.isLocked = true;
                    }else {
                      meeting.backgroundColor = Colors.blue;
                      meeting.isLocked = false;
                    }
                  });

                }
              },
            ),
          ),
          Positioned(
            bottom: 15.0,
            right: 15.0,
            child: ElevatedButton(
              onPressed: () async {
                if (await serviceProvider.setSuggestedCalendar(_mockEventList)){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calendar Set Successfully'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calendar Set Failed'),
                    ),
                  );
                }
              },
              child: Text('Set Koja Calendar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );



  }

}


class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].backgroundColor;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}