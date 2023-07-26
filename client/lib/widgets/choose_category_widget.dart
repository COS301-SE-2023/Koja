import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Utils/constants_util.dart';

class ChooseCategory extends StatefulWidget {
  final void Function(String category) onCategorySelected;
  const ChooseCategory({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  ChooseCategoryState createState() => ChooseCategoryState();
}

class ChooseCategoryState extends State<ChooseCategory> {
  String selectedCategory = 'School';
  List<String> categories = ['School', 'Work', 'Hobby', 'Resting', 'Chore'];

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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  widget.onCategorySelected(newValue);
                }
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                label: Text(
                  'Time Boundary',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              )),
        ],
      ),
    );
  }
}

class ChooseEventType extends StatefulWidget {
  final void Function(String category) onEventSelected;
  const ChooseEventType({Key? key, required this.onEventSelected})
      : super(key: key);

  @override
  ChooseEventTypeState createState() => ChooseEventTypeState();
}

class ChooseEventTypeState extends State<ChooseEventType> {
  String selectedCategory = 'Fixed';
  List<String> categories = ['Fixed', 'Dynamic'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  widget.onEventSelected(newValue);
                }
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                label: Text(
                  'Select Event Type',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              )),
        ],
      ),
    );
  }
}

class ChoosePriority extends StatefulWidget {
  final void Function(String category) onPrioritySelected;
  const ChoosePriority({Key? key, required this.onPrioritySelected})
      : super(key: key);

  @override
  ChoosePriorityState createState() => ChoosePriorityState();
}

class ChoosePriorityState extends State<ChoosePriority> {
  String selectedCategory = 'Low';
  List<String> categories = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  widget.onPrioritySelected(newValue);
                }
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                label: Text(
                  'Select Priority Level',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              )),
        ],
      ),
    );
  }
}

class ChooseColor extends StatefulWidget {
  final void Function(Color category) onColorSelected;

  const ChooseColor({Key? key, required this.onColorSelected})
      : super(key: key);

  @override
  ChooseColorState createState() => ChooseColorState();
}

class ChooseColorState extends State<ChooseColor> {
  Color selectedCategory = Colors.blue;
  List<Color> categories = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  String getColorName(Color color) {
    if (color == Colors.blue) {
      return 'Blue';
    } else if (color == Colors.red) {
      return 'Red';
    } else if (color == Colors.green) {
      return 'Green';
    } else if (color == Colors.yellow) {
      return 'Yellow';
    } else if (color == Colors.purple) {
      return 'Purple';
    } else {
      return 'Blue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField<Color>(
            value: selectedCategory,
            onChanged: (Color? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
                widget.onColorSelected(newValue);
              }
            },
            items: categories.map<DropdownMenuItem<Color>>((Color value) {
              return DropdownMenuItem<Color>(
                value: value,
                child: Row(
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: value,
                        )),
                    SizedBox(width: 8),
                    Text(getColorName(value)),
                  ],
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              label: Text(
                'Select Color',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Class which sets recurrence
class ChooseRecurrence extends StatefulWidget {
  final void Function(String category) onRecurrenceSelected;
  const ChooseRecurrence({Key? key, required this.onRecurrenceSelected})
      : super(key: key);

  @override
  ChooseRecurrenceState createState() => ChooseRecurrenceState();
}

class ChooseRecurrenceState extends State<ChooseRecurrence> {
  String selectedCategory = 'None';
  List<String> categories = ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly'];

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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                    if(newValue != 'None') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content:
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: 
                                    Row(
                                      children: [
                                        Text(
                                          'REPEAT INTERVAL:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [                                           
                                            NumberPicker(
                                              value: 1,
                                              minValue: 1,
                                              maxValue: 20,
                                              onChanged: (value) => {
                                                setState(() {
                                                  interval = value;
                                                })
                                              },
                                            ),
                                            Spacer(),
                                            Text(
                                              newValue,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),                                     
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  isRecurrence = true;
                                  Navigator.of(context).pop();
                                },
                                child: Text('Save'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        }
                      );
                    }
                    else {
                      isRecurrence = false;
                    }
                  });
                  widget.onRecurrenceSelected(newValue);
                }
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                label: Text(
                  'Select Recurrence',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              )),
        ],
      ),
    );
  }
}
