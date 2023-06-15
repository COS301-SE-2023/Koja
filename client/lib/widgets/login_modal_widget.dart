import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../models/google_auth_model.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  LoginModalState createState() => LoginModalState();
}

class LoginModalState extends State<LoginModal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
              onPressed: () async {
                // var user = await GoogleAuthModel.login();
                // if (user != null) {
                // } else {}
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
