import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:koja/Utils/constants_util.dart';

void main(){
  setUp(() async{
    await dotenv.load(fileName: "assets/.env");
  });
  group('Constants Util test', (){
    test('color test',(){
      expect(darkBlue, Color(0xFF1976D2));
    });


    test('should return formatted time string', () {
      final hour = 13;
      final minute = 5;

      final result = _formatTime(hour, minute);

      expect(result, '13:05');
    });

    test('should pad single digit hour or minute with a zero', () {
      final hour = 5;
      final minute = 9;

      final result = _formatTime(hour, minute);

      expect(result, '05:09');
      expect(start, _formatTime(now.hour, now.minute).toString());
      expect(end, _formatTime(now.hour, now.minute).toString());

    });
  });
}

String _formatTime(int hour, int minute) {
  // Convert the hour and minute to a 24-hour format string
  String formattedHour = hour.toString().padLeft(2, '0');
  String formattedMinute = minute.toString().padLeft(2, '0');

  return '$formattedHour:$formattedMinute';
}