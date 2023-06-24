import 'package:flutter/material.dart';

class Event{
    final String title;
    final String description;
    final String location;
    final DateTime from;
    final DateTime to;
    final String category;
    final Color backgroundColor;
    final bool isAllDay;

    const Event({
        required this.title,
        this.description = '',
        this.location = '',
        required this.from,
        required this.to,
        this.category = '',
        this.backgroundColor = Colors.blue,
        this.isAllDay = false,
    });
}