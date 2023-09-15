import 'package:flutter/material.dart';
import 'package:koja/Utils/event_util.dart';
import 'package:lottie/lottie.dart';
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
  Widget? _suggestionsWidget;
  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    // final contextProvider = Provider.of<ContextProvider>(context, listen: false);
    final _mockEventList = List<Event>.empty(growable: true);
    final Event event1 = Event(
      title: 'Event 1',
      description: 'Event 1 Description',
      from: DateTime.now().add(Duration(hours: 2)),
      to: DateTime.now().add(Duration(hours: 4)),
      isAllDay: false,
      location: ""
    );
    _mockEventList.add(event1);
    final Event event2 = Event(
      title: 'Event 2',
      description: 'Event 2 Description',
      from: DateTime.now().add(Duration(hours: 5)),
      to: DateTime.now().add(Duration(hours: 7)),
      isAllDay: false,
      location: ""
    );
    _mockEventList.add(event2);
    //final mediaQuery = MediaQuery.of(context);
    // return Scaffold(
    //   body: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //
    //     children : [
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Container(
    //         height: 700,
    //         width: 1500,
    //         child: SfCalendar(
    //
    //           view: CalendarView.week,
    //           allowedViews: const [
    //             CalendarView.day,
    //             CalendarView.week,
    //             CalendarView.month,
    //           ],
    //
    //           dataSource: MeetingDataSource(_mockEventList),
    //           monthViewSettings: MonthViewSettings(
    //               appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    //           onTap: (CalendarTapDetails details) {
    //             if (details.targetElement == CalendarElement.appointment) {
    //
    //               final Event meeting = details.appointments![0] as Event;
    //               setState(() {
    //                 //meeting.isDynamic = meeting.isDynamic ? false : true;
    //                 //meeting.backgroundColor = meeting.isDynamic ? Colors.red : Colors.blue;
    //               });
    //               print(meeting.isDynamic);
    //             }
    //           },
    //         ),
    //       ),
    //
    //
    //       Padding(
    //         padding: const EdgeInsets.only(left: 10.0),
    //
    //         child: ElevatedButton(
    //           onPressed: () async {
    //             if (await serviceProvider.setSuggestedCalendar(_mockEventList)){
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text('Calendar Set Successfully'),
    //                 ),
    //               );
    //             } else {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text('Calendar Set Failed'),
    //                 ),
    //               );
    //             }
    //           },
    //           child: Text('Set Koja Calendar'),
    //
    //         ),
    //       ),
    //       SizedBox(
    //         height: 10,
    //       ),
    // ]  ),
    // );
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
                    //meeting.isDynamic = meeting.isDynamic ? false : true;
                    //meeting.backgroundColor = meeting.isDynamic ? Colors.red : Colors.blue;
                  });
                  print(meeting.isDynamic);
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