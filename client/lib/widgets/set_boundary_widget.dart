import 'package:client/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';

class SetBoundary extends StatelessWidget {
  VoidCallback onSave;
  final String selectedOption;
  final TextEditingController start, end;
  
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
                      TimePickerWidget(),
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
                      TimePickerWidget(),
                      
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
