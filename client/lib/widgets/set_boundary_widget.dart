import 'package:client/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';

class SetBoundary extends StatelessWidget {
  VoidCallback onSave;
  final String selectedOption;
  final TextEditingController start, end;

  // DateTime _selectedDate = DateTime.now();
  // TextEditingController selectedTime = TextEditingController();
  
  SetBoundary(
    this.selectedOption, 
    this.start, this.end, 
    this.onSave,
    {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 180,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            Text(
              selectedOption.toUpperCase(),
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
                        child: SelectedTimeButton( controller: start),
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
                        child: SelectedTimeButton(controller: end),
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
                    onSave();
                    Navigator.of(context).pop();
                  },
                  child: Text("Save")),
                const SizedBox(width: 3),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")
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
  _SelectedTimeButtonState createState() => _SelectedTimeButtonState();
}

class _SelectedTimeButtonState extends State<SelectedTimeButton> {
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
      child: Text(selectedTime != null ? selectedTime.format(context) : 'Select Time'),
    );
  }

  Future<TimeOfDay?> selectTime(BuildContext context) async {
    var selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return selectedTime;
  }
}

