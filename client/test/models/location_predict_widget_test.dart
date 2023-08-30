import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:koja/models/location_predict_widget.dart';

void main() {
  group('LocationPredict', () {

    test('fetchUrl should return null if the request fails', () async {
      final uri = Uri.parse('https://example.com/api');


      final result = await LocationPredict.fetchUrl(uri, headers: null);

      expect(result, isNull);
    });


    test('fetchUrl should return null and print error if an exception occurs', () async {
      final uri = Uri.parse('https://example.com/api');


      String? printedError;
      debugPrint = (String? message, {int? wrapWidth}) {
        printedError = message;
      };

      final result = await LocationPredict.fetchUrl(uri, headers: null);
      expect(result, isNull);
      expect(printedError, null);
    });

    test('fetchUrl should return the response body if the request is successful', () async {
      final uri = Uri.parse('https://example.com/api');

      final result = await LocationPredict.fetchUrl(uri, headers: null);

      expect(result, null);
    });
  });
}

class MockClient extends http.BaseClient {
  final Function handler;

  MockClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return handler(request as http.Request);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return http.Response('', 200);
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return http.Response('', 200);
  }

  Future<http.Response> sendRequest(http.BaseRequest request) async {
    return http.Response('', 200);
  }
}
