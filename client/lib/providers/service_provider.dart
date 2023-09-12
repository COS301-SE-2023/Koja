import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:koja/models/user_time_boundary_model.dart';
import 'package:koja/providers/context_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Utils/event_util.dart';

class ServiceProvider with ChangeNotifier {
  late String _serverAddress;
  late String _serverPort;

  String? _accessToken;
  Position? _locationData;

  String? get accessToken => _accessToken;
  Position? get locationData => _locationData;
  final int localServerPort = 43823;

  factory ServiceProvider() => _instance;

  static final ServiceProvider _instance = ServiceProvider._internal();

  ServiceProvider._internal() {
    // startServer();
    init();
  }

  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', localServerPort);

    server.listen((req) async {
      req.response.headers.add('Content-Type', 'text/html');
      req.response.write(
        (Platform.isWindows || Platform.isLinux)
            ? html.replaceFirst(
                'CALLBACK_URL_HERE',
                "http://localhost:$localServerPort/success?code=1337",
              )
            : html.replaceFirst(
                'CALLBACK_URL_HERE',
                'foobar://success?code=1337',
              ),
      );

      await req.response.close();
    });
  }

  Future<ServiceProvider> init() async {
    // startLocationListner(); TODO : FIX THIS
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

  /// This Section deals with all the AI related functions (suggestions, etc.)

  /// This function will attempt to get all the emails which will be used for suggestions
  Future<Map<String, String>> getEmailsForAI() async {
    final path = '/api/v1/ai/get-emails';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.get(
      url,
      headers: {'Authorization': _accessToken!},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      return result.map((key, value) => MapEntry(key, value.toString()));
    } else {
      return {};
    }
  }

  /// This function will attempt to get all the events which will be used for suggestions
  Future<List<String>> getEventsForAI() async {
    final path = '/api/v1/ai/get-user-events';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.get(
      url,
      headers: {'Authorization': _accessToken!},
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      return result.map((e) => e.toString()).toList();
    } else {
      return [];
    }
  }

  /// This Section deals with all the user related functions (emails, login, etc.)

  /// This function will attempt to login the user using AuthController

  Future<bool> loginUser({required ContextProvider eventProvider}) async {
    final String authUrl = kIsWeb
        ? '$_serverAddress:$_serverPort/api/v1/auth/google'
        : (Platform.isWindows || Platform.isLinux)
            ? '$_serverAddress:$_serverPort/api/v1/auth/desktop/google'
            : '$_serverAddress:$_serverPort/api/v1/auth/app/google';

    final String callBackScheme = kIsWeb
        ? _serverAddress
        : (Platform.isWindows || Platform.isLinux)
            ? "http://localhost:$localServerPort"
            : 'koja-login-callback';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: callBackScheme,
        preferEphemeral: true,
      );

      final response = Uri.parse(result).queryParameters['token'];

      setAccessToken(response, eventProvider);
      storeUserLocation();

      return accessToken != null;
    } on PlatformException catch (e) {
      if (kDebugMode) print('Authentication error: $e');
      return false;
    }
  }

  /// This function will attempt to add another email using UserAccountController
  Future<bool> addEmail({required ContextProvider eventProvider}) async {
    final String authUrl =
        '$_serverAddress:$_serverPort/api/v1/user/auth/add-email/google?token=$_accessToken';

    final String callbackUrlScheme = 'koja-login-callback';

    String? response = await FlutterWebAuth2.authenticate(
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
    final path = '/api/v1/user/remove-email';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _accessToken!,
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
    final path = '/api/v1/user/linked-emails';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.get(
      url,
      headers: {'Authorization': _accessToken!},
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
    final path = '/api/v1/user/delete-account';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _accessToken!,
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
    final path = '/api/v1/user/calendar/createEvent';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _accessToken!,
      },
      body: jsonEncode(event.toJson()),
    );
    print(jsonEncode(event.toJson()));
    return response.statusCode == 200;
  }

  /// This function will attempt to get all the events created by the user
  /// From CalendarController
  Future<List<Event>> getAllUserEvents() async {
    final path = '/api/v1/user/calendar/userEvents';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.get(
      url,
      headers: {'Authorization': _accessToken!},
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
    final path = '/api/v1/user/calendar/updateEvent';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _accessToken!,
      },
      body: jsonEncode(event.toJson()),
    );

    return response.statusCode == 200;
  }

  ///This function will reschedule the dynamic events
  Future<bool> rescheduleEvent(Event event) async {
    final path = '/api/v1/user/calendar/rescheduleEvent';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.post(
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

  /// This function will attempt to delete an event using CalendarController
  Future<bool> deleteEvent(Event event) async {
    final path = '/api/v1/user/calendar/deleteEvent';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _accessToken!,
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

  Future<bool> updateHomeLocation(String placeID) async {
    final path = '/api/v1/location/HomeLocationUpdater';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _accessToken!,
      },
      body: {
        'placeId': placeID,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateWorkLocation(String placeID) async {
    final path = '/api/v1/location/WorkLocationUpdater';
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': _accessToken!,
      },
      body: {
        'placeId': placeID,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// This function will set the current location of the user
  void setLocationData(Position? locationData) {
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
    final path = '/api/v1/location/travel-time';
    final body = {
      'placeId': placeID,
      'destLat': destLat.toString(),
      'destLng': destLng.toString(),
    };
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path, body)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path, body);

    final response =
        await http.get(url, headers: {'Authorization': _accessToken!});

    if (response.statusCode == 200) {
      String travelTime = response.body;
      return int.parse(travelTime);
    } else {
      return 0;
    }
  }

  Future<void> storeUserLocation() async {
    if (_locationData != null && _accessToken != null) {
      final path = '/api/v1/location/updateLocation';
      final body = {
        'latitude': _locationData!.latitude.toString(),
        'longitude': _locationData!.longitude.toString(),
      };
      final List<String> serverAddressComponents = _serverAddress.split("//");
      final url = !serverAddressComponents[0].contains("https")
          ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
          : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

      await http.post(
        url,
        headers: {'Authorisation': _accessToken!},
        body: body,
      );
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
      // final LocationSettings locationSettings = LocationSettings(
      //   accuracy: LocationAccuracy.high,
      //   distanceFilter: 100,
      // );
      // StreamSubscription<Position> positionStream =
      //     Geolocator.getPositionStream(locationSettings: locationSettings)
      //         .listen((Position? position) {
      //   if (position != null) {
      //     setLocationData(position);
      //   }
      // });
    }
  }

  /// This function will check if the user has granted location permissions
  Future<bool> _checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // final locatorPlatform = GeolocatorPlatform.instance;
    // final val = await locatorPlatform.openLocationSettings();
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission != LocationPermission.denied;
    }

    return false;
  }

  Future<List<UserTimeBoundaryModel>> getUserTimeBoundaries(
      String accessToken) async {
    final path = '/api/v1/user/getAllTimeBoundary';

    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    final response =
        await http.get(url, headers: {'Authorization': _accessToken!});

    if (response.statusCode == 200) {
      final List<dynamic> timeBoundariesJson = jsonDecode(response.body);
      return timeBoundariesJson
          .map((json) => UserTimeBoundaryModel.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> storeTimeFrames(
      String? accessToken, Map<String, TimeSlot?> timeSlots) async {
    final path = '/api/v1/user/addTimeBoundary';

    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

    if (accessToken != null) {
      for (String key in timeSlots.keys) {
        if (timeSlots[key] != null) {
          await deleteTimeFrame(accessToken, key).then((_) async {
            Map<String, String> requestBody = {
              'name': key,
              'startTime': DateFormat('HH:mm').format(
                timeSlots[key]!.startTime.toUtc(),
              ),
              'endTime': DateFormat('HH:mm').format(
                timeSlots[key]!.endTime.toUtc(),
              ),
              'type': timeSlots[key]!.bookable ? 'allowed' : 'blocked',
            };

            await http.post(
              url,
              headers: {'Authorization': accessToken},
              body: requestBody,
            );
          });
        } else {
          deleteTimeFrame(accessToken, key);
        }
      }
    }
  }

  Future<bool> deleteTimeFrame(String? accessToken, String name) async {
    if (accessToken != null) {
      final path = '/api/v1/user/removeTimeBoundary';

      final List<String> serverAddressComponents = _serverAddress.split("//");
      final url = !serverAddressComponents[0].contains("https")
          ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path)
          : Uri.https('${serverAddressComponents[1]}:$_serverPort', path);

      Map<String, String> requestBody = {
        'name': name,
      };

      final response = await http.post(
        url,
        headers: {'Authorization': _accessToken!},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> getSuggestionsForUser(String user) async {
    final path = '/api/v1/location/travel-time';
    final body = {
      'userID': user,
    };
    final List<String> serverAddressComponents = _serverAddress.split("//");
    final url = !serverAddressComponents[0].contains("https")
        ? Uri.http('${serverAddressComponents[1]}:$_serverPort', path, body)
        : Uri.https('${serverAddressComponents[1]}:$_serverPort', path, body);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      return {};
    }
  }
}
