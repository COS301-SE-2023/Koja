import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/Utils/event_util.dart';

void main() {
  test('Event test', () {
    // Create a sample event
    final event = Event(
      title: 'Meeting',
      description: 'Team meeting',
      location: 'Conference Room',
      from: DateTime(2023, 5, 22, 14, 30),
      to: DateTime(2023, 5, 22, 16, 0),
      backgroundColor: Colors.red,
      isAllDay: false,
    );

    // Test the properties of the event
    expect(event.title, equals('Meeting'));
    expect(event.description, equals('Team meeting'));
    expect(event.location, equals('Conference Room'));
    expect(event.from, equals(DateTime(2023, 5, 22, 14, 30)));
    expect(event.to, equals(DateTime(2023, 5, 22, 16, 0)));
    expect(event.backgroundColor, equals(Colors.red));
    expect(event.isAllDay, equals(false));
  });
}
