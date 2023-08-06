import 'package:flutter/material.dart';
import '../Utils/constants_util.dart';

class ChooseCategory extends StatefulWidget {
  final void Function(String category) onCategorySelected;
  const ChooseCategory({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  ChooseCategoryState createState() => ChooseCategoryState();
}

class ChooseCategoryState extends State<ChooseCategory> {
  static List<String> categories = [
    'None',
    'School',
    'Work',
    'Hobby',
    'Resting',
    'Chore'
  ];
  String selectedCategory = categories[0];

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
                  'TIME BOUNDARY',
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
                  'EVENT TYPE',
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
                      fontWeight: FontWeight.w500,
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
                  fontWeight: FontWeight.w500,
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

class ChooseRecurrence extends StatefulWidget {
  final void Function(String category) onRecurrenceSelected;

  ChooseRecurrence({Key? key, required this.onRecurrenceSelected})
      : super(key: key);

  @override
  ChooseRecurrenceState createState() => ChooseRecurrenceState();
}

class ChooseRecurrenceState extends State<ChooseRecurrence> {
  String selectedCategory = 'None';
  List<String> categories = ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly'];

  String selectedEnd = 'EndDate';
  List<String> endingChoice = ['Occurrences(times)', 'EndDate'];
  double intervalValue = 1.0;

  String getIntervalString(String interval) {
      if (interval == 'Daily') {
        return ' day(s)';
      } else if (interval == 'Weekly') {
        return ' week(s)';
      } else if (interval == 'Monthly') {
        return ' month(s)';
      } else if (interval == 'Yearly') {
        return ' year(s)';
      } else {
        return 'None';
      }
    }

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
                widget.onRecurrenceSelected(newValue);
                if (newValue != 'None') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Recurrence'),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Repeats Every',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: intervalValue,
                                        min: 1,
                                        max: 30,
                                        divisions: 29,
                                        // label: intervalValue.round().toString(),
                                        onChanged: (double value) {
                                          setState(() {
                                            intervalValue = value;
                                          });
                                          print(intervalValue);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      getIntervalString(newValue),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        fontFamily: 'Ubuntu',
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                ChooseEndChoice(),
                                SizedBox(height: 10),
                                if(selectedEnd == 'Occurrences(times)')
                                  chooseOccurrences(),
                                if(selectedEnd == 'EndDate')
                                  showCalendar(),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
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
                      },
                    );
                  } 
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
          ),
        ],
      ),
    );
  }

  Widget showCalendar() {
  return Row(
    children: [
      Text(
        'Ends on',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: 'Ubuntu',
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101),
          );
          if (picked != null) {
            setState(() {
              recurrenceEndDate = picked;
            });
          }
          else{
            setState(() {
              recurrenceEndDate = DateTime.now();
            });
          }
        },
        child: Text(
          '${recurrenceEndDate?.day}/${recurrenceEndDate?.month}/${recurrenceEndDate?.year}',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            fontFamily: 'Ubuntu',
          ),
        ),
      ),
    ],
  );
}


  Widget chooseOccurrences()
  {
    return Column(
      children: [
        Text(
          'Ends after',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            fontFamily: 'Ubuntu',
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: intervalValue,
                min: 1,
                max: 30,
                divisions: 29,
                // label: intervalValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    intervalValue = value;
                  });
                  print(intervalValue);
                },
              ),
            ),
            SizedBox(width: 8),
            Text(
              ' ${intervalValue.round()} times',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                fontFamily: 'Ubuntu',
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ChooseEndChoice extends StatefulWidget {
  const ChooseEndChoice({Key? key}) : super(key: key);

  @override
  ChooseEndChoiceState createState() => ChooseEndChoiceState();
}

class ChooseEndChoiceState extends State<ChooseEndChoice> {
  List<String> endChoices = ['EndDate', 'Occurrences(times)'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField<String>(
            value: selectedEnd,
            onChanged: (String? end) {
              if (end != null) {
                setState(() {
                  selectedEnd = end;
                });
              }
            },
            items: endChoices.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              label: Text(
                'ENDS',
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
            )
          ),
        ],
      ),
    );
  }
}

