import 'package:flutter/material.dart';

import 'navigation_management_screen.dart';

class Search extends StatelessWidget {
  static const routeName = '/search';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: Text('Search Tab Content'),
      ),
    );
  }
}