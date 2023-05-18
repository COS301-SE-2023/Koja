// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//widgets
import 'login_screen.dart';
import 'navigation_management_screen.dart';
import '../widgets/user_details_widget.dart';
import '../widgets/settings_widget.dart';
import 'event_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

//page import

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.logout_rounded,
                    size: 20.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Userdetails(),
          Settings(),
        ],
      ),
    );
    //calling the home page
    // return Home();
  }
}
