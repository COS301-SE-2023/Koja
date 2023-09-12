
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../Utils/constants_util.dart';
import './navigation_management_screen.dart';
import 'suggestions_screens.dart';
import 'package:flutter/material.dart';

import '../providers/context_provider.dart';
import '../providers/service_provider.dart';
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
    final contextProvider = Provider.of<ContextProvider>(context);
    final serviceProvider = Provider.of<ServiceProvider>(context);
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
                    IconButton(
                      onPressed: () async {
                        String? accessToken = serviceProvider.accessToken;
                        
                        // Call getEventsFromAPI and await the result
                         await contextProvider.getEventsFromAPI(accessToken!);  
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              body: NavigationScreen(initialIndex: 1),
                            ),
                          ),
                        );
                        const snackBar = SnackBar(
                          content: Text('Page refreshed!'),
                          duration: Duration(seconds: 5));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);  
                      },
                      icon: Icon(
                        Bootstrap.arrow_clockwise,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
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
