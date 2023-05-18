//Packages
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//Pages or widgets
import '../../screens/Events/event.dart';
import '../../screens/Home/home.dart';
import '../../screens/Search/search.dart';
import '../../screens/Profile/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Navigation> {
  int _currentIndex = 3;
  final List<Widget> _tabs = [
    Home(),
    Event(),
    Search(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: _tabs[_currentIndex],
          bottomNavigationBar: Container(
            // purple.shade700
            color: Colors.deepPurpleAccent.shade700,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              child: GNav(
                backgroundColor: Colors.deepPurpleAccent.shade700,
                color: Colors.white,
                activeColor: Colors.white,
                textStyle: const TextStyle(
                  fontFamily: 'PTSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                tabBackgroundColor: Colors.purple.shade700,
                tabBorderRadius: 50,
                tabMargin:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                padding: const EdgeInsets.all(16),
                gap: 8,
                iconSize: 24,
                curve: Curves.easeInToLinear,
                tabs: const [
                  GButton(
                    icon: Icons.home_filled,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.event_busy_sharp,
                    text: 'Events',
                  ),
                  GButton(
                    icon: Icons.search_rounded,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.person_outlined,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _currentIndex,
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          )),
    );
  }
}
