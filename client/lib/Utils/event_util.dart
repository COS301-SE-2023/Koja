import 'package:flutter/material.dart';
import "dart:core";
import './date_and_time_util.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final String placeName;
  final DateTime from;
  final DateTime to;
  final int duration;
  final List<TimeSlot> timeSlots;
  final String category;
  late Color backgroundColor;
  final bool isAllDay;
  final int priority;
  final bool isDynamic;
  final List<String> recurrenceRule;
  final bool isEndByDate;

  Event({
    this.id = '',
    required this.title,
    this.description = '',
    this.location = '',
    this.placeName = '',
    required this.from,
    required this.to,
    this.duration = 0,
    this.timeSlots = const [],
    this.category = 'None',
    this.isAllDay = false,
    this.priority = 3,
    this.isDynamic = false,
    this.recurrenceRule = const [],
    this.isEndByDate = false,
  }){
    backgroundColor = calculateBackgroundColor();
  }

  Color calculateBackgroundColor() {
    final fromTime = int.parse(DateAndTimeUtil.toTime(from).replaceAll(':', ''));

    if (fromTime >= 0 && fromTime < 800) {
      return Colors.blue.shade600;
    } else if (fromTime >= 800 && fromTime < 1200) {
      return Colors.purple;
    } else if (fromTime >= 1200 && fromTime < 1500) {
      return Colors.pink;
    }
    else if (fromTime >= 1500 && fromTime < 1900) {
      return Colors.green;
    } else {
      return Colors.indigo;
    }
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        title: json['summary'] ?? "",
        description: json['description'] ?? "",
        location: json['location'] ?? "",
        placeName: json['placeName'] ?? "",
        from: DateTime.parse(json['startTime']).toLocal(),
        to: DateTime.parse(json['endTime']).toLocal(),
        duration: json['duration'] ?? 0,
        timeSlots: (json['timeSlots'] as List)
            .map((i) => TimeSlot.fromJson(i))
            .toList(),
        category: json['category'] ?? 'None',
        // backgroundColor: Colors.blue,
        priority: json['priority'] ?? 0,
        isDynamic: json['dynamic'],
        recurrenceRule: json['recurrence'] ?? [],
        isEndByDate: json['isEndByDate'] ?? false);
  }
  

  Map<String, dynamic> toJson() => {
        'id': id,
        'summary': title,
        'description': title,
        'location': location,
        'placeName': placeName,
        'startTime': from.toUtc().toIso8601String(),
        'endTime': to.toUtc().toIso8601String(),
        'duration': duration,
        'timeSlots': timeSlots,
        'category': category,
        'priority': priority,
        'dynamic': isDynamic,
        'recurrence': recurrenceRule,
      };
}

class TimeSlot {
  DateTime startTime;
  DateTime endTime;
  bool bookable = true;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.bookable,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      bookable: json['type'] == 'bookable',
    );
  }

  Map<String, dynamic> toJson() => {
        'startTime': startTime.toUtc().toIso8601String(),
        'endTime': endTime.toUtc().toIso8601String(),
        'bookable': bookable,
      };
}

