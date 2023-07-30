import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/service_provider.dart';

class SuggestionsTasksScreen extends StatelessWidget {
  static const routeName = '/suggestions';

  const SuggestionsTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    // final contextProvider = Provider.of<ContextProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: FutureBuilder(
                    future: serviceProvider.getEmailsForAI(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Check if snapshot.data is not null before casting it to List<String>
                      if (snapshot.hasData && snapshot.data is List<String>) {
                        final emails = snapshot.data as List<String>;
                        return ListView.builder(
                          itemCount: emails.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(emails[index]),
                            );
                          },
                        );
                      } else {
                        // Handle the case when snapshot.data is null or not of type List<String>
                        return Center(
                          child: Lottie.asset(
                          'assets/animations/empty.json',
                          repeat: false,
                          height: 200
                          ),
                        );
                      }
                    },
                  ),
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
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: FutureBuilder(
                    future: serviceProvider.getEventsForAI(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Check if snapshot.data is not null before casting it to List<String>
                      if (snapshot.hasData && snapshot.data is List<String>) {
                        final tasks = snapshot.data as List<String>;
                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(tasks[index]),
                            );
                          },
                        );
                      } else {
                        // Handle the case when snapshot.data is null or not of type List<String>
                        return Center(
                          child: Lottie.asset(
                          'assets/animations/empty.json',
                          repeat: false,
                          height: 200
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}