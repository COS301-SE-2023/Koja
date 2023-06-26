import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/date_and_time_util.dart';
import '../Utils/event_util.dart';
import '../models/autocomplete_predict_model.dart';
import '../models/location_predict_widget.dart';
import '../models/place_auto_response_model.dart';
import '../providers/event_provider.dart';
import './choose_category_widget.dart';

class EventEditing extends StatefulWidget {
  final Event? event;

  const EventEditing({Key? key, this.event}) : super(key: key);

  @override
  EventEditingState createState() => EventEditingState();
}

class EventEditingState extends State<EventEditing> {
  List<AutocompletePrediction> eventplacepredictions = [];
  final TextEditingController _eventplace = TextEditingController();

  Future<void> eventplaceAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        'maps/api/place/autocomplete/json', {"input": query, "key": apiKey});

    String? response = await LocationPredict.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parsePlaceAutocompleteResponse(response);
      if (result.predictions != null) {
        if (mounted) {
          setState(() {
            eventplacepredictions =
                result.predictions!.cast<AutocompletePrediction>();
          });
        }
      }
    }
  }

  late DateTime fromDate;
  late DateTime toDate;

  //key which is used to validate the form
  final _formKey = GlobalKey<FormState>();

  //controller for the title text field
  final titleController = TextEditingController();
  final hoursController = TextEditingController();
  final minutesController = TextEditingController();

  String selectedCategory = 'Work';
  String selectedEventType = 'Dynamic';

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void updateEventType(String eventType) {
    setState(() {
      selectedEventType = eventType;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.black),
            ),
            child: Text('Cancel')),
        TextButton(
            onPressed: saveForm,
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.black),
            ),
            child: Text('Save',
                style: TextStyle(fontFamily: 'Railway', color: Colors.black))),
      ],
      backgroundColor: Colors.grey[100],
      contentPadding: const EdgeInsets.all(16),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                buildTitle(),
                const SizedBox(height: 12),
                (selectedEventType == 'Dynamic')
                    ? getDynamicTimeSelectors()
                    : buildDateTimePickers(),
                const SizedBox(height: 12),
                ChooseCategory(onCategorySelected: updateCategory),
                const SizedBox(height: 12),
                ChooseEventType(onEventSelected: updateEventType),
                const SizedBox(height: 12),
                location(),
                const SizedBox(height: 12),
                deleteEventButton(),
              ],
            )),
      ),
    );
  }

  Widget getDynamicTimeSelectors() {
    return Column(
      children: [
        buildDateTimePickers(isDynamic: selectedEventType == 'Dynamic'),
        buildHeader(
          header: 'Select Duration',
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: "Hours", hintText: "1"),
                  controller: hoursController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      final value = int.tryParse(hoursController.text);
                      if (value == null) return "Must be a number!";
                      if (value < 0 || value > 12) {
                        return "Must be between 0 and 12";
                      }
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: "Minutes", hintText: "30"),
                  controller: minutesController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      final value = int.tryParse(minutesController.text);
                      if (value == null) return "Must be a number!";
                      if (value < 0 || value > 59) {
                        return "Must be between 0 and 59";
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget deleteEventButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (widget.event != null) {
            Provider.of<EventProvider>(context, listen: false)
                .deleteEvent(widget.event!);
            Navigator.of(context).pop();
          }
        },
        child: const Text('Delete Event'),
      ),
    );
  }

  Widget location() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("LOCATION: ${_eventplace.text}",
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: 'Railway',
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            TextFormField(
              onChanged: onLocationChanged,
              cursorColor: Colors.white,
              controller: _eventplace,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: const OutlineInputBorder(),
                hintText: "Meeting's Location",
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  onPressed: clearLocation,
                  icon: const Icon(Icons.clear, color: Colors.black),
                ),
              ),
              onFieldSubmitted: (_) {
                if (titleController.text.isNotEmpty) {
                  saveForm();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a title'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: eventplacepredictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    eventplacepredictions[index].description!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    selectLocation(eventplacepredictions[index].description!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void onLocationChanged(String value) {
    if (value.length > 2) {
      eventplaceAutocomplete(value);
    } else {
      setState(() {
        eventplaceAutocomplete("");
      });
    }
  }

  void clearLocation() {
    _eventplace.clear();
    setState(() {
      eventplaceAutocomplete("");
    });
  }

  void selectLocation(String location) {
    setState(() {
      _eventplace.text = location;
      eventplaceAutocomplete("");
    });
    // Send the selected location (placeId) to the backend
    // meetinglocation(eventplacepredictions[index].placeId!);
  }

  Widget buildTitle() {
    return TextFormField(
      style: const TextStyle(fontSize: 24),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Title',
      ),
      onFieldSubmitted: (_) => saveForm(),
      validator: (title) =>
          title != null && title.isEmpty ? 'Title cannot be empty' : null,
      controller: titleController,
    );
  }

  Widget buildDateTimePickers({bool isDynamic = false}) => Column(
        children: [
          buildFrom(isDynamic),
          const SizedBox(height: 12),
          if (!isDynamic) buildTo(),
        ],
      );

  Widget buildFrom(bool isDynamic) {
    return buildHeader(
      header: isDynamic ? 'For' : "FROM",
      child: Row(
        children: [
          Expanded(
            child: buildDropdownField(
              text: DateAndTimeUtil.toDate(fromDate),
              //If the user clicked the date the new date is saved in the fromDate variable
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          if (!isDynamic)
            Expanded(
              child: buildDropdownField(
                  text: DateAndTimeUtil.toTime(fromDate),
                  //If the user clicked the time the new time is saved in the fromDate variable
                  onClicked: () => pickFromDateTime(pickDate: false)),
            ),
        ],
      ),
    );
  }

  Widget buildTo() => buildHeader(
        header: 'TO',
        child: Row(
          children: [
            Expanded(
              child: buildDropdownField(
                  text: DateAndTimeUtil.toDate(toDate),
                  onClicked: () => pickToDateTime(pickDate: true)),
            ),
            Expanded(
              child: buildDropdownField(
                  text: DateAndTimeUtil.toTime(toDate),
                  onClicked: () => pickToDateTime(pickDate: false)),
            ),
          ],
        ),
      );

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

  Widget buildHeader({required String header, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        child,
      ],
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      fromDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );

    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = DateTime(
        date.year,
        date.month,
        date.day,
        toDate.hour,
        toDate.minute,
      );
    }

    if (mounted) {
      setState(() {
        fromDate = date;
      });
    }
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year - 5),
        lastDate: DateTime(initialDate.year + 10),
      );

      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );

      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );

      return date.add(time);
    }
  }

  //To Section
  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate, pickDate: pickDate);

    if (date == null) return;

    // if (date.isAfter(toDate)) {
    //   toDate = DateTime(
    //     date.year,
    //     date.month,
    //     date.day,
    //     toDate.hour,
    //     toDate.minute,
    //   );
    // }
    if (mounted) {
      setState(() {
        toDate = date;
      });
    }
  }

  Future saveForm() async {
    // print('Selected Category: $selectedCategory');
    late bool isValid = false;

    if (_formKey.currentState!.validate() && titleController.text.isNotEmpty) {
      isValid = true;
    }

    if (isValid) {
      final provider = Provider.of<EventProvider>(context, listen: false);

      final timeSlot = provider.timeSlots[selectedCategory];

      int year = fromDate.year;
      int month = fromDate.month;
      int day = fromDate.day;

      int startHour = timeSlot!.startTime.hour;
      int startMinute = timeSlot.startTime.minute;
      int startSecond = timeSlot.startTime.second;

      int endHour = timeSlot.endTime.hour;
      int endMinute = timeSlot.endTime.minute;
      int endSecond = timeSlot.endTime.second;

      DateTime updatedStartTime = DateTime(
        year,
        month,
        day,
        startHour,
        startMinute,
        startSecond,
      );

      DateTime updatedEndTime = DateTime(
        year,
        month,
        day,
        endHour,
        endMinute,
        endSecond,
      );

      timeSlot.startTime = updatedStartTime;
      timeSlot.endTime = updatedEndTime;

      final durationHours = int.tryParse(hoursController.text);
      final durationMinutes = int.tryParse(minutesController.text);

      var durationInSeconds = 0;

      durationInSeconds =
          ((durationHours ?? 0) * 60 * 60) + ((durationMinutes ?? 0) * 60);

      final event = Event(
        title: titleController.text,
        location: _eventplace.text,
        description: 'description',
        category: selectedCategory,
        isDynamic: (selectedEventType == "Dynamic") ? true : false,
        from: fromDate,
        to: toDate,
        duration: durationInSeconds * 1000,
        isAllDay: false,
        timeSlots: [timeSlot],
      );

      var data = {
        "token": "${provider.accessToken}",
        "event": event.toJson(),
      };

      var response = await http.post(
        Uri.http('localhost:8080', '/api/v1/user/calendar/createEvent'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer ${provider.accessToken}",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        provider.getEventsFromAPI();
        const snackBar = SnackBar(
          content: Text('Event Created!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        const snackBar = SnackBar(
          content:
              Text('Event Creation Failed - Could not fit in the time slot'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          content: Text('Could not create event - Internal Server Error'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    }
  }
}

  // void sendmeetinglocation(String id) 
  // {
  //   //send to an api
  //   final backendurl = '';
  //   final data = {'placeId': id};

  //   // final response = http.post(Uri.parse(backendurl), body: json.encode(data));
  // }