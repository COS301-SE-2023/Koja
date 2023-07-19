import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';

class SetBoundary extends StatefulWidget {
  final VoidCallback onSave;
  final String selectedOption;

  final TextEditingController start;
  final TextEditingController end;

  SetBoundary(this.selectedOption, this.start, this.end, this.onSave,
      {Key? key});

  @override
  State<SetBoundary> createState() => _SetBoundaryState();
}

class _SetBoundaryState extends State<SetBoundary> {
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
                        child: SelectedTimeButton(controller: widget.start),
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
                        child: SelectedTimeButton(controller: widget.end),
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
  final TextEditingController controller;

  SelectedTimeButton({required this.controller});

  @override
  SelectedTimeButtonState createState() => SelectedTimeButtonState();
}

class SelectedTimeButtonState extends State<SelectedTimeButton> {
  late TimeOfDay selectedTime = TimeOfDay.now();

  void _onPressed() async {
    var time = await selectTime(context);
    if (time != null) {
      setState(() {
        selectedTime = time;
        widget.controller.text = time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      child: Text(selectedTime.format(context)),
    );
  }

  Future<TimeOfDay?> selectTime(BuildContext context) async {
    if(isEditing == false)
    {
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
    else
    {
      var selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: int.parse(widget.controller.text.split(":")[0]), minute: int.parse(widget.controller.text.split(":")[1].split(" ")[0])),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      return selectedTime;
    }
    
  }
}
