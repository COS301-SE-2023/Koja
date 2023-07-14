import 'package:client/providers/service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        height: 180, // 130
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
                onPressed: () async {
                  if (await serviceProvider.loginUser(
                      eventProvider: eventProvider)) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationScreen()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User login failed'),
                      ),
                    );
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
                        builder: (context) => const NavigationScreen(),
                      ),
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
