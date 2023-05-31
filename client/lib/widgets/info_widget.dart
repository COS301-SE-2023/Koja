import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Utils/constants_util.dart';
import '../widgets/login_modal_widget.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkBlue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: darkBlue,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'WHAT IS KOJA?',
                          textStyle: GoogleFonts.oswald(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
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
                  const SizedBox(height: 10),
                  Text(
                    'Koja is an advanced schedule management tool',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'that seamlessly integrates with Google Calendar.',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Lottie.asset(
                      'assets/animations/schedule.json',
                      height: 250,
                      width: 300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'It goes beyond traditional scheduling by offering',
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'dynamic task allocation and intelligent travel time calculations.',
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'With Koja, you can effortlessly manage your schedule, optimize your tasks,',
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'and ensure efficient use of your time.',
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
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
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
