import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEventProvider {
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken({required String? accessToken}) {
    _accessToken = accessToken;
    //notifyListeners();
  }
}

void main() {
  testWidgets("Profile widget test", (WidgetTester tester) async {

    expect(find.byType(AppBar), findsAtLeastNWidgets(0));
    String? token;

    expect(token, null);
  });
}

