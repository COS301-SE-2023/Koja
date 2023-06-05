import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../widgets/login_modal_widget.dart';
import '../widgets/info_widget.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
          
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'KOJA',
                        textStyle: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
                Container(
                  child: Lottie.asset('assets/animations/9069-time.json',
                      height: 200, width: 200),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Unlike Any Other Scheduler That You Have Ever Used. This One Is More Advanced And More Efficient',
                          style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                
                        child: Text(
                          'Click "Get Started" To Know More',
                          style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Info()),
                      );
                    },
                    child: Text('Get Started',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w500,
                            color: Colors.black,
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
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
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
                            color: Colors.black,
                          ),
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
