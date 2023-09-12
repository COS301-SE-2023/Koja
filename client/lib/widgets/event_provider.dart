import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/event_util.dart';
import '../models/event_wrapper_module.dart';

class EventProvider extends ChangeNotifier {
  List<EventWrapper> _eventWrappers = [];

  //This is the list of events
  final List<Event> _events = [];

  //getter for the events list
  List<Event> get events => _events;

  //This is the selected date
  DateTime _selectedDate = DateTime.now();

  //getter for the selected date
  DateTime get selectedDate => _selectedDate;

  //setter for the selected date
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  //This returns the events of the selected date
  List<Event> get eventsOfSelectedDate => _events;
  // where((userEvent) {
  //   //This returns the events of the selected date
  //   return isSameDay(userEvent.from, _selectedDate);
  // }).toList();

  void addEvent(Event userEvent) {
    //add userEvent to the list
    _events.add(userEvent);

    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    //edit userEvent in the list
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
  }

  void deleteEvent(Event userEvent) {
    //delete userEvent from the list
    _events.remove(userEvent);
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
}
