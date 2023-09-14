import 'package:flutter/material.dart';
import "dart:core";

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime from;
  final DateTime to;
  final int duration;
  final List<TimeSlot> timeSlots;
  final String category;
  final Color backgroundColor;
  final bool isAllDay;
  final int priority;
  final bool isDynamic;
  final List<String> recurrenceRule;

   Event({
    this.id = '',
    required this.title,
    this.description = '',
    this.location = '',
    required this.from,
    required this.to,
    this.duration = 0,
    this.timeSlots = const [],
    this.category = 'None',
    this.backgroundColor = Colors.blue,
    this.isAllDay = false,
    this.priority = 3,
    this.isDynamic = false,
    this.recurrenceRule = const [],
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        title: json['summary'] ?? "",
        description: json['description'] ?? "",
        location: json['location'] ?? "",
        from: DateTime.parse(json['startTime']).toLocal(),
        to: DateTime.parse(json['endTime']).toLocal(),
        duration: json['duration'] ?? 0,
        timeSlots: (json['timeSlots'] as List)
            .map((i) => TimeSlot.fromJson(i))
            .toList(),
        priority: json['priority'] ?? 0,
        category: json['category'] ?? 'None',
        recurrenceRule: json['recurrence'] ?? [],
        isDynamic: json['dynamic']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'summary': title,
        'description': title,
        'location': location,
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
