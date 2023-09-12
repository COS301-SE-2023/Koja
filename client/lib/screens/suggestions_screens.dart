import 'package:flutter/material.dart';
import 'package:koja/Utils/event_util.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Emails In System',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: FutureBuilder(
                future: serviceProvider.getEmailsForAI(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Check if snapshot.data is not null before casting it to List<String>
                  if (snapshot.hasData &&
                      snapshot.data is Map<String, dynamic> &&
                      (snapshot.data as Map<String, dynamic>).isNotEmpty) {
                    final accounts = (snapshot.data as Map<String, String>);
                    final emails = accounts.values.toList();
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: mediaQuery.size.height * 0.25,
                      ),
                      child: ListView.builder(
                        itemCount: emails.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(emails[index]),
                            trailing: InkWell(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'More Info',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _suggestionsWidget = createWidget(
                                    accounts.keys.toList()[index],
                                    context,
                                    serviceProvider,
                                    mediaQuery,
                                  );
                                });
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // Handle the case when snapshot.data is null or not of type List<String>
                    return Center(
                      child: Lottie.asset('assets/animations/empty.json',
                          repeat: false, height: 200),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Suggested Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                child: _suggestionsWidget,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton(
              onPressed: () async {
                final eventList = List<Event>.empty(growable: true);
                final Event event1 = Event(
                  title: 'Event 1',
                  description: 'Event 1 Description',
                  from: DateTime.now().add(Duration(hours: 2)),
                  to: DateTime.now().add(Duration(hours: 4)),
                  isAllDay: false,
                  location: ""

                );
                eventList.add(event1);
                final Event event2 = Event(
                  title: 'Event 2',
                  description: 'Event 2 Description',
                  from: DateTime.now().add(Duration(hours: 5)),
                  to: DateTime.now().add(Duration(hours: 7)),
                  isAllDay: false,
                  location: ""
                );
                eventList.add(event2);

                if (await serviceProvider.setSuggestedCalendar(eventList)){
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

            ),
          ),
        ],
      ),
    );
  }

  createWidget(
    String user,
    BuildContext context,
    ServiceProvider serviceProvider,
    MediaQueryData mediaQuery,
  ) {
    return FutureBuilder(
      future: serviceProvider.getSuggestionsForUser(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Check if snapshot.data is not null before casting it to List<String>
        if (snapshot.hasData &&
            snapshot.data is Map<String, dynamic> &&
            (snapshot.data as Map<String, dynamic>).isNotEmpty) {
          final suggestions = snapshot.data as Map<String, dynamic>;
          if (suggestions[""] != null) {
            suggestions["Other"] = suggestions[""];
            suggestions.remove("");
          }
          final suggestedEventCategories = suggestions.keys.toList();

          return SizedBox(
            height: mediaQuery.size.height * 0.3,
            width: double.infinity,
            child: ListView.builder(
              itemCount: suggestedEventCategories.length,
              itemBuilder: (context, index) {
                final currentItem = suggestedEventCategories[index];
                final curentItemValue =
                    suggestions[currentItem] as Map<String, dynamic>;
                final weekdays = curentItemValue["weekdays"].cast<String>();
                final timeFrames = curentItemValue['timeFrames'].cast<String>();
                return ListTile(
                  title: Text(
                    suggestedEventCategories[index],
                  ),
                  trailing: InkWell(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'More Info',
                          style: TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              suggestedEventCategories[index],
                            ),
                            content: Table(
                              defaultColumnWidth: IntrinsicColumnWidth(),
                              border: TableBorder.all(),
                              children: weekdays.map<TableRow>(
                                (weekday) {
                                  int i = weekdays.indexOf(weekday);
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(weekday.toString()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(i < timeFrames.length
                                            ? timeFrames[i].toString()
                                            : 'N/A'),
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        } else {
          // Handle the case when snapshot.data is null or not of type List<String>
          return Center(
            child: Lottie.asset('assets/animations/empty.json',
                repeat: false, height: 200),
          );
        }
      },
    );
  }
}
