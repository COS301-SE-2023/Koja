import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

// Pages or widgets
import '../Utils/constants_util.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/navigation';
  final int initialIndex;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  NavigationScreen({Key? key, this.initialIndex = 0,}) : super(key: key);

  @override
  NavigationScreenState createState() => NavigationScreenState(initialIndex);
}

class NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex;

  NavigationScreenState(this._currentIndex);

  final List<Widget> _tabs = [
    const Home(),
    const Tasks(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 18,
        currentIndex: _currentIndex,
        backgroundColor: darkBlue,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Bootstrap.house),
            label: 'Home',
            activeIcon: Icon(Bootstrap.house_fill),
          ),
          BottomNavigationBarItem(
            icon: Icon(Bootstrap.calendar2),
            label: 'Tasks',
            activeIcon: Icon(Bootstrap.calendar2_check),
          ),
          BottomNavigationBarItem(
            icon: Icon(Bootstrap.person_badge),
            label: 'Profile',
            activeIcon: Icon(Bootstrap.person_badge_fill),
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
