import 'package:flutter/material.dart';
import '../Utils/constants_util.dart';
import '../Utils/date_and_time_util.dart';

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

  String selectedEnd = 'EndDate';
  List<String> endingChoice = ['Occurrences(times)', 'EndDate'];
  double intervalValue = 1.0;

  static List<String> recurrenceString = ['day(s)', 'week(s)', 'month(s)', 'year(s)'];
  static List<String> intervalString = ['1(One)', '2(Two)', '3(Three)', '4(Four)', '5(Five)', '6(Six)', '7(Seven)', '8(Eight)', '9(Nine)', '10(Ten)',
    '11(Eleven)', '12(Twelve)', '13(Thirteen)', '14(Fourteen)', '15(Fifteen)', '16(Sixteen)', '17(Seventeen)', '18(Eighteen)', '19(Nineteen)', '20(Twenty)',
    '21(Twenty-One)', '22(Twenty-Two)', '23(Twenty-Three)', '24(Twenty-Four)', '25(Twenty-Five)', '26(Twenty-Six)', '27(Twenty-Seven)', '28(Twenty-Eight)', '29(Twenty-Nine)', '30(Thirty)'];
  static List<String> occurrences = ['1(One)', '2(Two)', '3(Three)', '4(Four)', '5(Five)', '6(Six)', '7(Seven)', '8(Eight)', '9(Nine)', '10(Ten)',
    '11(Eleven)', '12(Twelve)', '13(Thirteen)', '14(Fourteen)', '15(Fifteen)', '16(Sixteen)', '17(Seventeen)', '18(Eighteen)', '19(Nineteen)', '20(Twenty)',
    '21(Twenty-One)', '22(Twenty-Two)', '23(Twenty-Three)', '24(Twenty-Four)', '25(Twenty-Five)', '26(Twenty-Six)', '27(Twenty-Seven)', '28(Twenty-Eight)', '29(Twenty-Nine)', '30(Thirty)'];


  String selectedInterval = recurrenceString[0];
  String selectedRecurrence = intervalString[0];
  String selectedOccurrence = occurrences[0];
  String selectedOption = 'Date';

  late DateTime endDate = DateTime.now();

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
            items: recurOptions.map<DropdownMenuItem<String>>((String value) {
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
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: AlertDialog(
                          backgroundColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.all(16),
                          actions: [
                            TextButton(
                              child: Text('Save'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          title: Row(
                            children: [
                              Text(
                                'Recurrences',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17
                                ),
                              ),
                              Icon(
                                Icons.repeat,
                                color: Colors.black,
                                size: 30,
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Repeats Every',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: 
                                [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: selectedRecurrence,
                                      items: intervalString.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      borderRadius: BorderRadius.circular(10),
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Interval',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17
                                          ),
                                        ),
                                      ),  
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedEnd = newValue;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedInterval,
                                        items: recurrenceString.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        borderRadius: BorderRadius.circular(10),
                                        decoration: InputDecoration(
                                          label: Text(
                                            'For',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                                          ),
                                          
                                        ),  
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              selectedInterval = newValue;
                                            });
                                          }
                                        },
                                      ),
                                    ), 
                                  )
                                ],
                              ),
                              Divider(
                                height: 10,
                                thickness: 0,
                                color: Colors.transparent,
                              ),
                              Text(
                                'Ends',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              
                              // for occurrences
                              
                              RadioListTile(
                                subtitle: Container(
                                  height: 50,
                                  child: buildDropdownField(
                                    text: DateAndTimeUtil.toDate(endDate),
                                    //If the user clicked the date the new date is saved in the fromDate variable
                                    onClicked: () async {
                                      // pickFromDateTime(pickDate: true)
                                      final DateTime? changedDate = await showDatePicker(
                                        context: context, 
                                        initialDate: DateTime.now(), 
                                        firstDate: DateTime.now(),   
                                        lastDate: DateTime.now().add(Duration(days: 720))
                                      );

                                      if (changedDate != null && changedDate != endDate) {
                                        setState(() {
                                          endDate = changedDate;
                                        });
                                      }
                                    }
                                  ),
                                ),
                                value: 'Date',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                              Divider(
                                height: 10,
                                thickness: 0,
                                color: Colors.transparent,
                              ),
                              RadioListTile(
                                subtitle: Container(
                                height: 100,
                                child: DropdownButtonFormField<String>(
                                  value: selectedOccurrence,
                                  items: occurrences.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  borderRadius: BorderRadius.circular(10),
                                  decoration: InputDecoration(
                                    label: Text(
                                      'Occurrences',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17
                                      ),
                                    )  
                                  ),  
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedOccurrence = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                                value: 'Occurrences',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ],
                          )
                        ),
                      );
                    }
                  );
                }
              }
            },
          ),
        ]
      )
    );
  }

  Widget buildDropdownField({
      required String text,
      required VoidCallback onClicked,
    }) {
      return ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );
  }
}