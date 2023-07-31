import 'package:client/Utils/date_and_time_util.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  DateTime dateTime = DateTime.now();

  group('Date and Time Util Test', (){
    test('toMonth test', (){
      var formatDate = DateFormat.MMMM().format(dateTime);
      expect(formatDate, DateAndTimeUtil.toMonth(dateTime));
    });
    test('toDateTime test', (){
      var date = DateFormat.yMMMEd().format(dateTime);
      var time = DateFormat.Hm().format(dateTime);
      var result = '$date $time';

      expect(result, DateAndTimeUtil.toDateTime(dateTime));
    });
    test('toDate test',(){
      var formatDate = DateFormat.yMMMEd().format(dateTime);

      expect(formatDate, DateAndTimeUtil.toDate(dateTime));
    });
    test('toTime test',() {
      var formatDate = DateFormat.Hm().format(dateTime);
      expect(formatDate, DateAndTimeUtil.toTime(dateTime));
    });
  });
}