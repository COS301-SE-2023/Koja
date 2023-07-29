import 'package:flutter/material.dart';
import '../Utils/constants_util.dart';

class SetBoundary extends StatefulWidget {
  final VoidCallback onSave;
  final String selectedOption;
  late String? startTime;
  late String? endTime;

  String initstart = "";
  String initend = "";

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
  void initState() {
    super.initState();
    if (isEditing == false) {
      widget.initstart = start;
      widget.initend = end;
    } else {
      widget.initstart = start = categories[editedindex][1];
      widget.initend = end = categories[editedindex][2];
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          isStart: true,
                          time: widget.startTime = widget.initstart,
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
                          isStart: false,
                          time: widget.endTime = widget.initend,
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
  final bool isStart;

  SelectedTimeButton(
      {required this.time, required this.onTimeChanged, required this.isStart});

  @override
  SelectedTimeButtonState createState() => SelectedTimeButtonState();
}

class SelectedTimeButtonState extends State<SelectedTimeButton> {
  late TimeOfDay selectedTime = TimeOfDay.now();
  String timeHour = "";
  String timeMinute = "";

  @override
  void initState() {
    super.initState();
    selectedTime = _parseTime(widget.time);
  }

  void _onPressed() async {
    var time = await selectTime(context);
    if (time != null) {
      setState(() {
        final formatedTime = _formatTime(time);
        (widget.isStart) ? start = formatedTime : end = formatedTime;
        selectedTime = time;
        widget.onTimeChanged(formatedTime);
      });
    } else {
      widget.onTimeChanged(widget.time);
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
    if (widget.time.contains("TimeOfDay")) {
      String trimmed = extractTime(widget.time);
      timeHour = trimmed.split(":")[0];
      timeMinute = trimmed.split(":")[1];
    } else {
      timeHour = widget.time.split(":")[0];
      timeMinute = widget.time.split(":")[1];
    }

    var selectedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: int.parse(timeHour), minute: int.parse(timeMinute)),
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

  String extractTime(String input) {
    int colonindex = input.indexOf(':');
    int startIndex = colonindex - 2;
    int endIndex = colonindex + 3;
    String timeValue = input.substring(startIndex, endIndex);

    return timeValue;
  }
}
