import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

import '../navigation/navigation.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({Key? key});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        color: Colors.purple.shade700,
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Navigation()),
                );
              },
              child: Container(
                height: 30,
                width: 200,
                child: Row(
                  children: [
                    LineIcon(
                      LineIcons.googlePlus,
                      size: 20.0,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10.0),
                    Text('Sign In With Google'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {},
              child: Container(
                height: 30,
                width: 200,
                child: Row(
                  children: [
                    LineIcon(
                      LineIcons.mailBulk,
                      size: 20.0,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10.0),
                    Text('Sign In With Email'),
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
