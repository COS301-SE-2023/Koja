import 'dart:convert';

import 'package:client/providers/service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

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
  void updateEvent(Event updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    _events[index] = updatedEvent;
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
      _events.add(
        Event(
          title: e.summary,
          description: e.description ?? '',
          from: e.startDateTime,
          to: e.endDateTime,
        ),
      );
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

  Future<void> getEventsFromAPI(String accessToken) async {
    final serviceProvider = ServiceProvider();
    final response = await serviceProvider.getAllUserEvents();
    _events.clear();
    _events.addAll(response);
    notifyListeners();
  }

  Future<void> deleteEventAPICall(String eventId) async {
    try {
      final serviceProvider = ServiceProvider();
      final deleteSuccess = await serviceProvider.deleteEvent(eventId);

      if (deleteSuccess) {
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
