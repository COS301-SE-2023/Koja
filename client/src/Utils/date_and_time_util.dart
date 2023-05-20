import 'package:flutter/material.dart';
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
}