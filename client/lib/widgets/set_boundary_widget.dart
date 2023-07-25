import 'package:flutter/material.dart';
import '../Utils/constants_util.dart';

class SetBoundary extends StatefulWidget {
  final VoidCallback onSave;
  final String selectedOption;
  late String? startTime;
  late String? endTime;

  SetBoundary(
    this.selectedOption,
    this.startTime,
    this.endTime,
    this.onSave, {
    Key? key,
  });

  @override
  State<SetBoundary> createState() => _SetBoundaryState();
}

class _SetBoundaryState extends State<SetBoundary> {
  @override
  Widget build(BuildContext context) {
    String initstart = "";
    String initend = "";

    if (isEditing == false) {
      initstart = start;
      initend = end;
    } else {
      initstart = categories[editedindex][1];
      initend = categories[editedindex][2];
    }
    return AlertDialog(
      content: Container(
        height: 180,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            Text(
              widget.selectedOption.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Start Time",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        child: SelectedTimeButton(
                          time: widget.startTime = initstart,
                          onTimeChanged: (time) {
                            setState(() {
                              start = time;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "End Time",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        child: SelectedTimeButton(
                          time: widget.endTime = initend,
                          onTimeChanged: (time) {
                            setState(() {
                              end = time;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onSave();
                    Navigator.of(context).pop();
                  },
                  child: Text("Save"),
                ),
                const SizedBox(width: 3),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SelectedTimeButton extends StatefulWidget {
  final String time;
  final ValueChanged<String> onTimeChanged;

  SelectedTimeButton({required this.time, required this.onTimeChanged});

  @override
  SelectedTimeButtonState createState() => SelectedTimeButtonState();
}

class SelectedTimeButtonState extends State<SelectedTimeButton> {
  late TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    selectedTime = _parseTime(widget.time);
  }

  void _onPressed() async {
    var time = await selectTime(context);
    if (time != null) {
      setState(() {
        selectedTime = time;
        widget.onTimeChanged(_formatTime(time));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      child: Text(_formatTime(selectedTime)),
    );
  }

  Future<TimeOfDay?> selectTime(BuildContext context) async {
    var selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    return selectedTime;
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1].split(" ")[0]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}



// import 'package:client/Utils/constants_util.dart';
// import 'package:flutter/material.dart';

// class SetBoundary extends StatefulWidget {
//   final VoidCallback onSave;
//   final String selectedOption;

//   final TextEditingController start;
//   final TextEditingController end;

//   SetBoundary(this.selectedOption, this.start, this.end, this.onSave,
//       {Key? key});

//   @override
//   State<SetBoundary> createState() => _SetBoundaryState();
// }

// class _SetBoundaryState extends State<SetBoundary> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: Container(
//         height: 180,
//         width: MediaQuery.of(context).size.width * 0.7,
//         child: Column(
//           children: [
//             Text(
//               widget.selectedOption.toUpperCase(),
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 15),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Start Time",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       SizedBox(
//                         child: SelectedTimeButton(controller: widget.start),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "End Time",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       SizedBox(
//                         child: SelectedTimeButton(controller: widget.end),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     widget.onSave();
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("Save"),
//                 ),
//                 const SizedBox(width: 3),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("Cancel"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SelectedTimeButton extends StatefulWidget {
//   final TextEditingController controller;

//   SelectedTimeButton({required this.controller});

//   @override
//   SelectedTimeButtonState createState() => SelectedTimeButtonState();
// }

// class SelectedTimeButtonState extends State<SelectedTimeButton> {
//   late TimeOfDay selectedTime = TimeOfDay.now();

//   void _onPressed() async {
//     var time = await selectTime(context);
//     if (time != null) {
//       setState(() {
//         selectedTime = time;
//         widget.controller.text = time.format(context);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _onPressed,
//       child: Text(selectedTime.format(context)),
//     );
//   }

//   Future<TimeOfDay?> selectTime(BuildContext context) async {
//     if(isEditing == false)
//     {
//         var selectedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//         builder: (BuildContext context, Widget? child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//             child: child!,
//           );
//         },
//       );
//       return selectedTime;
//     }
//     else
//     {
//       var selectedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay(hour: int.parse(widget.controller.text.split(":")[0]), minute: int.parse(widget.controller.text.split(":")[1].split(" ")[0])),
//         builder: (BuildContext context, Widget? child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//             child: child!,
//           );
//         },
//       );
//       return selectedTime;
//     }
    
//   }
// }