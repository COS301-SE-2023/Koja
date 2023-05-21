import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';
import 'navigation_management_screen.dart';

class Suggestions extends StatelessWidget {
  static const routeName = '/suggestions';

  const Suggestions({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: darkBlue,
        centerTitle: true,
        
      ),
      body: const Center(
        child: Text('Page Still Under Construction'),
      ),
    );
  }
}
