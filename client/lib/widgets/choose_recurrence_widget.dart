import 'package:flutter/material.dart';
import 'reccurrence_widget.dart';

class ChooseRecurrence extends StatefulWidget {
  final void Function(String category) onRecurrenceSelected;

  ChooseRecurrence({Key? key, required this.onRecurrenceSelected})
      : super(key: key);

  @override
  ChooseRecurrenceState createState() => ChooseRecurrenceState();
}

class ChooseRecurrenceState extends State<ChooseRecurrence> {
  String selectedCategory = 'None';
  List<String> recurOptions = ['None', 'Custom'];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items:
                    recurOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                borderRadius: BorderRadius.circular(10),
                decoration: InputDecoration(
                  label: Text(
                    'RECURRENCE',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    widget.onRecurrenceSelected(newValue);
                    if (newValue != 'None') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RecurrenceWidget();
                        }
                      );
                    }
                  }
                },
              ),
            ]));
  }
}
