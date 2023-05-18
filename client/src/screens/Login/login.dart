// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

//Pages
import '../../widgets/login/login_modal.dart';
import '../../widgets/navigation/navigation.dart';
import 'google_sign_in.dart';

class Login extends StatefulWidget {
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
              color: Color.fromARGB(255, 135, 18, 194),
              child: Center(
                child: Text(
                  'Koja',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.deepPurpleAccent.shade700,
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

  Future signIn() async {
    final token = await GoogleSignInApi().login();
    print("Token: $token ");
  }
}
