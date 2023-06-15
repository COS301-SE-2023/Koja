import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_util.dart';

//This class is used to display the events in the calendar
class EventDataSource extends CalendarDataSource {

  EventDataSource(List<Event> source) {
    appointments = source;
  }

  //DataSource is dynamic so this returns the "event" at the given index
  Event getEvent(int index) {
    return appointments![index] as Event;
  }
  
  @override
  DateTime getStartTime(int index) {
    return getEvent(index).from;
  }
  
  @override
  DateTime getEndTime(int index) {
    return getEvent(index).to;
  }
  
  @override
  String getSubject(int index) {
    return getEvent(index).title;
  }
  
  @override
  Color getColor(int index) {
    return getEvent(index).backgroundColor;
  }
  
  @override
  bool isAllDay(int index) {
    return getEvent(index).isAllDay;
  }

  @override
  String? getLocation(int index) {
    return getEvent(index).location;
  }

  //Add the category also
  String? getCategory(int index) {
    return getEvent(index).category;
  }
}