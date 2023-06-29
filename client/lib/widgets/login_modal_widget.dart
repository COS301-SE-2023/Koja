import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import '../screens/google_auth_screen.dart';

import '../Utils/constants_util.dart';
=======
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
import '../screens/navigation_management_screen.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
<<<<<<< HEAD
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
=======
  LoginModalState createState() => LoginModalState();
}

class LoginModalState extends State<LoginModal> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return SingleChildScrollView(
      child: Container(
        height: 180, // 130
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
<<<<<<< HEAD
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
=======
                onPressed: () async {
                  final String authUrl =
                      'http://localhost:8080/api/v1/auth/app/google';

                  final String callbackUrlScheme = 'koja-login-callback';

                  FlutterWebAuth.authenticate(
                    url: authUrl,
                    callbackUrlScheme: callbackUrlScheme,
                  ).then((result) {
                    final value = Uri.parse(result).queryParameters['token'];
                    if (value != null) {
                      eventProvider.setAccessToken(accessToken: value);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  });
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
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                )),

            ///*
            SizedBox(height: 10.0),
            // if (kDebugMode)
            //   ElevatedButton(
            //       onPressed: () {
            //         Navigator.pushAndRemoveUntil(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const NavigationScreen()),
            //           (Route<dynamic> route) => false,
            //         );
            //       },
            //       child: const SizedBox(
            //         height: 30,
            //         width: 200,
            //         child: Row(
            //           children: [
            //             Icon(
            //               Bootstrap.terminal,
            //               size: 16.0,
            //               color: Colors.white,
            //             ),
            //             SizedBox(width: 10.0),
            //             Text('Debug Mode Route',
            //                 style:
            //                     TextStyle(color: Colors.white, fontSize: 16.0)),
            //           ],
            //         ),
            //       ),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blue,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20.0),
            //         ),
            //       )),
            // */
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD

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
=======
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
}
