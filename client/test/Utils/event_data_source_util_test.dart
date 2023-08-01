import 'package:client/Utils/event_data_source_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/Utils/event_util.dart';

void main(){
  var timeFrom = DateTime.now();
  var timeTo = DateTime(2024);
  var event = Event(title: 'School', from: timeFrom, to: timeTo);
  var event2 = Event(title: 'Work', from: timeFrom, to: timeTo);

  group('Event Data Source Util', () {
    List<Event> eventList = [];
    test('The event list is empty', (){
      expect(eventList.isEmpty, true);
    });


    test('The event list is not empty', () {
      eventList.addAll({event, event2});
      expect(eventList.isEmpty, false);
    });
    var eventDataSource = EventDataSource(eventList);
    test('It returns the correct events', (){
      var result1 = eventDataSource.getEvent(0);
      var result2 = eventDataSource.getEvent(1);
      expect(result1, event);
      expect(result2, event2);
    });

    test('The events return correct data', () {
      expect(eventDataSource.getSubject(0), event.title);
      expect(eventDataSource.getStartTime(0), event.from);
      expect(eventDataSource.getEndTime(0), event.to);
      expect(eventDataSource.getLocation(0), event.location);
      expect(eventDataSource.getCategory(0), event.category);
      expect(eventDataSource.getColor(0), event.backgroundColor);
      expect(eventDataSource.isAllDay(0), event.isAllDay);
    });
  });
}