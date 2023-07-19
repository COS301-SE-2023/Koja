import 'package:client/widgets/time_category_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Utils/constants_util.dart';
import '../Utils/event_util.dart';
import '../providers/event_provider.dart';
import 'set_boundary_widget.dart';


class TimeBoundaries extends StatefulWidget {
  @override
  TimeBoundariesState createState() => TimeBoundariesState();
}

class TimeBoundariesState extends State<TimeBoundaries> {
  // late EventProvider eventProvider;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   eventProvider = Provider.of<EventProvider>(context);
  //   DateFormat format = DateFormat("h:mm a");
  //   for (var entry in eventProvider.timeSlots.entries) {
  //     if (entry.value != null) {
  //       categories.add([
  //         entry.key,
  //         format.format(entry.value!.startTime),
  //         format.format(entry.value!.endTime)
  //       ]);
  //     }
  //   }
  // }

  // general controller for all time pickers
  // late String start = '';
  // late String end = '';

  // index of list item which is being edited so that we can delete the current item and add the edited item
  int editedindex = 0;

  // selected option for dropdown
  late String selectedOption;

  // list of options for dropdown
  List<String> dropdownOptions = [
    'School',
    'Work',
    'Hobbies',
    'Resting',
    'Chores',
  ];

  // function to save time
  void saveTime() {

    if (start.isEmpty) {
      DateTime currentTime = DateTime.now();
      String formattedStartTime = DateFormat('HH:MM').format(currentTime);
      start = formattedStartTime;
    }

    if (end.isEmpty) {
      DateTime currentTime = DateTime.now();
      String formattedEndTime = DateFormat('HH:MM').format(currentTime);
      end = formattedEndTime;
    }

    DateFormat format = DateFormat("HH:MM");
    DateTime startTime = format.parse(start);
    DateTime endTime = format.parse(end);

    final timeSlot = TimeSlot(startTime: startTime, endTime: endTime);

    setState(() {
      // eventProvider.setTimeSlot(selectedOption, timeSlot);
      categories.removeWhere((element) => element[0] == selectedOption);
      categories.add([selectedOption, start, end]);

    });

    // If editing an item, remove the current item from the list and add the edited item
    if (editedindex >= 0) {
      // categories.removeAt(editedindex);
      editedindex = -1;
    }
  }

  void delete(int index) {
    setState(() {
      categories.removeAt(index);
      // eventProvider.setTimeSlot(categories[index][0], null);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedOption = dropdownOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionTile(
        trailing: Icon(
          Icons.arrow_drop_down,
        ),
        title: Text("Times Boundaries ", style: GoogleFonts.ubuntu(fontSize: 17)),
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
                Text(" Category:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Container(
                  height: 35,
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
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
                        return SetBoundary(selectedOption, start, end, saveTime);
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
                      showDialog(
                        context: context,
                        builder: (context) {                   
                          return SetBoundary(
                            categories[index][0],
                            start,
                            end,
                            saveTime,
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

// import 'package:client/widgets/time_category_list.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../Utils/constants_util.dart';
// import '../Utils/event_util.dart';
// import '../providers/event_provider.dart';
// import 'set_boundary_widget.dart';


// class TimeBoundaries extends StatefulWidget {
//   @override
//   TimeBoundariesState createState() => TimeBoundariesState();
// }

// class TimeBoundariesState extends State<TimeBoundaries> {
//   // late EventProvider eventProvider;

//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   //   eventProvider = Provider.of<EventProvider>(context);
//   //   DateFormat format = DateFormat("h:mm a");
//   //   for (var entry in eventProvider.timeSlots.entries) {
//   //     if (entry.value != null) {
//   //       categories.add([
//   //         entry.key,
//   //         format.format(entry.value!.startTime),
//   //         format.format(entry.value!.endTime)
//   //       ]);
//   //     }
//   //   }
//   // }

//   // general controller for all time pickers
//   late TextEditingController start = TextEditingController();
//   late TextEditingController end = TextEditingController();

//   // index of list item which is being edited so that we can delete the current item and add the edited item
//   int editedindex = 0;

//   // selected option for dropdown
//   late String selectedOption;

//   // list of options for dropdown
//   List<String> dropdownOptions = [
//     'School',
//     'Work',
//     'Hobbies',
//     'Resting',
//     'Chores',
//   ];

//   // function to save time
//   void saveTime() {
//   if (start.text.isEmpty) {
//     DateTime currentTime = DateTime.now();
//     String formattedStartTime = DateFormat('h:mm a').format(currentTime);
//     start = TextEditingController(text: formattedStartTime);
//   }

//   if (end.text.isEmpty) {
//     DateTime currentTime = DateTime.now();
//     String formattedEndTime = DateFormat('h:mm a').format(currentTime);
//     end = TextEditingController(text: formattedEndTime);
//   }

//   DateFormat format = DateFormat("h:mm a");
//   DateTime startTime = format.parse(start.text);
//   DateTime endTime = format.parse(end.text);

//   final timeSlot = TimeSlot(startTime: startTime, endTime: endTime);

//   setState(() {
//     // eventProvider.setTimeSlot(selectedOption, timeSlot);
//     categories.removeWhere((element) => element[0] == selectedOption);
//     categories.add([selectedOption, start.text, end.text]);

//   });

//   // If editing an item, remove the current item from the list and add the edited item
//   if (editedindex >= 0) {
//     // categories.removeAt(editedindex);
//     editedindex = -1;
//   }
// }

//   void delete(int index) {
//     setState(() {
//       categories.removeAt(index);
//       // eventProvider.setTimeSlot(categories[index][0], null);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     selectedOption = dropdownOptions[0];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: ExpansionTile(
//         trailing: Icon(
//           Icons.arrow_drop_down,
//         ),
//         title: Text("Times Boundaries ", style: GoogleFonts.ubuntu(fontSize: 17)),
//         subtitle: Text(
//           "Click here to add time boundaries for each category, select category and then click +\n\nAfter adding time boundary for a category, you can swipe to the left to edit or delete a boundary.",
//           style: GoogleFonts.ubuntu(fontSize: 12.5),
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(" Category:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(width: 8),
//                 Container(
//                   height: 35,
//                   width: 110,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: DropdownButton<String>(
//                     padding: EdgeInsets.all(5),
//                     underline: Container(
//                       height: 0,
//                     ),
//                     value: selectedOption,
//                     onChanged: (newValue) {
//                       setState(() {
//                         selectedOption = newValue!;
//                       });
//                     },
//                     items: dropdownOptions.map<DropdownMenuItem<String>>(
//                       (String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       },
//                     ).toList(),
//                   ),
//                 ),
//                 SizedBox(width: 2),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                       Colors.blue,
//                     ),
//                   ),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return SetBoundary(selectedOption, start, end, saveTime);
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: categories.length,
//             physics: ScrollPhysics(),
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   height: 83,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TimeCategory(
//                     categories[index][0],
//                     categories[index][1],
//                     categories[index][2],
//                     (context) {
//                       delete(index);
//                     },
//                     (context) {
//                       editedindex = index;
//                       showDialog(
//                         context: context,
//                         builder: (context) {                   
//                           return SetBoundary(
//                             categories[index][0],
//                             start,
//                             end,
//                             saveTime,
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }