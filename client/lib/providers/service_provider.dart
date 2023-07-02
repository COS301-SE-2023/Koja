import 'dart:convert';

import 'package:client/providers/event_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../Utils/event_util.dart';

class ServiceProvider with ChangeNotifier {
  String? _accessToken;
  LocationData? _locationData;

  String? get accessToken => _accessToken;
  LocationData? get locationData => _locationData;

  factory ServiceProvider() => _instance;

  static final ServiceProvider _instance = ServiceProvider._internal();

  ServiceProvider._internal() {
    init();
  }

  Future<void> setAccessToken(
      String? token, EventProvider eventProvider) async {
    _accessToken = token;
    if (accessToken != null) await eventProvider.getEventsFromAPI(accessToken!);
  }

  void setLocationData(LocationData? locationData) {
    _locationData = locationData;
    if (kDebugMode) print("User Location Set: $_locationData");
  }

  Future<bool> loginUser({required EventProvider eventProvider}) async {
    final String authUrl = 'http://localhost:8080/api/v1/auth/app/google';

    final String callbackUrlScheme = 'koja-login-callback';

    String? response = await FlutterWebAuth.authenticate(
      url: authUrl,
      callbackUrlScheme: callbackUrlScheme,
    );

    response = Uri.parse(response).queryParameters['token'];

    setAccessToken(response, eventProvider);

    return accessToken != null;
  }

  Future<bool> createEvent(Event event) async {
    final url = Uri.http('localhost:8080', '/api/v1/user/calendar/createEvent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
      body: jsonEncode(event.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<List<Event>> getAllUserEvents() async {
    final url = Uri.http('localhost:8080', '/api/v1/user/calendar/userEvents');
    final response = await http.get(
      url,
      headers: {'Authorisation': _accessToken!},
    );

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> updateEvent(Event event) async {
    final url = Uri.http('localhost:8080', '/api/v1/user/calendar/updateEvent');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
      body: jsonEncode(event.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteEvent(String eventId) async {
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
      return true;
    } else {
      return false;
    }
  }

  Future<int> getLocationsTravelTime(
      String placeID, double destLat, double destLng) async {
    final url = Uri.http('localhost:8080', '/api/v1/location/travel-time', {
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
      return 0;
    }
  }

  void startLocationListner() async {
    Location location = Location();

    location.serviceEnabled().then((serviceEnabled) {
      if (!serviceEnabled) {
        location.requestService().then((serviceEnabled) {
          if (!serviceEnabled) {
            setLocationData(null);
            return;
          }
        });
      }
    });

    location.hasPermission().then((permission) {
      if (permission == PermissionStatus.denied) {
        location.requestPermission().then((permission) {
          if (permission != PermissionStatus.granted) {
            setLocationData(null);
            return;
          }
        });
      }
    });

    location.onLocationChanged.listen((LocationData currentLocation) {
      setLocationData(currentLocation);
    });
  }

  Future<ServiceProvider> init() async {
    startLocationListner();
    return this;
  }
}
