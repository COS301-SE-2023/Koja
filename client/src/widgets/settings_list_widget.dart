// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'time_picker_widget.dart';

class settingslist extends StatefulWidget {
  const settingslist({super.key});

  @override
  _settingslistState createState() => _settingslistState();
}

class _settingslistState extends State<settingslist> {
  bool _customTileExpanded = false;
  static const div = Divider(
    thickness: 0,
    height: 2,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: <Widget>[
          //First Expansion Tile[Time Picker]
          SingleChildScrollView(
            padding: EdgeInsets.all(0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              color: ThemeData.light().primaryColor,
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(Icons.watch_sharp, color: Colors.white, size: 30),
                title: const Text('Active Times',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                subtitle: const Text('Times for Work and Personal Activities',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                children: const [
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 1,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(
                        height: 120,
                        //Work Time Column
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Work Time:",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  'Start Time :',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                TimePickerWidget(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  'End Time   :',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                TimePickerWidget(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Personal Time:",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Start Time :',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                TimePickerWidget(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'End Time   :',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                TimePickerWidget(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _customTileExpanded = expanded;
                  });
                },
              ),
            ),
          ),

          //Divider
          SizedBox(
            height: 10,
          ),

          //Second Expansion Tile[Location Picker]
          SingleChildScrollView(
            padding: EdgeInsets.all(0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              color: ThemeData.light().primaryColor,
              child: ExpansionTile(
                leading: Icon(Icons.location_city_outlined,
                    color: Colors.white, size: 30),
                title: const Text('Location',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                subtitle: const Text('Your Home and Work Locations',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                
                children: [
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 1,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 100,
                    child: Text(
                      "Work Location",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Text(
                      "Home Location",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _customTileExpanded = expanded;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
