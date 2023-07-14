import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client/Utils/constants_util.dart';

void main(){
  group('Constants Util test', (){
    test('color test',(){
      expect(darkBlue, Color(0xFF1976D2));
    });
  });
}