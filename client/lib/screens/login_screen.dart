import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';

import '../Utils/constants_util.dart';
import '../widgets/login_modal_widget.dart';

=======
import 'package:lottie/lottie.dart';

import '../widgets/login_modal_widget.dart';
import './information_screen.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({super.key});

  @override
<<<<<<< HEAD
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
=======
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
<<<<<<< HEAD
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: darkBlue,
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: darkBlue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button 1 press
                      },
                      child: Text('Get Started',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: 150,
                    //
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          isScrollControlled: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return const LoginModal();
                          },
                        );
                      },
                      child: Text('Sign In',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          textAlign: TextAlign.center),
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

=======
        children: [
          Container(
            height: (MediaQuery.of(context).size.height) * 0.5,
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/animations/juggle-time.json',
              height: 200, width: 300,
              repeat: false,
            ),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Say Goodbye To A \nMessy Schedule",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway', 
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "With Koja, you can easily manage your schedule and events with the help of our advanced strategies, which means less effort from you and more time saving!",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway', 
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Info()),
                );
              },
              child: const Text(
                "Learn More",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway', 
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom( 
                backgroundColor: Colors.blue[400], 
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                showDragHandle: true,
                isDismissible: true,
                isScrollControlled: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                context: context,
                builder: (context) => const LoginModal(),
              );
            },
            child: const Text(
              "Get Started",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway', 
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400], 
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const Spacer(),
         
        ],
      )
    );
  }
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
}
