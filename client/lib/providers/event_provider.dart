import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../Utils/event_util.dart';
import '../models/event_wrapper_module.dart';

class EventProvider extends ChangeNotifier {
  String? _accessToken;

  List<EventWrapper> _eventWrappers = [];

  LocationData? locationData;

  late GlobalKey<ScaffoldMessengerState> scaffoldKey;

  void setScaffoldKey(GlobalKey<ScaffoldMessengerState> s) => scaffoldKey = s;

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
    deleteEventAPICall(event.id);
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
    _events.clear();
    for (var e in jsonResponse) {
      final tempEvent = Event.fromJson(e);
      _events.add(tempEvent);
    }
    notifyListeners();
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    // Get the current location
    LocationData currentLocation = await location.getLocation();
    locationData = currentLocation;
    return currentLocation;
  }

  Future<int> getPlaceTravelTime(String placeID) async {
    try {
      final location = await getLocation();
      if (location == null) return 0;

      final response = await http.get(
        Uri.parse(
          'http://localhost:8080/api/v1/location/travel-time?placeId=$placeID&destLat=${locationData!.latitude}&destLng=${locationData!.longitude}',
        ),
      );

      if (response.statusCode == 200) {
        String travelTime = response.body;
        return int.parse(travelTime);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }

    return 0;
  }

  Future<void> deleteEventAPICall(String eventId) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse('http://localhost:8080/api/v1/user/calendar/deleteEvent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorisation': _accessToken!,
        },
        body: eventId,
      );

      if (response.statusCode == 200) {
        final key = scaffoldKey;
        key.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Event successfully deleted.'),
          ),
        );
      } else {
        final key = scaffoldKey;
        key.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Failed to delete event.'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print(e);
      final key = scaffoldKey;
      key.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Failed to delete event.'),
        ),
      );
    }
  }
}
