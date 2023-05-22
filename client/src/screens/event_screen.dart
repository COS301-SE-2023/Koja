// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_print

import 'package:flutter/material.dart';

import '../widgets/event_list_widget.dart';
import 'navigation_management_screen.dart';

class Event extends StatelessWidget {
  static const routeName = '/event';
  final List<String> repitition = [
    'Recurring',
    'Once-Off',
  ];

  Event({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true,
      ),
      body: EventModal(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            builder: (context) {
              return Container(
                height: 400.0,
                color: Color.fromARGB(255, 135, 18, 194),
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name :',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter Event Name',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                decorationColor: Colors.white,
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 115, 32, 154),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    // ignore: prefer_const_constructors
                    Column(
                      children: const [
                        Row(
                          children: [
                            Text(
                              'Type:',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(width: 10.0),
                            // 2 recurring and once off radio buttons
                            // Center(
                            //   child: DropdownButton<String>(
                            //       value: repitition[0], // Set the initial value
                            //       repitition: repitition.map((String value) {
                            //         return DropdownMenuItem<String>(
                            //           value: value,
                            //           child: Text(value),
                            //         );
                            //       }).toList(),
                            //       onChanged: (String newValue) {
                            //         // Handle dropdown value change
                            //         // print(newValue); // Print the selected value
                            //       },
                            //     ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Color.fromARGB(255, 135, 18, 194),
        child: Icon(Icons.add),
      ),
    );
  }
}
