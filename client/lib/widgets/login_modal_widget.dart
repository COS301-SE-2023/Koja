import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../models/google_auth_model.dart';


import '../Utils/constants_util.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        color: darkBlue,
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
              onPressed: () async {
                print('Redirecting to Google Sign In');
                var user = await GoogleAuthModel.login();
                if (user != null) {
                  print('User is logged in');
                  print(user.displayName);
                  print(user.email);
                  // Navigator.pushNamed(context, NavigationScreen.routeName);
                } else {
                  print('User is not logged in');
                }
              },
              child: const SizedBox(
                height: 30,
                width: 200,
                child: Row(
                  children: [
                    Icon(
                      Bootstrap.google,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10.0),
                    Text('Sign In With Google',
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
