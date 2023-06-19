import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/Utils/event_util.dart';

void main() {
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
}
