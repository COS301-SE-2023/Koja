import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

//Pages or widgets
import 'home_screen.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';

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
    const Tasks(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 18,
        currentIndex: _currentIndex,
        backgroundColor: Colors.blueAccent,
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
      ),
    );
  }
}
