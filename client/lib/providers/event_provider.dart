import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../Utils/event_util.dart';
import '../models/event_wrapper_module.dart';

class EventProvider extends ChangeNotifier {
  String? _accessToken;

  List<EventWrapper> _eventWrappers = [];

  final Map<String, TimeSlot?> _timeSlots = {
    "Hobby": null,
    "Work": null,
    "School": null,
    "Resting": null,
    "Chore": null,
  };

  //This is the list of events
  final List<Event> _events = [];

  //getter for the events list
  List<Event> get events => _events;

  Map<String, TimeSlot?> get timeSlots => _timeSlots;

  setTimeSlot(String category, TimeSlot? timeSlot) {
    _timeSlots[category] = timeSlot;
    notifyListeners();
  }

  //This is the selected date
  late DateTime _selectedDate = DateTime.now();

  //getter for the selected date
  DateTime get selectedDate => _selectedDate;

  //setter for the selected date
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  //This returns the events of the selected date
  List<Event> get eventsOfSelectedDate => _events;

  //This adds an event to the list
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  //This edits an event in the list
  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
  }

  //This deletes an event from the list
  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  void setEventWrappers(List<EventWrapper> r) {
    _eventWrappers = r;
    for (EventWrapper e in _eventWrappers) {
      _events.add(Event(
        title: e.summary,
        description: e.description ?? '',
        from: e.startDateTime,
        to: e.endDateTime,
      ));
    }
    notifyListeners();
  }

  DateTime convertStringToDateTime(String dateTimeString) {
    // Remove the time zone offset from the string
    String formattedString =
        dateTimeString.replaceAll(RegExp(r'[+-]\d{2}:\d{2}$'), '');

    // Define the date format based on the input string
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");

    // Parse the string and return the DateTime object
    return format.parse(formattedString);
  }

  String? get accessToken => _accessToken;

  void setAccessToken({required String? accessToken}) {
    _accessToken = accessToken;
    notifyListeners();
    if (accessToken != null) getEventsFromAPI();
  }

  Future<void> getEventsFromAPI() async {
    var url = Uri.http('localhost:8080', '/api/v1/user/calendar/userEvents');
    var response =
        await http.get(url, headers: {"Authorisation": accessToken!});

    List<dynamic> jsonResponse = jsonDecode(response.body);
    for (var e in jsonResponse) {
      final tempEvent = Event.fromJson(e);
      _events.add(tempEvent);
    }
    notifyListeners();
  }

  void getLocation() async {
    
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      // Do something with currentLocation here
    });
  }

  
}
