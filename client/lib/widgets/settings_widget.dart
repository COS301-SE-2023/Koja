import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/about_us_screen.dart';
import 'location_search_widget.dart';
import 'time_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatelessWidget {
  var contexzz;
  Widget spacer = const SizedBox(width: 30, height: 8);
  Widget inline = const SizedBox(width: 10);
  Widget forwardarrow = const SizedBox(width: 60);

  Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    contexzz = context;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              /*  This is the Time Input Section  */
              Header(LineIcons.hourglassEnd, 'Set Your Active Times'),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 15),
              Container(
                height: 120,
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 90, 126, 165),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: WorkTimePicker(),
              ),
              const SizedBox(height: 10),
              Container(
                height: 123,
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 90, 126, 165),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: PersonalTimePicker('Personal Time'),
              ),

              /*  This is the Location Input Section  */

              const SizedBox(height: 15),
              Header(LineIcons.directions, 'Set Your Location'),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 15),
              Container(
                height: 180,
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 90, 126, 165),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Location(" Home Location"),
              ),
              const SizedBox(height: 15),
              Container(
                height: 180,
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 90, 126, 165),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Location(" Work Location"),
              ),

              /*  This is the About Us Section  */

              const SizedBox(height: 15),
              Header(LineIcons.tags, ' About Us'),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 15),
              Container(
                height: 161,
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 90, 126, 165),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: AboutUs(),
              ),
            ],
          ),
        );
      },
    );
  }

  /* This is the Header Section */

  Widget Header(IconData iconData, String text) {
    return Row(
      children: [
        Icon(iconData),
        const SizedBox(
            width: 2), // Add SizedBox for spacing between the icon and text
        Text(text,
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  /* This is the Work Time Input Section - only difference is the Text*/

  Widget WorkTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          '  Work Time',
          style: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TimePickers('Start Time'),
            TimePickers('End Time'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(width: 2, color: Colors.white),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  /* This is the Personal Time Input Section  - only difference is the Text */

  Widget PersonalTimePicker(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          '  $label',
          style: const TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TimePickers('Start Time'),
            TimePickers('End Time'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(width: 2, color: Colors.white),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget TimePickers(String label) {
    return Row(
      children: [
        // const SizedBox(width: 3),//Don't Change this
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const TimePickerWidget(),
      ],
    );
  }

  Widget AboutUs() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Koja',
          style: GoogleFonts.ubuntu(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Thanks for choosing Koja, with our application you will get dynamic and personalized recommendations for your next task.',
          style: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              contexzz,
              MaterialPageRoute(builder: (contexzz) => const AboutUsPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Learn More',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
          // onHover: ,
        ),
        Text("Version 1.0.5",
            style: GoogleFonts.ubuntu(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            )),
      ],
    );
  }

  Widget Location(String where) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          ' $where',
          style: const TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 3),
            Address("Tap Change"),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    contexzz,
                    MaterialPageRoute(
                        builder: (context) => const LocationSearch()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(width: 2, color: Colors.white),
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(
                      fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // TextInputType.text,
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(width: 2, color: Colors.white),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget Address(String address) {
    return SizedBox(
      width: 250,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white),
          ),
        ),
        child: Text(
          '  $address',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
