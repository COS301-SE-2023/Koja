import 'dart:convert';
import 'package:timezone/standalone.dart' as tz;

class EventWrapper {
  Map<String, dynamic> json;

  EventWrapper(String jsonString) : json = jsonDecode(jsonString) {
    tz.initializeTimeZone();
  }

  String get created => json['created'];

  String? get description => json['description'];

  DateTime get startDateTime {
    String dateTimeString = json['start']['dateTime'];
    String timeZoneName = json['start']['timeZone'];
    tz.TZDateTime dateTime =
        tz.TZDateTime.parse(tz.getLocation(timeZoneName), dateTimeString);
    return dateTime.toLocal();
  }

  DateTime get endDateTime {
    String dateTimeString = json['end']['dateTime'];
    String timeZoneName = json['end']['timeZone'];
    tz.TZDateTime dateTime =
        tz.TZDateTime.parse(tz.getLocation(timeZoneName), dateTimeString);
    return dateTime.toLocal();
  }

  String get summary => json['summary'];

  String get status => json['status'];
}
