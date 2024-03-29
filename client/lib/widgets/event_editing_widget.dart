import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:koja/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:koja/screens/navigation_management_screen.dart';
import 'package:koja/widgets/reccurrence_widget.dart';
import 'package:provider/provider.dart';

import '../Utils/date_and_time_util.dart';
import '../Utils/event_util.dart';
import '../models/autocomplete_predict_model.dart';
import '../models/location_predict_widget.dart';
import '../models/place_auto_response_model.dart';
import '../providers/context_provider.dart';
import '../providers/service_provider.dart';
import './choose_category_widget.dart';
import './choose_recurrence_widget.dart';

class EventEditing extends StatefulWidget {
  final Event? event;

  const EventEditing({Key? key, this.event}) : super(key: key);

  @override
  EventEditingState createState() => EventEditingState();
}

class EventEditingState extends State<EventEditing> {
  List<AutocompletePrediction> eventPlacePredictions = [];
  final TextEditingController _eventPlace = TextEditingController();
  String placeId = "";
  String placeName = "";
  late Event? updatedEvent;

  Future<void> eventPlaceAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        'maps/api/place/autocomplete/json', {"input": query, "key": apiKey});

    String? response = await LocationPredict.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parsePlaceAutocompleteResponse(response);
      if (result.predictions != null) {
        if (mounted) {
          setState(() {
            eventPlacePredictions =
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

  String selectedCategory = 'None';
  String selectedEventType = 'Fixed';
  String selectedPriority = 'Low';
  Color selectedColor = Colors.blue;
  String selectedRecurrence = 'None';

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

  void updatePriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }

  void updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void updateRecurrence(String recurrence) {
    setState(() {
      selectedRecurrence = recurrence;
    });
  }

  @override
  void initState() {
    super.initState();
    isExistingEvent = false;

    if (widget.event != null && widget.event!.isDynamic) {
      if (widget.event!.duration > 0) {
        Duration d = Duration(milliseconds: widget.event!.duration);
        _eventPlace.text = widget.event!.location;
        hoursController.text = d.inHours.toString();
        minutesController.text = (d.inMinutes - (d.inHours * 60)).toString();
      } else if (widget.event!.isDynamic) {
        _eventPlace.text = widget.event!.location;

        Duration d = Duration(
            minutes: widget.event!.from
                .difference(widget.event!.to)
                .inMinutes
                .abs());

        hoursController.text = d.inHours.toString();
        minutesController.text = (d.inMinutes - (d.inHours * 60)).toString();
      }
    }

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 1));
    } else {
      isExistingEvent = true;
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      recurrenceStart = event.from;
      toDate = event.to;
      existingType = event.isDynamic ? 'Dynamic' : 'Fixed';
      existingPriority = event.priority == 1
          ? 'High'
          : event.priority == 2
              ? 'Medium'
              : 'Low';
      selectedColor = event.backgroundColor;
      // _eventPlace.text = placeId;
      _eventPlace.text = placeName;
      existingCategory = event.category;
      if (event.recurrenceRule != []) {
        existingRecurrence = 'Custom';
      } else {
        existingRecurrence = 'None';
      }
      existingRecurrenceString = event.recurrenceRule;

      //The function definitions
      updateCategory(existingCategory);
      updateEventType(existingType);
      updatePriority(existingPriority);
      updateColor(selectedColor);
      updateRecurrence(existingRecurrence);
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
        Row(
          textDirection: TextDirection.rtl,
          children: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.black),
                ),
                child: Text('Cancel')),
            if (selectedEventType == 'Dynamic' &&
                widget.event != null &&
                DateTime.now().isAfter(fromDate))
              TextButton(
                  onPressed: () {
                    needsReschedule = true;
                    saveForm();
                  },
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  child: Text('Reschedule',
                      style: TextStyle(
                          fontFamily: 'Railway', color: Colors.black))),
            TextButton(
                onPressed: saveForm,
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.black),
                ),
                child: Text('Save',
                    style:
                        TextStyle(fontFamily: 'Railway', color: Colors.black))),
          ],
        )
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
                ChooseEventType(onEventSelected: updateEventType),
                buildTitle(),
                const SizedBox(height: 10),
                (selectedEventType == 'Dynamic')
                    ? getDynamicTimeSelectors()
                    : buildDateTimePickers(),
                const SizedBox(height: 8),
                ChooseCategory(onCategorySelected: updateCategory),
                if (selectedEventType == 'Dynamic')
                  ChoosePriority(onPrioritySelected: updatePriority),
                ChooseRecurrence(onRecurrenceSelected: updateRecurrence),
                location(),
                TimeEstimationWidget(
                  placeID: placeId,
                ),
                const SizedBox(height: 12),
                if (widget.event != null) deleteEventButton(),
                SizedBox(height: 12),
                // if (widget.event != null && widget.event?.recurrenceRule != [])
                //   deleteRecurringEventsButton(),
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
            Provider.of<ContextProvider>(context, listen: false)
                .deleteEvent(widget.event!);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        child: const Text('Delete Event'),
      ),
    );
  }

  Widget deleteRecurringEventsButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (widget.event != null) {
            // loop around all events and delete events with same name and recurrence rule using deleteEvent
            Provider.of<ContextProvider>(context, listen: false)
                .deleteEvent(widget.event!);
            Navigator.of(context).pop();
          }
        },
        child: const Text('Delete Recurring Events'),
      ),
    );
  }

  Widget location() {
    void updateLocation(String newLocationName, String locationID) {
      for (var i = 0; i < locationList.length; i++) {
        if (locationList[i][0] == newLocationName) {
          if (locationList[i][1] != locationID) {
            // Update the second value
            locationList[i][1] = locationID;
          }
          return;
        }
      }
      // Add new values to the list
      locationList.add([newLocationName, locationID]);
    }

    return Padding(
      padding: EdgeInsets.only(left: 4, right: 4),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(_eventPlace.text,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Railway',
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
                if (_eventPlace.text.isNotEmpty)
                  IconButton(
                    onPressed: clearLocation,
                    icon: const Icon(Bootstrap.x_circle, color: Colors.black),
                  ),
              ],
            ),
            TextFormField(
              onChanged: onLocationChanged,
              cursorColor: Colors.black,
              controller: _eventPlace,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                label: Text(
                  "Meeting's Location",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  onPressed: clearLocation,
                  icon: const Icon(Bootstrap.x_circle, color: Colors.black),
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
              itemCount: eventPlacePredictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    eventPlacePredictions[index].description!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    placeId = eventPlacePredictions[index].placeId!;
                    selectLocation(eventPlacePredictions[index].description!);
                    placeName = eventPlacePredictions[index].description!;
                    updateLocation(placeName, placeId);
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
      eventPlaceAutocomplete(value);
    } else {
      setState(() {
        eventPlaceAutocomplete("");
      });
    }
  }

  void clearLocation() {
    _eventPlace.clear();
    setState(() {
      eventPlaceAutocomplete("");
    });
  }

  void selectLocation(String location) {
    setState(() {
      _eventPlace.text = location;
      eventPlaceAutocomplete("");
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
          const SizedBox(height: 10),
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
                onClicked: () {
                  pickFromDateTime(pickDate: true);
                }),
          ),
          if (!isDynamic)
            Expanded(
              child: buildDropdownField(
                  text: DateAndTimeUtil.toTime(fromDate),
                  //If the user clicked the time the new time is saved in the fromDate variable
                  onClicked: () {
                    pickFromDateTime(pickDate: false);
                  }),
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
        firstDate: DateTime.now(),
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
          builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              ));

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

    if (mounted) {
      setState(() {
        toDate = date;
      });
    }
  }

  Future saveForm() async {
    late bool isValid = false;

    final eventProvider = Provider.of<ContextProvider>(context, listen: false);
    final existingEvents = eventProvider.events;

    final isDuplicateEvent = existingEvents.any((existingEvent) {
      return existingEvent.title == titleController.text &&
          existingEvent.from == fromDate &&
          existingEvent.to == toDate &&
          existingEvent.category == selectedCategory &&
          existingEvent.isDynamic == (selectedEventType == "Dynamic") &&
          existingEvent.priority ==
              (selectedPriority == "Low"
                  ? 1
                  : selectedPriority == "Medium"
                      ? 2
                      : 3) &&
          existingEvent.backgroundColor == selectedColor &&
          needsReschedule == false;
    });

    if (_formKey.currentState!.validate() && titleController.text.isNotEmpty) {
      if (isDuplicateEvent) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: NavigationScreen(initialIndex: 1),
            ),
          ),
        );
        const snackBar = SnackBar(
            content: Text('Event already exists!'),
            duration: Duration(seconds: 5));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        isValid = true;
      }
    }

    if (isValid) {
      final eventProvider =
          Provider.of<ContextProvider>(context, listen: false);

      var timeSlot = (selectedCategory != 'None')
          ? eventProvider.timeSlots[selectedCategory]
          : null;

      if (timeSlot == null) {
        var now = DateTime.now();
        if (now.day == fromDate.day &&
            now.month == fromDate.month &&
            now.year == fromDate.year) {
          final endOfDay = DateTime(
            now.year,
            now.month,
            now.day,
            23,
            59,
            59,
          );

          timeSlot = TimeSlot(
            startTime: now,
            endTime: endOfDay,
            bookable: true,
          );
        } else {
          final startOfDay = DateTime(
            fromDate.year,
            fromDate.month,
            fromDate.day,
            0,
            0,
            0,
          );
          final endOfDay = DateTime(
            fromDate.year,
            fromDate.month,
            fromDate.day,
            23,
            59,
            59,
          );
          timeSlot = TimeSlot(
            startTime: startOfDay,
            endTime: endOfDay,
            bookable: true,
          );
        }
      }

      int year = fromDate.year;
      int month = fromDate.month;
      int day = fromDate.day;

      int startHour = timeSlot.startTime.hour;
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

      var priorityValue = 3;
      if (selectedPriority == 'Low') {
        priorityValue = 3;
      } else if (selectedPriority == 'Medium') {
        priorityValue = 2;
      } else if (selectedPriority == 'High') {
        priorityValue = 1;
      }

      // use recurrenceRule to store the recurrence string
      if (selectedRecurrence == 'None') {
        recurrenceString = [];
      }

      var durationInSeconds = 0;

      durationInSeconds =
          ((durationHours ?? 0) * 60 * 60) + ((durationMinutes ?? 0) * 60);

      if (kDebugMode) {
        print('occ: $isOccurrence' ' selFor: $selFor' ' selOcc: $selOcc');
      }

      if (selectedRecurrence != 'None' && isOccurrence) {
        recurrenceDate = fromDate;
        RecurrenceWidgetState recurrenceWidgetState = RecurrenceWidgetState();
        recurrenceString[2] =
            recurrenceWidgetState.convertOccurrenceToDate(selFor, selOcc);
        isOccurrence = false;
      }

      final event = Event(
        id: (widget.event != null) ? widget.event!.id : "",
        title: titleController.text,
        description: '',
        location: placeId,
        placeName: placeName,
        from: fromDate,
        to: toDate,
        duration: await getDurationInMilliseconds(durationInSeconds),
        timeSlots: [timeSlot],
        category: selectedCategory,
        // backgroundColor: selectedColor,
        isDynamic: (selectedEventType == "Dynamic") ? true : false,
        isAllDay: false,
        priority: priorityValue,
        recurrenceRule: recurrenceString,
        isEndByDate: isEndDate,
      );

      if (event.location != "") {
        List<String> timeParts = travelTime.split(' ');

        // Initialize variables to store the hours, minutes, and seconds

        // Iterate through the timeParts and extract the corresponding values
        if (timeParts.length > 1) {
          for (int i = 0; i < timeParts.length; i += 2) {
            String unit = timeParts[i + 1];

            if (unit.contains('hour')) {
            } else if (unit.contains('minute')) {
            } else if (unit.contains('second')) {}
          }
        }
      }

      final serviceProvider =
          Provider.of<ServiceProvider>(context, listen: false);

      if (widget.event == null) {
        if (selectedEventType == 'Fixed' || selectedEventType == 'Dynamic') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NavigationScreen(initialIndex: 1)),
          );
        }
        var snackBar = SnackBar(
          content: Center(
            child: Text('Event is being created.',
                style: TextStyle(fontFamily: 'Railway', color: Colors.white)),
          ),
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        var response = await serviceProvider.createEvent(event);

        if (response) {
          eventProvider.retrieveEvents();
          showEventCreatedSnackBar(context);
        } else {
          var snackBar = SnackBar(
            content: Center(
              child: Text('Event Creation failed!',
                  style: TextStyle(fontFamily: 'Railway', color: Colors.white)),
            ),
            duration: Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        updatedEvent = event;
        if (selectedEventType == 'Fixed' || selectedEventType == 'Dynamic') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationScreen(initialIndex: 1),
            ),
          );
          showEventUpdatingSnackBar(context);
        }
        var response = await getUpdateResponse();

        if (response) {
          final contextProvider =
              Provider.of<ContextProvider>(context, listen: false);
          String? accessToken = serviceProvider.accessToken;
          await contextProvider.getEventsFromAPI(accessToken!);

          var snackBar = SnackBar(
            content: Center(
              child: Text('Event Updated!',
                  style: TextStyle(fontFamily: 'Railway', color: Colors.white)),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          needsReschedule = false;
        } else {
          var snackBar = SnackBar(
            content: Center(
              child: Text('Event Update Failed.',
                  style: TextStyle(fontFamily: 'Railway', color: Colors.white)),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          needsReschedule = false;
        }
      }
    }
  }

  Future<void> showEventCreatedSnackBar(BuildContext context) async {
    final contextProvider =
        Provider.of<ContextProvider>(context, listen: false);
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);

    await contextProvider.getEventsFromAPI(serviceProvider.accessToken!);
    var snackBar = SnackBar(
      content: Center(
        child: Text('Event is created!',
            style: TextStyle(fontFamily: 'Railway', color: Colors.white)),
      ),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showEventUpdatingSnackBar(BuildContext context) {
    var snackBar = SnackBar(
      content: Center(
        child: Text('Event is being updated!',
            style: TextStyle(fontFamily: 'Railway', color: Colors.white)),
      ),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> getUpdateResponse() async {
    if (needsReschedule) {
      return await Provider.of<ServiceProvider>(context, listen: false)
          .rescheduleEvent(updatedEvent!);
    } else {
      return await Provider.of<ServiceProvider>(context, listen: false)
          .updateEvent(updatedEvent!);
    }
  }

  Future<int> getDurationInMilliseconds(int durationInSeconds) async {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);

    final locationData = serviceProvider.locationData;

    int placeTravelTime = (placeId != "" && locationData != null)
        ? await serviceProvider.getLocationsTravelTime(
            placeId,
            serviceProvider.locationData!.latitude,
            serviceProvider.locationData!.longitude,
          )
        : 0;

    return (durationInSeconds * 1000) + placeTravelTime;
  }
}

class TimeEstimationWidget extends StatelessWidget {
  const TimeEstimationWidget({
    super.key,
    required this.placeID,
  });

  final String placeID;
  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    return getLocationWidget(context, serviceProvider);
  }

  Widget getLocationWidget(
      BuildContext context, ServiceProvider serviceProvider) {
    final locationData = serviceProvider.locationData;
    if (placeID == "") {
      return Text(
        'No Location Selected',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    } else if (locationData != null) {
      return FutureBuilder(
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              travelTime = getHumanText(snapshot.data);
              return Padding(
                  padding: const EdgeInsets.only(top: 3, left: 12),
                  child: Text(getHumanText(snapshot.data)));
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 3, left: 12),
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            }
          }),
          future: serviceProvider.getLocationsTravelTime(
            placeID,
            locationData.latitude,
            locationData.longitude,
          ));
    } else {
      return Text("");
    }
  }

  String getHumanText(int? travelTimeInSeconds) {
    if (travelTimeInSeconds == null) return 'Could not get travel time';

    int hours = travelTimeInSeconds ~/ 3600;
    int minutes = (travelTimeInSeconds % 3600) ~/ 60;
    int seconds = travelTimeInSeconds % 60;

    String hoursText = hours == 0 ? '' : '$hours hour${hours > 1 ? 's' : ''}';
    String minutesText =
        minutes == 0 ? '' : ' $minutes minute${minutes > 1 ? 's' : ''}';
    String secondsText =
        seconds == 0 ? '' : ' $seconds second${seconds > 1 ? 's' : ''}';

    return '$hoursText$minutesText$secondsText'.trim();
  }
}
