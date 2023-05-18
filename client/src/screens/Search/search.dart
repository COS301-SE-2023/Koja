// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Color.fromARGB(255, 14, 104, 222),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Search Tab Content'),
       
      ),
    );
  }
}