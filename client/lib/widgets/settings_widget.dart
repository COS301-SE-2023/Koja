import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/about_us_screen.dart';
import 'location_search_widget.dart';
import 'time_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late BuildContext contexzz;

  final TextEditingController _textController = TextEditingController();
  TextEditingController _homeTextController = TextEditingController();
  TextEditingController _workTextController = TextEditingController();

  String home = '', work = '';

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
              SingleChildScrollView(
                child: Container(
                  width: constraints.maxWidth * 0.95,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 90, 126, 165),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: AllDays(constraints),
                  /* This is the Expansion Tile for the days */
                ),
              ),

              const SizedBox(height: 20),

              /*  This is the Location Section  */
              Header(LineIcons.directions, 'Set Your Location'),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 15),

              /*  This is the Home Location Section - redirects to HomeLocation Widget  */
              SingleChildScrollView(
                child: Container(
                  width: constraints.maxWidth * 0.95,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 90, 126, 165),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: HomeLocation("Home Location"),
                ),
              ),
              const SizedBox(height: 15),

              /*  This is the Work Location Section - redirects to WorkLocation Widget  */
              SingleChildScrollView(
                child: Container(
                  width: constraints.maxWidth * 0.95,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 90, 126, 165),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: WorkLocation("Work Location"),
                ),
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

  Padding AllDays(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        trailing: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        title: Text("Click To Set Active Times For Everyday", 
          style: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          )
        ),  
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white),
            ),
            child: ExpansionTile(
              backgroundColor: darkBlue,          
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              title: Text(
                'Monday',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: constraints.maxWidth * 0.95,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 126, 165),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        WorkTimePicker(),
                        PersonalTimePicker('Personal Time'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ), 
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white),
            ),
            child: ExpansionTile(
              backgroundColor: darkBlue,          
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              title: Text(
                'Tuesday',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: constraints.maxWidth * 0.95,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 126, 165),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        WorkTimePicker(),
                        PersonalTimePicker('Personal Time'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white),
            ),
            child: ExpansionTile(
              backgroundColor: darkBlue,          
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              title: Text(
                'Wednesday',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: constraints.maxWidth * 0.95,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 126, 165),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        WorkTimePicker(),
                        PersonalTimePicker('Personal Time'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white),
            ),
            child: ExpansionTile(
              backgroundColor: darkBlue,          
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              title: Text(
                'Thursday',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: constraints.maxWidth * 0.95,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 126, 165),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        WorkTimePicker(),
                        PersonalTimePicker('Personal Time'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white),
            ),
            child: ExpansionTile(
              backgroundColor: darkBlue,          
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              title: Text(
                'Friday',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: constraints.maxWidth * 0.95,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 126, 165),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        WorkTimePicker(),
                        PersonalTimePicker('Personal Time'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white),
            ),
            child: ExpansionTile(
              backgroundColor: darkBlue,          
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              title: Text(
                'Saturday',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: constraints.maxWidth * 0.95,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 126, 165),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        WorkTimePicker(),
                        PersonalTimePicker('Personal Time'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 90, 126, 165),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white),
            ),
            child: ExpansionTile(
              backgroundColor: darkBlue,          
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              title: Text(
                'Sunday',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: constraints.maxWidth * 0.95,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 126, 165),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        WorkTimePicker(),
                        PersonalTimePicker('Personal Time'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        const SizedBox(width: 2),
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

  /* This is About Us Section */
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
            // foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            elevation: 10,
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

/* This is the Home Location Input Section */
  Widget HomeLocation(String where) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            SizedBox(width: 5),
            Text(
              ' $where : $home',
              style: const TextStyle(
                  fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
            ),
          ],
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _homeTextController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Your Home Address',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _homeTextController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
              SizedBox(height: 3),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    home = _homeTextController.text;
                  });
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

/* This is the Personal Time Input Section  - only difference is the Text */
  Widget WorkLocation(String where) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            SizedBox(width: 5),
            Text(
              ' $where : $work',
              style: const TextStyle(
                  fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
            ),
          ],
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _workTextController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Your Work Address',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _workTextController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    work = _workTextController.text;
                  });
                },
                color: Colors.blue,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
}