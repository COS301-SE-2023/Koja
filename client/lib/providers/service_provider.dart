import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Utils/event_util.dart';

class ServiceProvider extends ChangeNotifier {
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Future<void> createEvent(Event event) async {
    final url = Uri.http('localhost:8080', '/api/v1/user/calendar/createEvent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
      body: jsonEncode({
        'token': _accessToken,
        'event': event.toJson(),
      }),
    );

    if (response.statusCode == 200) {
    } else {}
  }

  Future<List<Event>> getAllUserEvents() async {
    final url = Uri.http('localhost:8080', '/api/v1/user/calendar/userEvents');
    final response =
        await http.get(url, headers: {'Authorisation': _accessToken!});

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateEvent(Event event) async {
    final url = Uri.http('localhost:8080', '/api/v1/user/calendar/updateEvent');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
      body: jsonEncode({
        'token': _accessToken,
        'event': event.toJson(),
      }),
    );

    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> deleteEvent(String eventId) async {
    final url = Uri.http('localhost:8080', '/api/v1/user/calendar/deleteEvent');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
      body: eventId,
    );

    if (response.statusCode == 200) {
    } else {}
  }

  Future<int> getLocationsTravelTime(
      String placeID, double destLat, double destLng) async {
    final url =
        Uri.http('localhost:8080', '/api/v1/user/calendar/travel-time', {
      'placeId': placeID,
      'destLat': destLat.toString(),
      'destLng': destLng.toString(),
    });
    final response =
        await http.get(url, headers: {'Authorisation': _accessToken!});

    if (response.statusCode == 200) {
      String travelTime = response.body;
      return int.parse(travelTime);
    } else {
      // Handle error
      return 0;
    }
  }
}
