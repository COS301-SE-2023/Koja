import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'location_search_widget.dart';
import 'time_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatelessWidget {

  var contexzz;
  Widget spacer = const SizedBox(width: 30, height: 8);
  Widget inline = const SizedBox(width: 10);
  Widget forwardarrow = const SizedBox(width: 60);

  Settings({super.key});
  @override
  Widget build(BuildContext context) {
    contexzz = context;
    return SingleChildScrollView(
      child: Column(
        children: [
          /*  This is the Time Input Section  */
          Header(LineIcons.hourglassEnd, 'Set Your Active Times'),
          Divider(height: 1, color: Colors.grey),
          SizedBox(height: 15),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: WorkTimePicker(),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: PersonalTimePicker('Personal Time'),
          ),

          /*  This is the Location Input Section  */

          SizedBox(height: 15),
          Header(LineIcons.directions, 'Set Your Location'),
          Divider(height: 1, color: Colors.grey),
          SizedBox(height: 15),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Location(" Home Location"),
          ),
          SizedBox(height: 15),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Location(" Work Location"),
          ),

          /*  This is the About Us Section  */

          SizedBox(height: 15),
          Header(LineIcons.tags, ' About Us'),
          Divider(height: 1, color: Colors.grey),
          SizedBox(height: 15),
          Container(
            height: 144,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: AboutUs(),
          ),
        ],
      ),
    );
  }

  /* This is the Header Section */

  Widget Header(IconData iconData, String text) {
    return Row(
      children: [
        Icon(iconData),
        SizedBox(
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
        SizedBox(height: 10),
        Text(
          '  Work Time',
          style: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TimePickers('Start Time'),
            TimePickers('End Time'),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: BorderSide(width: 2, color: Colors.white),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                    fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /* This is the Personal Time Input Section  - only difference is the Text */

  Widget PersonalTimePicker(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          '  $label',
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TimePickers('Start Time'),
            TimePickers('End Time'),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: BorderSide(width: 2, color: Colors.white),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                    fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget TimePickers(String label) {
    return Row(
      children: [
        SizedBox(width: 3),//Don't Change this
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        TimePickerWidget(),
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
        SizedBox(height: 10),
        Text(
          'Thanks for choosing Koja, with our application you will get dynamic and personalized recommendations for your next task.',
          style: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Learn More',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Icon(
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
        SizedBox(height: 15),
        Text(
          ' $where',
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 15),
            Address("Tap Change"),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
                contexzz,
                MaterialPageRoute(builder: (context) => const LocationSearch()),
              );
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: BorderSide(width: 2, color: Colors.white),
              ),
              child: Text(
                'Change',
                style: TextStyle(
                    fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // TextInputType.text,
            Container(
              margin: EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: BorderSide(width: 2, color: Colors.white),
                ),
                child: Text(
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
    return Container(
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white),
          ),
        ),
        child: Text(
          '  $address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
