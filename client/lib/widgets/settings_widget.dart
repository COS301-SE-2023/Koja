import 'package:flutter/material.dart';
import 'package:koja/widgets/user_manual_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:pdfx/pdfx.dart';

import '../Utils/constants_util.dart';
import '../providers/service_provider.dart';
import './time_boundaries_widget.dart';
import '../models/autocomplete_predict_model.dart';
import '../models/place_auto_response_model.dart';
import '../models/location_predict_widget.dart';
import './about_us_widget.dart';
import './account_settings_widget.dart';

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

  String placeId = "";

  ServiceProvider serviceProvider = ServiceProvider();

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
            header(LineIcons.book, ' User Manual'),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 15),
            SingleChildScrollView(
              child: Column(
                children: [  
                  UserManual(),               
                ],
              ),
            ),

            /*  This is the About Us Section  */

            const SizedBox(height: 15),
            header(LineIcons.tags, ' About Us'),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 15),
            SingleChildScrollView(
              child: Column(
                children: [  
                  Container(
                    width: constraints.maxWidth * 0.95,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: AboutUsWidget(),
                  ),                 
                  SizedBox(height: 5),
                ],
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
    void updateLocation(String newLocationName, String locationID) {
      for (var i = 0; i < locationList.length; i++) {
        if (locationList[i][0] == newLocationName) {
          if (locationList[i][1] != locationID) {
            // Update the second value
            locationList[i][1] = locationID;
          }
          return;
        }
      }
      // Add new values to the list
      locationList.add([newLocationName, locationID]);
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
                        Bootstrap.x_circle,
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
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _homeTextController.clear();
                        setState(() {
                          placeAutoComplete("");
                        });
                      },
                      icon: Icon(Bootstrap.x_circle),
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
                          placeId = placePredictions[index].placeId!;
                          serviceProvider.updateHomeLocation(placeId);
                          updateLocation(home, placeId);
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
    void updateLocation(String newLocationName, String locationID) {
      for (var i = 0; i < locationList.length; i++) {
        if (locationList[i][0] == newLocationName) {
          if (locationList[i][1] != locationID) {
            // Update the second value
            locationList[i][1] = locationID;
          }
          return;
        }
      }
      // Add new values to the list
      locationList.add([newLocationName, locationID]);
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
                        Bootstrap.x_circle,
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
                  onChanged: (wValue) {
                    if (wValue.length > 2) {
                      workplaceAutocomplete(wValue);
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
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _workTextController.clear();
                        setState(() {
                          workplaceAutocomplete("");
                        });
                      },
                      icon: Icon
                      (Bootstrap.x_circle , color: Colors.black),
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
                          placeId = workplacePredictions[index].placeId!;
                          serviceProvider.updateWorkLocation(placeId);
                          updateLocation(work, placeId);
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

  Widget UserManual()
  {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Manual',
            style: GoogleFonts.ubuntu(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 176,
                child: Text(
                  'View The User Manual',
                  style: GoogleFonts.ubuntu(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black),
                ),
              ),
              SizedBox(width: 2),
              IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    darkBlue,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManualPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}