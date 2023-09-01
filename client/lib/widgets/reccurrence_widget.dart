import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';
import '../Utils/date_and_time_util.dart';

class RecurrenceWidget extends StatefulWidget {
  @override
  RecurrenceWidgetState createState() => RecurrenceWidgetState();
}

List<String> endingChoice = ['Occurrences', 'EndDate'];

class RecurrenceWidgetState extends State<RecurrenceWidget> {
  static List<String> intervalString = [
    '1(One)',
    '2(Two)',
    '3(Three)',
    '4(Four)',
    '5(Five)',
    '6(Six)',
    '7(Seven)',
    '8(Eight)',
    '9(Nine)',
    '10(Ten)',
    '11(Eleven)',
    '12(Twelve)',
    '13(Thirteen)',
    '14(Fourteen)',
    '15(Fifteen)',
    '16(Sixteen)',
    '17(Seventeen)',
    '18(Eighteen)',
    '19(Nineteen)',
    '20(Twenty)',
    '21(Twenty-One)',
    '22(Twenty-Two)',
    '23(Twenty-Three)',
    '24(Twenty-Four)',
    '25(Twenty-Five)',
    '26(Twenty-Six)',
    '27(Twenty-Seven)',
    '28(Twenty-Eight)',
    '29(Twenty-Nine)',
    '30(Thirty)'
  ];
  static List<String> occurrences = [
    '1(One)',
    '2(Two)',
    '3(Three)',
    '4(Four)',
    '5(Five)',
    '6(Six)',
    '7(Seven)',
    '8(Eight)',
    '9(Nine)',
    '10(Ten)',
    '11(Eleven)',
    '12(Twelve)',
    '13(Thirteen)',
    '14(Fourteen)',
    '15(Fifteen)',
    '16(Sixteen)',
    '17(Seventeen)',
    '18(Eighteen)',
    '19(Nineteen)',
    '20(Twenty)',
    '21(Twenty-One)',
    '22(Twenty-Two)',
    '23(Twenty-Three)',
    '24(Twenty-Four)',
    '25(Twenty-Five)',
    '26(Twenty-Six)',
    '27(Twenty-Seven)',
    '28(Twenty-Eight)',
    '29(Twenty-Nine)',
    '30(Thirty)'
  ];

  static List<String> recurrenceFor = [
    'day(s)',
    'week(s)',
    'month(s)',
    'year(s)'
  ];

  String selectedFor = recurrenceFor[0];
  String selectedInterval = intervalString[0];
  String selectedOccurrence = occurrences[0];
  String selectedEnding = endingChoice[0];

  late DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      contentPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          child: Text('Save'),
          onPressed: () {
            saveRecurrence();
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
                fontSize: 17),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
            children: [
              Expanded(
                child:
                    DropdownButtonFormField<String>(
                  value: selectedInterval,
                  items: intervalString.map<
                          DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight:
                                FontWeight.w500,
                            fontSize: 11),
                      ),
                    );
                  }).toList(),
                  borderRadius:
                      BorderRadius.circular(10),
                  decoration: InputDecoration(
                    label: Text(
                      'Interval',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:
                              FontWeight.w500,
                          fontSize: 17),
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
                  padding:
                      const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<
                      String>(
                    value: selectedFor,
                    items: recurrenceFor.map<
                            DropdownMenuItem<
                                String>>(
                        (String value) {
                      return DropdownMenuItem<
                          String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight:
                                  FontWeight.w500,
                              fontSize: 13),
                        ),
                      );
                    }).toList(),
                    borderRadius:
                        BorderRadius.circular(10),
                    decoration: InputDecoration(
                      label: Text(
                        'For',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight:
                                FontWeight.w500,
                            fontSize: 17),
                      ),
                      focusedBorder:
                          OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedFor =
                              newValue;
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

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              RadioListTile(
                subtitle: Container(
                  height: 50,
                  child: ListTile(
                    title: Text(DateAndTimeUtil.toDate(endDate)),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () async {
                      final DateTime? changedDate = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 720)),
                      );

                      if (changedDate != null && changedDate != endDate) {
                        setState(() {
                          endDate = changedDate;
                        });
                      }
                    },
                  )
                ),
                value: endingChoice[1],
                groupValue: selectedEnding,
                onChanged: (value) {
                  setState(() {
                    selectedEnding = value.toString();
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
                  child: DropdownButtonFormField<
                      String>(
                    value: selectedOccurrence,
                    items: occurrences.map<
                            DropdownMenuItem<
                                String>>(
                        (String value) {
                      return DropdownMenuItem<
                          String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight:
                                  FontWeight.w500,
                              fontSize: 13),
                        ),
                      );
                    }).toList(),
                    borderRadius:
                        BorderRadius.circular(10),
                    decoration: InputDecoration(
                        label: Text(
                      'Occurrences',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:
                              FontWeight.w500,
                          fontSize: 17),
                    )),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedOccurrence =
                              newValue;
                        });
                      }
                    },
                  ),
                ),
                value: endingChoice[0],
                groupValue: selectedEnding,
                onChanged: (value) {
                  setState(() {
                    selectedEnding = value.toString();
                  });
                },
              ),
            ],
          ),
        ],
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

// FREQ=DAILY;INTERVAL=1;COUNT=10
// FREQ=DAILY;INTERVAL=1;UNTIL=20200630T183000Z

  Future saveRecurrence() async {
    recurrenceString = [];
    String selInterval = removeWords(selectedInterval);
    String selOccurrence = removeWords(selectedOccurrence);

    if (selectedFor == 'day(s)') {
      recurrenceString.add('DAILY');
      recurrenceString.add(selInterval);
      if (selectedEnding == 'Occurrences') {
        recurrenceString.add(selOccurrence);
      } else if (selectedEnding == 'EndDate') {
        recurrenceString.add(DateAndTimeUtil.toUTCFormat(endDate));
      }
    } else if (selectedFor == 'week(s)') {
      recurrenceString.add('WEEKLY');
      recurrenceString.add(selInterval);
      if (selectedEnding == 'Occurrences') {
        recurrenceString.add(selOccurrence);
      } else if (selectedEnding == 'EndDate') {
        recurrenceString.add(DateAndTimeUtil.toUTCFormat(endDate));
      }
    } else if (selectedFor == 'month(s)') {
      recurrenceString.add('MONTHLY');
      recurrenceString.add(selInterval);
      if (selectedEnding == 'Occurrences') {
        recurrenceString.add(selOccurrence);
      } else if (selectedEnding == 'EndDate') {
        recurrenceString.add(DateAndTimeUtil.toUTCFormat(endDate));
      }
    } else if (selectedFor == 'year(s)') {
      recurrenceString.add('YEARLY');
      recurrenceString.add(selInterval);
      recurrenceString[0] = 'YEARLY';
      recurrenceString[1] = selInterval;
      if (selectedEnding == 'Occurrences') {
        recurrenceString.add(selOccurrence); 
      } else if (selectedEnding == 'EndDate') {
        recurrenceString.add(DateAndTimeUtil.toUTCFormat(endDate));
      }
    }
  }

  String removeWords(String input) {
    return input.replaceAll(RegExp(r'\(.*'), '');
  }
}
