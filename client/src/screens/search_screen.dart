import 'package:flutter/material.dart';

import 'navigation_management_screen.dart';

class Search extends StatelessWidget {
  static const routeName = '/search';

  const Search({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Search Tab Content'),
      ),
      bottomNavigationBar: const NavigationScreen(),
    );
  }
}
