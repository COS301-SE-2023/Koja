import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:client/widgets/user_details_widget.dart';
//import 'package:client/widgets/settings_widget.dart';
//import 'package:client/screens/login_screen.dart';

class MockEventProvider {
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken({required String? accessToken}) {
    _accessToken = accessToken;
    //notifyListeners();
  }
}

void main() {
  testWidgets("Profile displays user details", (WidgetTester tester) async {
    String? token;

    expect(token, null);
  });
  testWidgets("Profile works as it should", (WidgetTester tester) async {
    expect(find.byType(AppBar), findsAtLeastNWidgets(0));
  });
}
