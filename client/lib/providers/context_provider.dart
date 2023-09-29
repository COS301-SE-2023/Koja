import 'dart:async';

import 'package:koja/providers/service_provider.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/event_util.dart';
import '../models/event_wrapper_module.dart';
import '../models/user_time_boundary_model.dart';

class ContextProvider extends ChangeNotifier {
  String? _accessToken;
  List<String> userEmails = [];
  List<Event> recommendedEvents = [];
  List<Event> lockedEvents = [];

  void init(String accessToken) {
    _accessToken = accessToken;
    startUpdater();
  }

  void startUpdater() {
    getData();
    final timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_accessToken != null) {
        getData();
        if(kDebugMode) timer.cancel();
      } else {
        timer.cancel();
      }
    });
    if (kDebugMode) {
      print(timer);
    }
  }

  void getData() {
    getEventsFromAPI(_accessToken!);
    getUserTimeslots(_accessToken!);
    getAllUserEmails();
  }

  List<EventWrapper> _eventWrappers = [];

  Location? locationData;

  late GlobalKey<ScaffoldMessengerState> scaffoldKey;
  late GlobalKey<NavigatorState> navigationKey;

  void setScaffoldKey(GlobalKey<ScaffoldMessengerState> s) => scaffoldKey = s;
  void setNavigationKey(GlobalKey<NavigatorState> s) => navigationKey = s;

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
    ServiceProvider().storeTimeFrames(accessToken, timeSlots);
    notifyListeners();
  }

  void getUserTimeslots(String accessToken) async {
    final items = await ServiceProvider().getUserTimeBoundaries(accessToken);
    for (UserTimeBoundaryModel item in items) {
      final relevantTimeslots = convertTimeStringsToDateTime(
        item.startTime!,
        item.endTime!,
      );
      if (relevantTimeslots['startTime'] != null &&
          relevantTimeslots['endTime'] != null) {
        _timeSlots[item.name!] = TimeSlot(
            startTime: relevantTimeslots['startTime']!,
            endTime: relevantTimeslots['endTime']!,
            bookable: (relevantTimeslots['type'] != null &&
                    relevantTimeslots['type']!.toString() == "allowed")
                ? true
                : false);
      }
    }
    notifyListeners();
  }

  Map<String, DateTime> convertTimeStringsToDateTime(
      String startTime, String endTime) {
    final now = DateTime.now();

    final List<String> startParts = startTime.split(':');
    final int startHour = int.parse(startParts[0]);
    final int startMinute = int.parse(startParts[1]);

    final List<String> endParts = endTime.split(':');
    final int endHour = int.parse(endParts[0]);
    final int endMinute = int.parse(endParts[1]);

    DateTime startDateTime =
        DateTime(now.year, now.month, now.day, startHour, startMinute);

    // Assuming end time is always equal to or later than start time
    int endDay = now.day;

    // If end time is earlier than start time, then it is the next day
    if (endHour < startHour ||
        (endHour == startHour && endMinute < startMinute)) {
      endDay = now.day + 1;
    }

    DateTime endDateTime =
        DateTime(now.year, now.month, endDay, endHour, endMinute);

    return {"startTime": startDateTime, "endTime": endDateTime};
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

  Event getEventByDate(DateTime date) {
    return _events.firstWhere(
      (event) =>
          event.from.year == date.year &&
          event.from.month == date.month &&
          event.from.day == date.day,
      orElse: () => Event(
        title: 'No events',
        description: '',
        from: DateTime.now(),
        to: DateTime.now(),
      ),
    );
  }

  //This returns the events of the selected date
  List<Event> get eventsOfSelectedDate => _events;

  List<Event> get recomendedEventsSelection => recommendedEvents;

  List<Event> get lockedEventsSelection => lockedEvents;

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
    deleteEventAPICall(event);
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

  Future<void> getAllUserEmails() async {
    final serviceProvider = ServiceProvider();
    final response = await serviceProvider.getAllUserEmails();
    userEmails.clear();
    userEmails.addAll(response);
    notifyListeners();
  }

  Future<void> deleteEventAPICall(Event event) async {
    try {
      final serviceProvider = ServiceProvider();
      final deleteSuccess = await serviceProvider.deleteEvent(event);

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

  void retrieveEvents() {
    if (accessToken != null) {
      getEventsFromAPI(accessToken!);
    }
  }

  void setRecommended(List<Event> list) {
    recommendedEvents = list;
  }

  void toggleEventLocked(userEvent) {
    if (lockedEvents.contains(userEvent)) {
      lockedEvents.remove(userEvent);
    } else {
      lockedEvents.add(userEvent);
    }

    notifyListeners();
  }

  void clearLockedEvents() {
    lockedEvents.clear();
    notifyListeners();
  }
}
