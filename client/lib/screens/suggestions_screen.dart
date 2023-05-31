import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Utils/constants_util.dart';

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
      body: Center(
        child: 
        Lottie.asset(
          'assets/animations/under-construction.json',
          height: 550,
          width: 300,
        ),
      ),
    );
  }
}
