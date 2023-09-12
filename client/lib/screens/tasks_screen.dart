
import '../Utils/constants_util.dart';
import 'suggestions_screens.dart';
import 'package:flutter/material.dart';

import '../widgets/calendar_widget.dart';
import '../widgets/event_editing_widget.dart';

class Tasks extends StatefulWidget {
  static const routeName = '/Tasks';

  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Tasks',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: darkBlue,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current',
                      style: TextStyle(color: Colors.white),
                    ),
                    // if(isLoading)
                    //   SizedBox(width: 10),
                    //   SizedBox(
                    //     height: 15,
                    //     width: 15,
                    //     child: CircularProgressIndicator(
                    //       strokeWidth: 2.0,
                    //     ),
                    //   ),
                    // IconButton(
                    //   onPressed: () async {
                    //     String? accessToken = serviceProvider.accessToken;
                    //     await contextProvider.getEventsFromAPI(accessToken!);
                    //   },
                    //   icon: Icon(
                    //     Bootstrap.arrow_clockwise,
                    //     size: 20.0,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Tab(
                child: Text(
                  'Suggestions',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CurrentTasksScreen(),
            SuggestionsTasksScreen(),
          ],
        ),
      ),
    );
  }
}

class CurrentTasksScreen extends StatelessWidget {
  const CurrentTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EventEditing();
            },
          );
        },
        backgroundColor: darkBlue,
        child: const Icon(Icons.add, color: Colors.white, size: 25.0),
      ),
    );
  }
}
