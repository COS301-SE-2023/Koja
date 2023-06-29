<<<<<<< HEAD
//Packages

import 'package:flutter/material.dart';

//Pages or widgets
import 'home_screen.dart';
import 'profile_screen.dart';
import 'suggested_screen.dart';
=======
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

//Pages or widgets
import '../Utils/constants_util.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

class NavigationScreen extends StatefulWidget {
  static const routeName = '/navigation';
  const NavigationScreen({super.key});

  @override
<<<<<<< HEAD
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

=======
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const Home(),
<<<<<<< HEAD
    const Suggestions(),
=======
    const Tasks(),
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
<<<<<<< HEAD
        iconSize: 25,
        currentIndex: _currentIndex,
        
        items: [ 
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: ThemeData().colorScheme.primary,
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
        
=======
        iconSize: 18,
        currentIndex: _currentIndex,
        backgroundColor: darkBlue,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Bootstrap.house),
            label: 'Home',
            activeIcon: Icon(Bootstrap.house_fill)
          ),
          BottomNavigationBarItem(
            icon: Icon(Bootstrap.calendar2),
            label: 'Tasks',
            activeIcon: Icon(Bootstrap.calendar2_check)
          ),
          BottomNavigationBarItem(
            icon: Icon(Bootstrap.person_badge),
            label: 'Profile',
            activeIcon: Icon(Bootstrap.person_badge_fill)
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
      ),
    );
  }
}
