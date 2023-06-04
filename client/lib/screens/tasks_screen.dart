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
            Tab(
              child: Text(
                'Current',
                style: TextStyle(color: Colors.white),
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
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CalendarWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const EventEditing();
            },
          );
        },
        backgroundColor: darkBlue,
        child: const Icon(Icons.add,
            color: Colors.white, 
            size: 25.0
        ),
    ),

    );
    
  }
  
}

