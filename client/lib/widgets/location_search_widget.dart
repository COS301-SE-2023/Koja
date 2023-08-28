import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

import '../Utils/constants_util.dart';
import 'location_auto_complete.dart';
import 'location_tile.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});
  

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {

  List<Predictions> predictions = [];

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps.googleapis.com/maps/api/place/autocomplete/json",
        {"input": query, "key": apiKey});
    String? response = await NetworkUtility.fetchUrl(uri);

    if(response != null) {
      PlaceAutocompleteResponse results = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if(results.status == "OK") {
        setState(() {
          predictions = results.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a location',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  placeAutocomplete(value);
                },
                decoration: InputDecoration(
                  hintText: 'Enter a location',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ), 
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(LineIcons.mapMarker),
              label: Text(
                'Use current location',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          Divider(color: Colors.grey[400], thickness: 1, height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (BuildContext context, int index) { 
                  LocationListTile(
                    press: () {},
                    location: predictions[index].description!,
                    key: const Key('Hatfield, Pretoria, South Africa'),
                  );
                  return null;
               },
          
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkUtility {
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } 
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
  
}
