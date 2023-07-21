import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiKey = dotenv.env['API_KEY'] ?? "";
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
String start = '';
String end = '';