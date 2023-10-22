import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/about_us_screen.dart';

class AboutUsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Koja',
            style: GoogleFonts.ubuntu(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Thanks for choosing Koja, with our application you will get dynamic and personalized recommendations for your next task.',
            style: GoogleFonts.ubuntu(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Learn More',
                  style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
              ],
            ),
          ),
          Text("Version 1.0.0",
            style: GoogleFonts.ubuntu(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )
          ),
        ],
      ),
    );
  }
}