import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../models/autocomplete_predict_model.dart';
import '../models/place_auto_response_model.dart';
import '../screens/about_us_screen.dart';
import './location_predict_widget.dart';
import 'time_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late BuildContext contexzz;

  List<AutocompletePrediction> Placepredictions = [];

  Future<void> PlaceAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        'maps/api/place/autocomplete/json', {"input": query, "key": apiKey});

    String? response = await LocationPredict.fetchUrl(uri);
    if (response != null) {
      placeAutocompleteResponse result = placeAutocompleteResponse.parsePlaceAutocompleteResponse(response);
      if(result.predictions != null)
      {
        setState(() {
          Placepredictions = result.predictions!.cast<AutocompletePrediction>();
        });
      }
    }
  }

  final TextEditingController _homeTextController = TextEditingController();
  final TextEditingController _workTextController = TextEditingController();

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
                    color: darkBlue,
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
                    color: darkBlue,
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
                    color: darkBlue,
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
              SingleChildScrollView(
                child: Container(
                  width: constraints.maxWidth * 0.95,
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: AboutUs(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /*  This consists of all the days from Monday To Sunday */
  
  Padding AllDays(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        trailing: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        title: Text("Click To Set Active Times For Everyday",
            style: GoogleFonts.ubuntu(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            )),
        children: [
          Container(
            decoration: BoxDecoration(
              color: darkBlue,
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
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
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

          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: darkBlue,
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
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
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
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: darkBlue,
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
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
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
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: darkBlue,
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
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
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
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: darkBlue,
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
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
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
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: darkBlue,
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
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
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
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: darkBlue,
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
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
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
    return SingleChildScrollView(
      child: Column(
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
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget TimePickers(String label) {
    return SingleChildScrollView(
      child: Row(
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
      ),
    );
  }

  /* This is About Us Section */
  Widget AboutUs() {
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
          Text("Version 2.0.2",
              style: GoogleFonts.raleway(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

/* This is the Home Location Input Section */
  Widget HomeLocation(String where) {
    return SingleChildScrollView(
      // scrollDirection: Axis.horizontal,
      child: Container(
        // height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(width: 5),
                Text(
                  ' $where : $home',
                  style: const TextStyle(
                      fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
                    softWrap: true,
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
                          color: Colors.white,
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
                        PlaceAutocomplete(value);
                      }
                      else {
                        setState(() {
                          Placepredictions = [];
                        });
                      }
                    },
                    cursorColor: Colors.white,
                    controller: _homeTextController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: const OutlineInputBorder(),
                      hintText: 'Enter Your Home Address',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _homeTextController.clear();
                        },
                        icon: const Icon(Icons.clear, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),                        
                  SizedBox(
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: Placepredictions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              Placepredictions[index].description!,
                              textAlign: TextAlign.start,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                home = Placepredictions[index].description!;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),                     
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

/* This is the Personal Time Input Section  - only difference is the Text */
  Widget WorkLocation(String where) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 5),
              Text(
                ' $where : $work',
                style: const TextStyle(
                    fontSize: 15, color: Colors.white, fontFamily: 'Roboto'),
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
                        color: Colors.white,
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
                        PlaceAutocomplete(value);
                      }
                      else {
                        setState(() {
                          Placepredictions = [];
                        });
                      }
                    },
                  controller: _workTextController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your Work Address',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _workTextController.clear();
                      },
                      icon: const Icon(Icons.clear, color: Colors.white),
                    ),
                  ),
                ), 
                const SizedBox(height: 1),                        
                SizedBox(
                  child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: Placepredictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            Placepredictions[index].description!,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              home = Placepredictions[index].description!;
                            });
                          },
                        );
                      },
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

}