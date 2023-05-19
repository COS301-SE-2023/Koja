// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable

import 'package:flutter/material.dart';


import 'settings_list_widget.dart';

class Settings extends StatelessWidget {
  Widget spacer = const SizedBox(width: 30, height: 8);
  Widget inline = const SizedBox(width: 10);
  Widget forwardarrow = const SizedBox(width: 60);

  Settings({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          settingslist(),            
        ],
      ),
    );
  }
}
