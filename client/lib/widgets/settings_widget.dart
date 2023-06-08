import 'package:client/Utils/constants_util.dart';
import 'package:client/widgets/time_boundaries_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../models/autocomplete_predict_model.dart';
import '../models/place_auto_response_model.dart';
import '../screens/about_us_screen.dart';
import '../models/location_predict_widget.dart';
import 'time_picker_widget.dart';
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
            /*  This is the Time Input Section  */
            header(LineIcons.hourglassEnd, 'Set Your Active Times'),
            const Divider(height: 1, color: Color.fromARGB(255, 211, 198, 198)),
            const SizedBox(height: 15),
            SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: TimeBoundaries(),
               
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
                  color: darkBlue,
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
                  color: darkBlue,
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
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: aboutUs(),
              ),
            ),
          ],
        );
      },
    );
  }

  /*  This consists of all the days from Monday To Sunday */

  // Padding allDays(BoxConstraints constraints) {
  //   // return Column();
  // }

  /* This is the Header Section */

  Widget header(IconData iconData, String text) {
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
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Thanks for choosing Koja, with our application you will get dynamic and personalized recommendations for your next task.',
            style: GoogleFonts.ubuntu(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Text("Version 0.1.58",
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
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
                      fontSize: 15, color: Colors.black, fontFamily: 'Roboto'),
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
                        color: Colors.black,
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
                  cursorColor: Colors.black,
                  controller: _homeTextController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your Home Address',
                    hintStyle: const TextStyle(
                      color: Colors.black,
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
                        saveHomeLocation(placePredictions[index].placeId!);
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
                      fontSize: 15, color: Colors.black, fontFamily: 'Roboto'),
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
                        color: Colors.black,
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
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your Work Address',
                    hintStyle: const TextStyle(
                      color: Colors.black,
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
                        saveWorkLocation(workplacePredictions[index].placeId!);
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

  void saveHomeLocation(String placeId) {
    final backendurl = '';
    final data = {'placeId': placeId};

    // final response = http.post(Uri.parse(backendurl), body: json.encode(data));
  }

  void saveWorkLocation(String placeId) {
    final backendurl = '';
    final data = {'placeId': placeId};

    // final response = http.post(Uri.parse(backendurl), body: json.encode(data));
  }
}