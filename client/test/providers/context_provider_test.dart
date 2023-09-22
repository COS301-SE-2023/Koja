import 'package:koja/Utils/event_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:koja/providers/service_provider.dart';

// This class uses the Mockito package to create a mock ServiceProvider
class MockServiceProvider extends Mock implements ServiceProvider {}

void main() {
  group('ContextProvider', () {
    late ContextProvider eventProvider;

    setUp(() {
      eventProvider = ContextProvider();
    });

    test('setDate changes selected date and notifies listeners', () {
      bool notified = false;
      eventProvider.addListener(() => notified = true);

      eventProvider.setDate(DateTime(2022, 1, 1));

      expect(eventProvider.selectedDate, DateTime(2022, 1, 1));
      expect(notified, true);
    });

    test('addEvent adds an event and notifies listeners', () {
      bool notified = false;
      eventProvider.addListener(() => notified = true);

      var event = Event(title: 'Test', from: DateTime.now(), to: DateTime.now()); // fill out according to your Event constructor
      // fill out according to your Event constructor

      eventProvider.addEvent(event);

      expect(eventProvider.events.contains(event), true);
      expect(notified, true);
    });

    test('updateEvent updates an event and notifies listeners', () {
      bool notified = false;
      eventProvider.addListener(() => notified = true);

      var event = Event(title: 'Test', from: DateTime.now(), to: DateTime.now(), id: 'newevent1'); // fill out according to your Event constructor

      eventProvider.addEvent(event);

      expect(eventProvider.events.contains(event), true);

      var updatedEvent = Event(title: 'Test', from: DateTime.now(), to: DateTime.now(), id: 'newevent1'); // fill out according to your Event constructor

      eventProvider.updateEvent(updatedEvent);

      expect(eventProvider.events.contains(updatedEvent), true);
      expect(notified, true);
    });
  });
}
