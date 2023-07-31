import 'package:flutter/material.dart';
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
                          maxHeight: mediaQuery.size.height * 0.3,
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
                child: _suggestionsWidget,
              ),
            ),
          ],
        ),
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
          if (suggestions[""].isDefinedAndNotNull) {
            suggestions["Other"] = suggestions[""];
            suggestions.remove("");
          }
          final suggestedEventCategories = suggestions.keys.toList();
          return SizedBox(
            height: mediaQuery.size.height * 0.3,
            child: ListView.builder(
              itemCount: suggestedEventCategories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    suggestedEventCategories[index],
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
