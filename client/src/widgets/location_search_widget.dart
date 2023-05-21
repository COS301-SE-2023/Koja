import 'package:flutter/material.dart';
import '';
import 'settings_widget.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a location',
            style: TextStyle(color: Colors.white)),
      ),
      body: 
    );
  }
}
