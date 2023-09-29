import 'package:intl/intl.dart';


class DateAndTimeUtil {

  static String toMonth(DateTime dateTime) {
    return DateFormat.MMMM().format(dateTime);
  }

  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  }

  static String toTime(DateTime dateTime){
    return DateFormat.Hm().format(dateTime);
  }

  // 23:59 is manually coded for the recurring events 
  static String toUTCFormat(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59).toUtc().toIso8601String();
  }

  static String forRecurrenceStart(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59).toUtc().toIso8601String();
  }

  // 2023-09-15T07:10:00.000Z
}