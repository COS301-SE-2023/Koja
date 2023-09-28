import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koja/Utils/event_util.dart';

void main() {
  group('Event Util Test', () {
    test('Event test', () {
      // Create a sample userEvent
      final userEvent = Event(
        title: 'Meeting',
        description: 'Team meeting',
        location: 'Conference Room',
        from: DateTime(2023, 5, 22, 14, 30),
        to: DateTime(2023, 5, 22, 16, 0),
        backgroundColor: Colors.red,
        isAllDay: false,
      );

      // Test the properties of the userEvent
      expect(userEvent.title, equals('Meeting'));
      expect(userEvent.description, equals('Team meeting'));
      expect(userEvent.location, equals('Conference Room'));
      expect(userEvent.from, equals(DateTime(2023, 5, 22, 14, 30)));
      expect(userEvent.to, equals(DateTime(2023, 5, 22, 16, 0)));
      expect(userEvent.backgroundColor, equals(Colors.red));
      expect(userEvent.isAllDay, equals(false));
    });

    test('Event fromJson test', () {
      // Create a sample userEvent
      final userEvent = Event(
        title: 'Meeting',
        description: 'Team meeting',
        location: 'Conference Room',
        from: DateTime(2023, 5, 22, 14, 30),
        to: DateTime(2023, 5, 22, 16, 0),
        //backgroundColor: Colors.red,
        isAllDay: false,
      );

      // Create a sample json
      final json = {
        'id': '',
        'summary': 'Meeting',
        'description': 'Team meeting',
        'location': 'Conference Room',
        'startTime': '2023-05-22T14:30:00.000',
        'endTime': '2023-05-22T16:00:00.000',
        'duration': 0,
        'timeSlots': [],
        'priority': 1,
        'dynamic': false
      };

      // Test the properties of the userEvent
      expect(Event.fromJson(json).title, equals(userEvent.title));
      expect(Event.fromJson(json).description, equals(userEvent.description));
      expect(Event.fromJson(json).location, equals(userEvent.location));
      expect(Event.fromJson(json).from, equals(userEvent.from));
      expect(Event.fromJson(json).to, equals(userEvent.to));
      expect(Event.fromJson(json).backgroundColor, equals(userEvent.backgroundColor));
      expect(Event.fromJson(json).isAllDay, equals(userEvent.isAllDay));
    });

    test('should return Event object with correct properties', () {
      final Map<String, dynamic> json = {
        'id': 'test id',
        'summary': 'test summary',
        'description': 'test description',
        'location': 'test location',
        'startTime': DateTime.now().toUtc().toIso8601String(),
        'endTime': DateTime.now().toUtc().toIso8601String(),
        'duration': 60,
        'timeSlots': [],
        'priority': 1,
        'dynamic': true,
      };

      final event = Event.fromJson(json);

      expect(event.id, json['id']);
      expect(event.title, json['summary']);
      expect(event.description, json['description']);
      expect(event.location, json['location']);
      expect(event.from.toUtc(), DateTime.parse(json['startTime']).toUtc());
      expect(event.to.toUtc(), DateTime.parse(json['endTime']).toUtc());
      expect(event.duration, json['duration']);
      expect(event.priority, json['priority']);
      expect(event.isDynamic, json['dynamic']);
    });

    test('should return a Map with correct properties', () {
      final event = Event(
        id: 'test id',
        title: 'test summary',
        description: 'test description',
        location: 'test location',
        from: DateTime.now(),
        to: DateTime.now().add(Duration(hours: 1)),
        duration: 60,
        timeSlots: [],
        priority: 1,
        isDynamic: true,
      );

      final json = event.toJson();

      expect(json['id'], event.id);
      expect(json['summary'], event.title);
      expect(json['location'], event.location);
      expect(json['startTime'], event.from.toUtc().toIso8601String());
      expect(json['endTime'], event.to.toUtc().toIso8601String());
      expect(json['duration'], event.duration);
      expect(json['priority'], event.priority);
      expect(json['dynamic'], event.isDynamic);
    });

    test('fromJson should return TimeSlot object with correct properties', () {
      final Map<String, dynamic> json = {
        'startTime': DateTime.now().toUtc().toIso8601String(),
        'endTime': DateTime.now().toUtc().toIso8601String(),
        'type': 'bookable',
      };

      final timeSlot = TimeSlot.fromJson(json);

      expect(timeSlot.startTime.toIso8601String(), json['startTime']);
      expect(timeSlot.endTime.toIso8601String(), json['endTime']);
      expect(timeSlot.bookable, true);
    });

    test('toJson should return a Map with correct properties', () {
      final timeSlot = TimeSlot(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        bookable: true,
      );

      final json = timeSlot.toJson();

      expect(json['startTime'], timeSlot.startTime.toUtc().toIso8601String());
      expect(json['endTime'], timeSlot.endTime.toUtc().toIso8601String());
      expect(json['bookable'], timeSlot.bookable);
    });
  });
}
