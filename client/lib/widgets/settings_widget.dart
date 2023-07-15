import 'package:client/Utils/constants_util.dart';
import 'package:client/widgets/time_boundaries_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../models/autocomplete_predict_model.dart';
import '../models/place_auto_response_model.dart';
import '../models/location_predict_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about_us_widget.dart';
import 'account_settings_widget.dart';

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
                child: SingleChildScrollView(child: TimeBoundaries()),
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

            /*  This is the Account Settings Section  */
            const SizedBox(height: 15),
            header(LineIcons.user, ' Account Settings'),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 15),
            AccountSettingsWidget(),

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
                child: AboutUsWidget(),
              ),
            ),
          ],
        );
      },
    );
  }

  /* This is the Header Section */

  Widget header(IconData iconData, String text) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Icon(iconData),
        const SizedBox(width: 2),
        Text(text,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

/* This is the Home Location Input Section */
  Widget homeLocation(String where) {
    void updateLocation(String newLocationName, String newTime) {
      for (var i = 0; i < locationList.length; i++) {
        if (locationList[i][0] == newLocationName) {
          if (locationList[i][1] != newTime) {
            // Update the second value
            locationList[i][1] = newTime;
          }
          return;
        }
      }
      // Add new values to the list
      locationList.add([newLocationName, newTime]);
    }

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
                  style: const TextStyle(fontSize: 15, fontFamily: 'Roboto'),
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
                      icon: Icon(
                        Icons.clear,
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
                  controller: _homeTextController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your Home Address',
                    hintStyle: const TextStyle(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _homeTextController.clear();
                        setState(() {
                          placeAutoComplete("");
                        });
                      },
                      icon: Icon(Icons.clear),
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
                          updateLocation(home, "newTime");
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
    void updateLocation(String newLocationName, String newTime) {
      for (var i = 0; i < locationList.length; i++) {
        if (locationList[i][0] == newLocationName) {
          if (locationList[i][1] != newTime) {
            // Update the second value
            locationList[i][1] = newTime;
          }
          return;
        }
      }
      // Add new values to the list
      locationList.add([newLocationName, newTime]);
    }

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
                  style: const TextStyle(fontSize: 15, fontFamily: 'Roboto'),
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
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your Work Address',
                    hintStyle: const TextStyle(),
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
                          updateLocation(work, "newTime");
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
