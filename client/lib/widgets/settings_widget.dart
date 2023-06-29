<<<<<<< HEAD
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
=======
import 'package:client/Utils/constants_util.dart';
import 'package:client/widgets/time_boundaries_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../models/autocomplete_predict_model.dart';
import '../models/place_auto_response_model.dart';
import '../screens/about_us_screen.dart';
import '../models/location_predict_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late BuildContext ctx;

  List<AutocompletePrediction> placePredictions = [];
  List<AutocompletePrediction> workplacePredictions = [];

  Future<void> workplaceAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        'maps/api/place/autocomplete/json', {"input": query, "key": apiKey});

    String? response = await LocationPredict.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parsePlaceAutocompleteResponse(response);
      if (result.predictions != null) {
        setState(() {
          workplacePredictions =
              result.predictions!.cast<AutocompletePrediction>();
        });
      }
    }
  }

  Future<void> placeAutoComplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        'maps/api/place/autocomplete/json', {"input": query, "key": apiKey});

    String? response = await LocationPredict.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parsePlaceAutocompleteResponse(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!.cast<AutocompletePrediction>();
        });
      }
    }
  }

  final TextEditingController _homeTextController = TextEditingController();
  final TextEditingController _workTextController = TextEditingController();

  String home = '', work = '';

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            /*  This is the Time Boundary Section  */
            header(LineIcons.hourglassEnd, 'Set Your Active Times'),
            const Divider(height: 1, color: Color.fromARGB(255, 211, 198, 198)),
            const SizedBox(height: 15),
            SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(),
                    ),
                child: 
                    SingleChildScrollView(child: TimeBoundaries()),              
              ),
            ),
            const SizedBox(height: 20),

            /*  This is the Location Section  */
            header(LineIcons.directions, 'Set Your Location'),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 15),

            /*  This is the Home Location Section - redirects to HomeLocation Widget  */
            SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:
                    SingleChildScrollView(child: homeLocation("Home Location")),
              ),
            ),
            const SizedBox(height: 15),

            /*  This is the Work Location Section - redirects to WorkLocation Widget  */
            SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:
                    SingleChildScrollView(child: workLocation("Work Location")),
              ),
            ),

            /*  This is the About Us Section  */

            const SizedBox(height: 15),
            header(LineIcons.tags, ' About Us'),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 15),
            SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: aboutUs(),
              ),
            ),
          ],
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        );
      },
    );
  }

<<<<<<< HEAD
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
=======

  /* This is the Header Section */

  Widget header(IconData iconData, String text) {
    return Row(
      children: [
        Icon(iconData),
        const SizedBox(width: 2),
        Text(text,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )
        ),
      ],
    );
  }

  /* This is About Us Section */
  Widget aboutUs() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Koja',
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              // color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Thanks for choosing Koja, with our application you will get dynamic and personalized recommendations for your next task.',
            style: GoogleFonts.ubuntu(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              // color: Colors.black,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    // color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  // color: Colors.black,
                ),
              ],
            ),
          ),
          Text("Version 0.1.58",
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                // color: Colors.black,
              )),
        ],
      ),
    );
  }

/* This is the Home Location Input Section */
  Widget homeLocation(String where) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  ' $where : $home',
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 15, 
                      //color: Colors.black, 
                      fontFamily: 'Roboto'),
                ),
              ),
              if (home.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          home = '';
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                        // color: Colors.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    if (value.length > 2) {
                      placeAutoComplete(value);
                    } else {
                      setState(() {
                        placeAutoComplete("");
                      });
                    }
                  },
                  // cursorColor: Colors.black,
                  controller: _homeTextController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your Home Address',
                    hintStyle: const TextStyle(
                      // color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _homeTextController.clear();
                        setState(() {
                          placeAutoComplete("");
                        });
                      },
                      icon: const Icon(Icons.clear, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: placePredictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        placePredictions[index].description!,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          home = placePredictions[index].description!;
                          placeAutoComplete("");
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

/* This is the Personal Time Input Section  - only difference is the Text */
  Widget workLocation(String where) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  ' $where : $work',
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 15,
                      // color: Colors.black,
                      fontFamily: 'Roboto'),
                ),
              ),
              if (work.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          work = '';
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                        // color: Colors.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (wvalue) {
                    if (wvalue.length > 2) {
                      workplaceAutocomplete(wvalue);
                    } else {
                      setState(() {
                        workplaceAutocomplete("");
                      });
                    }
                  },
                  controller: _workTextController,
                  style: const TextStyle(color: Colors.black),
                  // cursorColor: Colors.black,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your Work Address',
                    hintStyle: const TextStyle(
                      // color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _workTextController.clear();
                        setState(() {
                          workplaceAutocomplete("");
                        });
                      },
                      icon: const Icon(Icons.clear, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                ListView.builder(
                   physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: workplacePredictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        workplacePredictions[index].description!,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          work = workplacePredictions[index].description!;
                          workplaceAutocomplete("");
                        });
                        
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
