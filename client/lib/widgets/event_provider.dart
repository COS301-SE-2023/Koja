import 'package:flutter/material.dart';

import '../Utils/event_util.dart';

class EventProvider extends ChangeNotifier {
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
  // where((event) {
  //   //This returns the events of the selected date
  //   return isSameDay(event.from, _selectedDate);
  // }).toList();

  void addEvent(Event event) {
    //add event to the list
    _events.add(event);

    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    //edit event in the list
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
  }

  void deleteEvent(Event event) {
    //delete event from the list
    _events.remove(event);
    notifyListeners();
  }
}
