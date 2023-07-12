import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:client/models/location_predict_widget.dart';

void main() {
  group('LocationPredict', () {

    test('fetchUrl should return null if the request fails', () async {
      final uri = Uri.parse('https://example.com/api');

      http.Response mockResponse = http.Response('', 500);
      http.Client mockClient = MockClient((http.Request request) async {
        expect(request.url, uri);
        return mockResponse;
      });

      final result = await LocationPredict.fetchUrl(uri, headers: null);

      expect(result, isNull);
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

  // Provide dummy implementations for other methods

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return http.Response('', 200);
  }

  @override
  Future<http.Response> sendRequest(http.BaseRequest request) async {
    return http.Response('', 200);
  }
}
