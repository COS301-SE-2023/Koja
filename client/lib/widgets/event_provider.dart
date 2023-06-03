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
}
