import 'dart:async';
import 'dart:convert';

import 'package:client/providers/context_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:fl_location/fl_location.dart';

import '../Utils/event_util.dart';

class ServiceProvider with ChangeNotifier {
  late String _serverAddress;
  late String _serverPort;

  String? _accessToken;
  Location? _locationData;
  StreamSubscription<Location>? _locationSubscription;

  String? get accessToken => _accessToken;
  Location? get locationData => _locationData;

  factory ServiceProvider() => _instance;

  static final ServiceProvider _instance = ServiceProvider._internal();

  ServiceProvider._internal() {
    init();
  }

  Future<ServiceProvider> init() async {
    startLocationListner();
    _serverAddress = dotenv.get("SERVER_ADDRESS", fallback: "10.0.2.2");
    _serverPort = dotenv.get("SERVER_PORT", fallback: "8080");
    return this;
  }

  Future<void> setAccessToken(
      String? token, ContextProvider eventProvider) async {
    _accessToken = token;
    if (token != null) {
      eventProvider.init(token);
    }
  }

  /// This Section deals with all the user related functions (emails, login, etc.)

  /// This function will attempt to login the user using AuthController
  Future<bool> loginUser({required ContextProvider eventProvider}) async {
    final String authUrl =
        'http://$_serverAddress:$_serverPort/api/v1/auth/app/google';

    final String callbackUrlScheme = 'koja-login-callback';

    String? response = await FlutterWebAuth.authenticate(
      url: authUrl,
      callbackUrlScheme: callbackUrlScheme,
    );

    response = Uri.parse(response).queryParameters['token'];

    setAccessToken(response, eventProvider);

    return accessToken != null;
  }

  /// This function will attempt to add another email using UserAccountController
  Future<bool> addEmail({required ContextProvider eventProvider}) async {
    final String authUrl =
        'http://$_serverAddress:$_serverPort/api/v1/user/auth/add-email/google?token=$_accessToken';

    final String callbackUrlScheme = 'koja-login-callback';

    String? response = await FlutterWebAuth.authenticate(
      url: authUrl,
      callbackUrlScheme: callbackUrlScheme,
    );

    response = Uri.parse(response).queryParameters['token'];

    setAccessToken(response, eventProvider);

    return accessToken != null;
  }

  /// This function will attempt to delete an email from the user's account
  /// From UserAccountController
  Future<void> deleteUserEmail(
      {required String email, required ContextProvider eventProvider}) async {
    final url =
        Uri.http('$_serverAddress:$_serverPort', '/api/v1/user/remove-email');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
      body: email,
    );

    if (response.statusCode == 200) {
      setAccessToken(response.body, eventProvider);
    }
  }

  /// This function will attempt to get all the emails entered by the user
  /// From UserController
  Future<List<String>> getAllUserEmails() async {
    final url =
        Uri.http('$_serverAddress:$_serverPort', '/api/v1/user/linked-emails');
    final response = await http.get(
      url,
      headers: {'Authorisation': _accessToken!},
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      return result.map((e) => e.toString()).toList();
    } else {
      return [];
    }
  }

  /// This function will delete the user's account from Koja
  /// From UserController
  Future<bool> deleteUserAccount() async {
    final url =
        Uri.http('$_serverAddress:$_serverPort', '/api/v1/user/delete-account');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// This section deals with all the calendar related functions (events, etc.)

  /// This function will attempt to create an event using CalendarController
  Future<bool> createEvent(Event event) async {
    final url = Uri.http(
        '$_serverAddress:$_serverPort', '/api/v1/user/calendar/createEvent');
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

  /// This function will attempt to get all the events created by the user
  /// From CalendarController
  Future<List<Event>> getAllUserEvents() async {
    final url = Uri.http(
        '$_serverAddress:$_serverPort', '/api/v1/user/calendar/userEvents');
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

  /// This function will attempt to update an event using CalendarController
  Future<bool> updateEvent(Event event) async {
    final url = Uri.http(
        '$_serverAddress:$_serverPort', '/api/v1/user/calendar/updateEvent');
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

  /// This function will attempt to delete an event using CalendarController
  Future<bool> deleteEvent(Event event) async {
    final url = Uri.http(
        '$_serverAddress:$_serverPort', '/api/v1/user/calendar/deleteEvent');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': _accessToken!,
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// This section deals with all the location related functions (travel time, etc.)

  /// This function will set the current location of the user
  void setLocationData(Location? locationData) {
    _locationData = locationData;
    if (kDebugMode) print("User Location Set: $_locationData");
    storeUserLocation();
  }

  /// This function will get the longitude and latitude of _locationData
  List<double> getLocation() {
    if (_locationData == null) {
      return [0.0, 0.0];
    } else {
      return [_locationData!.latitude, _locationData!.longitude];
    }
  }

  /// This function will attempt to get the travel time from the user's current location
  Future<int> getLocationsTravelTime(
      String placeID, double destLat, double destLng) async {
    final url = Uri.http(
        '$_serverAddress:$_serverPort', '/api/v1/location/travel-time', {
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

  Future<void> storeUserLocation() async {
    if (_locationData != null) {
      final url = Uri.http(
          '$_serverAddress:$_serverPort', '/api/v1/location/updateLocation', {
        'latitude': _locationData!.latitude.toString(),
        'longitude': _locationData!.longitude.toString(),
      });

      await http.get(url, headers: {'Authorisation': _accessToken!});
    }
  }

  /// This function will wait for the user to grant location permissions
  void startLocationListner() async {
    if (await _checkAndRequestPermission()) {
      _listenLocationStream();
    }
  }

  /// This function will start listening to the location stream
  Future<void> _listenLocationStream() async {
    if (await _checkAndRequestPermission()) {
      if (_locationSubscription != null) {
        await _cancelLocationSubscription();
      }

      _locationSubscription = FlLocation.getLocationStream().handleError((e) {
        if (kDebugMode) {
          print(e);
        }
      }).listen((event) {
        if (_locationData != null &&
            event.latitude != _locationData!.latitude &&
            event.longitude != _locationData!.longitude) {
          setLocationData(event);
        }
      });
    }
  }

  /// This function will cancel the location subscription
  Future<void> _cancelLocationSubscription() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  /// This function will check if the user has granted location permissions
  Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) return false;
    }

    if (background == true &&
        locationPermission == LocationPermission.whileInUse) return false;

    return true;
  }
}
