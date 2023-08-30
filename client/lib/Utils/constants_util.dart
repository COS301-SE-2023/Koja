import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiKey = dotenv.env['API_KEY'] ?? "";
final String serverAddress = dotenv.env['SERVER_ADDRESS'] ?? "";
const darkBlue = Color(0xFF1976D2);

/// This store the list of locations
List<List<String>> locationList = [];

/// This store the Location of the user - Home and Work
String home = '';
String work = '';

/// This store the list of categories
List<List<String>> categories = [];

/// Helper variables for when editing a boundary
bool isEditing = false;
int editedindex = -1;

bool isEditingStart = false;
bool isEditingEnd = false;

TimeOfDay now = TimeOfDay.now();

String start = _formatTime(now.hour, now.minute).toString();
String end = _formatTime(now.hour, now.minute).toString();

String _formatTime(int hour, int minute) {
  // Convert the hour and minute to a 24-hour format string
  String formattedHour = hour.toString().padLeft(2, '0');
  String formattedMinute = minute.toString().padLeft(2, '0');

  return '$formattedHour:$formattedMinute';
}

/// Helper variables for when adding a block for travel time for event
String travelTime = "";

///helper variables for when adding recurrence
bool isRecurrence = false;
bool isEndDate = false;

DateTime? recurrenceEndDate = DateTime.now();
// double interval = 20.0;
String recurrenceString = "";
String recurrenceType = "Daily";
String selectedEnd = 'EndDate';


bool needsReschedule = false;

const int localServerPort = 43823;