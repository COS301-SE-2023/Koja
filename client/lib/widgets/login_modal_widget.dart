import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import '../screens/google_auth_screen.dart';

import '../Utils/constants_util.dart';

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
        color: darkBlue,
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
              onPressed: () {
                signIn(context);
              },
              child: SizedBox(
                height: 30,
                width: 200,
                child: Row(
                  children: [
                    LineIcon(
                      LineIcons.googlePlus,
                      size: 20.0,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10.0),
                    const Text('Sign In With Google'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Container(
            //     height: 30,
            //     width: 200,
            //     child: Row(
            //       children: [
            //         LineIcon(
            //           LineIcons.mailBulk,
            //           size: 20.0,
            //           color: Colors.red,
            //         ),
            //         SizedBox(width: 10.0),
            //         Text('Sign In With Email'),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future signIn(context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GoogleAuthScreen(),
      ),
    );
    // print("Evetns: $events");
    // if (events != null) {
    //   Navigator.of(context).pushReplacementNamed(NavigationScreen.routeName);
    // }
  }
}
