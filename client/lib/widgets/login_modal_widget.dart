import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../screens/navigation_management_screen.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
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
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
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
            if (kDebugMode)
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const SizedBox(
                    height: 30,
                    width: 200,
                    child: Row(
                      children: [
                        Icon(
                          Bootstrap.terminal,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0),
                        Text('Debug Mode Route',
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
          ],
        ),
      ),
    );
  }
}
