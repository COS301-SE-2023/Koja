import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SuggestionsTasksScreen extends StatelessWidget {
  static const routeName = '/suggestions';

  const SuggestionsTasksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
