// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

//Pages
import '../widgets/login_modal_widget.dart';

import 'home_screen.dart';
import 'navigation_management_screen.dart';
import 'profile_screen.dart';
import '../models/google_auth_model.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              child: Center(
                child: Text(
                  'Koja',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button 1 press
                      },
                      child: Text('Get Started'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    width: 150,
                    //
                    child: ElevatedButton(
                      onPressed: signIn, // {
                      // showModalBottomSheet(
                      // context: context,
                      // isDismissible: true,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(30.0),
                      //     topRight: Radius.circular(30.0),
                      //   ),
                      // ),
                      // // builder: (BuildContext context) {
                      // //   return LoginModal();
                      // // },
                      // );
                      //},
                      child: Text('Sign In'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Initialize the browser oauth2 flow functionality then use it to obtain credentials.
  Future<AccessCredentials> obtainCredentials() async {
    return await requestAccessCredentials(
        clientId:
            "317800768757-1o32l18bigldbdn6gta1rcbl5m04l8gd.apps.googleusercontent.com",
        scopes: [
          'email',
          'https://www.googleapis.com/auth/calendar.events',
        ]);
  }

  Future signIn() async {
    final token = await obtainCredentials();
    print("Access token: ${token.accessToken}");

    if (token != null) {
      Navigator.of(context).pushReplacementNamed(NavigationScreen.routeName);
    }
  }
}
