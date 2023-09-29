import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koja/Utils/event_util.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../providers/service_provider.dart';
import '../widgets/calendar_widget.dart';

class SuggestionsTasksScreen extends StatefulWidget {
  static const routeName = '/suggestions';

  const SuggestionsTasksScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionsTasksScreen> createState() => _SuggestionsTasksScreenState();
}

class _SuggestionsTasksScreenState extends State<SuggestionsTasksScreen> {
  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    // final contextProvider = Provider.of<ContextProvider>(context, listen: false);
    final mockEventList = List<Event>.empty(growable: true);
    final Event event1 = Event(
      title: 'Event 1',
      description: 'Event 1 Description',
      from: DateTime.now().add(Duration(hours: 2)),
      to: DateTime.now().add(Duration(hours: 4)),
      isAllDay: false,
      location: ""
    );
    mockEventList.add(event1);
    final Event event2 = Event(
      title: 'Event 2',
      description: 'Event 2 Description',
      from: DateTime.now().add(Duration(hours: 5)),
      to: DateTime.now().add(Duration(hours: 7)),
      isAllDay: false,
      location: ""
    );
    mockEventList.add(event2);
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
      body: FutureBuilder(
        future: serviceProvider.getEventsForAI("3252"),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty)
          {
            final mockEventList = snapshot.data;
            return CalendarStack(mockEventList: mockEventList!, serviceProvider: serviceProvider,);
          }
          else
          {
            return Center(
              child: Text('Koja\'s suggestion engine is still learning.\nPlease try again soon.'),
            );
          }
        }
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

class CalendarStack extends StatefulWidget {
  final ServiceProvider serviceProvider;
  final List<List<Event>> mockEventList;

  CalendarStack({required this.serviceProvider, required this.mockEventList});

  @override
  CalendarStackState createState() => CalendarStackState();
}

class CalendarStackState extends State<CalendarStack> {
  int index = 0;
  bool back = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContextProvider>(context);
    final allEvents = (provider.lockedEvents.isNotEmpty) 
    ? widget.mockEventList.where((element) => provider.lockedEvents.every((item) => element.contains(item))).toList()
    : widget.mockEventList;

    if(index > 0 && index < widget.mockEventList.length - 1){
      back = true;
    }
    else{
      back = false;
    }
    return allEvents.isNotEmpty ? Stack(
      children: [
        CalendarWidget(events: allEvents[index],),
        Positioned(
          bottom: 15.0,
          left: 50.0,
          child: ElevatedButton(
            onPressed: () async {
              if (await widget.serviceProvider.setSuggestedCalendar(allEvents[index])){
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
        Positioned(
          bottom: 15.0,
          right: 25.0,
          child: IconButton(
            onPressed: () async {
              if(index < widget.mockEventList.length - 1){
                setState(() {
                  index++;
                });
              }
              else{
                setState(() {
                  index = 0;
                });
              }
            },
            icon: Icon(Icons.arrow_forward_ios_rounded),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
          ),
        ),
        Positioned(
          bottom: 15.0,
          right: 70.0,
          child: IconButton(
            onPressed: (back) ? () async {
              if(index < widget.mockEventList.length - 1){
                setState(() {
                  index++;
                });
              }
              else{
                setState(() {
                  index = 0;
                });
              }
            } : null,
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
          ),
        ),
      ],
    ) : Center(
      child: Wrap(
        children: [
          Column(
            children: [
              Text('No permutations exist for your choices.'),
              ElevatedButton(onPressed: ()
              {
                provider.clearLockedEvents();
              }, child: Text('Start Over'))
            ],
          ),
        ],
      ),
    );
  }
}
