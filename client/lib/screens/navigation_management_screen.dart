//Packages

import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';

//Pages or widgets
import 'home_screen.dart';
import 'profile_screen.dart';
import 'suggestions_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/navigation';
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const Home(),
    const Suggestions(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        currentIndex: _currentIndex,
        // backgroundColor: darkBlue,
        items: [ 
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_suggest),
            label: 'Suggestions',
            backgroundColor: ThemeData().colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: ThemeData().colorScheme.primary,
            
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        }
        
      ),
    );
  }
}
