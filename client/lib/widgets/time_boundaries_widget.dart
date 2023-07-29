import 'package:client/widgets/time_category_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Utils/constants_util.dart';
import '../Utils/event_util.dart';
import '../providers/context_provider.dart';
import 'set_boundary_widget.dart';

class TimeBoundaries extends StatefulWidget {
  @override
  TimeBoundariesState createState() => TimeBoundariesState();
}

class TimeBoundariesState extends State<TimeBoundaries> {
  late ContextProvider eventProvider =
      Provider.of<ContextProvider>(context, listen: false);

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   eventProvider = Provider.of<EventProvider>(context);
  //   DateFormat format = DateFormat('HH:MM');
  //   for (var entry in eventProvider.timeSlots.entries) {
  //     if (entry.value != null) {
  //       categories.removeWhere((element) => element[0] == entry.key);
  //       categories.add([
  //         entry.key,
  //         format.format(entry.value!.startTime),
  //         format.format(entry.value!.endTime)
  //       ]);
  //     }
  //   }
  // }

  // selected option for dropdown
  late String selectedOption;

  /// list of options for dropdown
  List<String> dropdownOptions = [
    'School',
    'Work',
    'Hobbies',
    'Resting',
    'Chores',
    'Bed-Time'
  ];

  ///Function to trim start || end from TimeOfDay("HH:mm") to HH:mm
  String extractTime(String input) {
    int colonindex = input.indexOf(':');
    int startIndex = colonindex - 2;
    int endIndex = colonindex + 3;
    String timeValue = input.substring(startIndex, endIndex);

    return timeValue;
  }

  String _formatTime(int hour, int minute) {
    // Convert the hour and minute to a 24-hour format string
    String formattedHour = hour.toString().padLeft(2, '0');
    String formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute';
  }

  /// function to save timein the category list
  void saveTime({
    required ContextProvider contextProvider,
    required String itemName,
  }) {
    String currentDate = DateTime.now().toString().split(' ')[0];

    if (start.contains("TimeOfDay")) {
      start = extractTime(start);
    }
    if (end.contains("TimeOfDay")) {
      end = extractTime(end);
    }

    String startDateTimeStr = "$currentDate $start";
    String endDateTimeStr = "$currentDate $end";

    // Parse the combined strings into DateTime objects
    DateTime startTime = DateTime.parse(startDateTimeStr);
    DateTime endTime = DateTime.parse(endDateTimeStr);

    final timeSlot = TimeSlot(startTime: startTime, endTime: endTime);

    setState(() {
      contextProvider.setTimeSlot(itemName, timeSlot);
      categories.removeWhere((element) => element[0] == itemName);
      categories.add([itemName, start, end]);

      TimeOfDay now = TimeOfDay.now();

      start = _formatTime(now.hour, now.minute).toString();
      end = _formatTime(now.hour, now.minute).toString();
    });

    // If editing an item, remove the current item from the list and add the edited item
    if (editedindex >= 0) {
      // categories.removeAt(editedindex);
      editedindex = -1;
      isEditing = false;
    }
  }

  void delete(int index) {
    setState(() {
      eventProvider.setTimeSlot(categories[index][0], null);
      categories.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedOption = dropdownOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ContextProvider contextProvider =
        Provider.of<ContextProvider>(context);
    final storedEntries = contextProvider.timeSlots.entries;
    for (var entry in storedEntries) {
      if (entry.value != null) {
        categories.removeWhere((element) => element[0] == entry.key);
        categories.add([
          entry.key,
          extractTime(entry.value!.startTime.toString()),
          extractTime(entry.value!.endTime.toString())
        ]);
      }
    }
    return SingleChildScrollView(
      child: ExpansionTile(
        trailing: Icon(
          Icons.arrow_drop_down,
        ),
        title:
            Text("Times Boundaries ", style: GoogleFonts.ubuntu(fontSize: 17)),
        subtitle: Text(
          "Click here to add time boundaries for each category, select category and then click +\n\nAfter adding time boundary for a category, you can swipe to the left to edit or delete a boundary.",
          style: GoogleFonts.ubuntu(fontSize: 12.5),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(" Category:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Container(
                  height: 35,
                  width: screenSize.width * 0.4,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    padding: EdgeInsets.all(5),
                    underline: Container(
                      height: 0,
                    ),
                    value: selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                    items: dropdownOptions.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(width: 2),
                IconButton(
                  icon: Icon(Icons.add),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SetBoundary(
                          selectedOption,
                          start,
                          end,
                          () => saveTime(
                            contextProvider: contextProvider,
                            itemName: selectedOption,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 83,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TimeCategory(
                    categories[index][0],
                    categories[index][1],
                    categories[index][2],
                    (context) {
                      delete(index);
                    },
                    (context) {
                      editedindex = index;
                      isEditing = true;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SetBoundary(
                            categories[index][0],
                            categories[index][1],
                            categories[index][2],
                            () => saveTime(
                              contextProvider: contextProvider,
                              itemName: categories[index][0],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
