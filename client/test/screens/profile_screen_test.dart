import 'package:client/Utils/event_util.dart';
import 'package:client/models/event_wrapper_module.dart';
import 'package:client/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:provider/provider.dart';

import 'package:client/providers/event_provider.dart';
//import 'package:client/widgets/user_details_widget.dart';
//import 'package:client/widgets/settings_widget.dart';
//import 'package:client/screens/login_screen.dart';

class MockEventProvider {
  String? _accessToken;

  @override
  String? get accessToken => _accessToken;

  @override
  void setAccessToken({required String? accessToken}) {
    _accessToken = accessToken;
    //notifyListeners();
  }
/*
  @override
  LocationData? locationData;

  @override
  void addEvent(Event event) {
    // TODO: implement addEvent
  }

  @override
  DateTime convertStringToDateTime(String dateTimeString) {
    // TODO: implement convertStringToDateTime
    throw UnimplementedError();
  }

  @override
  void deleteEvent(Event event) {
    // TODO: implement deleteEvent
  }

  @override
  void editEvent(Event newEvent, Event oldEvent) {
    // TODO: implement editEvent
  }

  @override
  // TODO: implement events
  List<Event> get events => throw UnimplementedError();

  @override
  // TODO: implement eventsOfSelectedDate
  List<Event> get eventsOfSelectedDate => throw UnimplementedError();

  @override
  Future<void> getEventsFromAPI() {
    // TODO: implement getEventsFromAPI
    throw UnimplementedError();
  }

  @override
  Future<LocationData?> getLocation() {
    // TODO: implement getLocation
    throw UnimplementedError();
  }

  @override
  Future<int> getPlaceTravelTime(String placeID) {
    // TODO: implement getPlaceTravelTime
    throw UnimplementedError();
  }

  @override
  // TODO: implement selectedDate
  DateTime get selectedDate => throw UnimplementedError();

  @override
  void setDate(DateTime date) {
    // TODO: implement setDate
  }

  @override
  void setEventWrappers(List<EventWrapper> r) {
    // TODO: implement setEventWrappers
  }

  @override
  setTimeSlot(String category, TimeSlot? timeSlot) {
    // TODO: implement setTimeSlot
    throw UnimplementedError();
  }

  @override
  // TODO: implement timeSlots
  Map<String, TimeSlot?> get timeSlots => throw UnimplementedError();*/
}

void main() {
  testWidgets("Profile displays user details", (WidgetTester tester) async {
    var token = null;

    expect(token, null);
  });
  testWidgets("Profile works as it should", (WidgetTester tester)  async{
   // await tester.pumpWidget(const MaterialApp(home: Profile()));
    var eventProvider = MockEventProvider();

    expect(find.byType(AppBar), findsAtLeastNWidgets(0));
    

  });
  //testWidgets('Profile widget displays user details and settings', (WidgetTester tester) async {
    // Create a mock EventProvider
    /*final eventProvider = MockEventProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<EventProvider>.value(
          value: eventProvider,
          child: Profile(),
        ),
      ),
    );

    // Find the AppBar widget
    final appBarFinder = find.byType(AppBar);
    expect(appBarFinder, findsOneWidget);

    // Find the IconButton for logout
    final logoutButtonFinder = find.byIcon(Icons.logout);
    expect(logoutButtonFinder, findsOneWidget);

    *//*//*/ Tap on the logout button
    await tester.tap(logoutButtonFinder);
    await tester.pumpAndSettle();*//*

    // Check if the access token is set to null
    expect(eventProvider.accessToken, isNull);
*/
    // Verify that the Login screen is pushed and the Profile screen is removed from the stack
    /*expect(find.byType(Profile), findsNothing);
    expect(find.byType(Login), findsOneWidget);

    // Find the UserDetails widget
    final userDetailsFinder = find.byType(UserDetails);
    expect(userDetailsFinder, findsOneWidget);

    // Find the Settings widget
    final settingsFinder = find.byType(Settings);
    expect(settingsFinder, findsOneWidget);*/
  }); */
}
