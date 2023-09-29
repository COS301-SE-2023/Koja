import 'package:koja/providers/service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../providers/context_provider.dart';
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
    final eventProvider = Provider.of<ContextProvider>(context, listen: false);
    final editingController = TextEditingController();
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
                      eventProvider.navigationKey.currentContext!,
                      MaterialPageRoute(
                          builder: (_) =>  NavigationScreen()),
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
                child: SizedBox(
                  height: 30,
                  width: 200,
                  child: Row(
                    children: [
                      Expanded(
                      child:Icon(
                        Bootstrap.google,
                        size: 16.0,
                        color: Colors.red,
                      ),
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
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return Dialog(
                          child: SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                      scrollController: ScrollController(),
                                      scrollPhysics: BouncingScrollPhysics(),
                                      controller: editingController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(height: 10.0),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      serviceProvider.setAccessToken(
                                        editingController.text.trim(),
                                        eventProvider,
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        eventProvider.navigationKey.currentContext!,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              NavigationScreen(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: const Text('Login'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const SizedBox(
                    height: 30,
                    width: 200,
                    child: Row(
                      children: [
                        Expanded(
                        child: Icon(
                          Bootstrap.terminal,
                          size: 16.0,
                          color: Colors.white,
                        ),
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
