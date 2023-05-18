// ignore_for_file: prefer_const_constructors
// ignore: library_private_types_in_public_api

//Packages
import 'package:flutter/material.dart';

//Pages or widgets
import './screens/Login/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      theme: ThemeData(
        
      ),
    );
  }
}
