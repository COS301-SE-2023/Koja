import 'package:client/Utils/constants_util.dart';
import 'package:client/screens/suggestions_screens.dart';
import 'package:flutter/material.dart';

import '../widgets/calendar_widget.dart';
import '../widgets/event_editing_widget.dart';

class Tasks extends StatelessWidget {
  static const routeName = '/Tasks';

  const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tasks',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: darkBlue,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Suggestions'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const CalendarWidget()
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventEditing()),
            );
          },
          backgroundColor: darkBlue,
          child: const Icon(Icons.add),
        ),
    );
    
  }
  
}

