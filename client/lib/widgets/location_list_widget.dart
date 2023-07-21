import 'package:client/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Utils/constants_util.dart';

class LocationListWidget extends StatefulWidget {
  const LocationListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  void delete(int index) {
    setState(() {
      locationList.removeAt(index);
    });
  }

  Future<int> getLocation(int index)  {
    return ServiceProvider().getLocationsTravelTime(
      locationList[index][1], -25.7562574, 28.2409557); 
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (locationList.isEmpty)
            Center(
              child: Text(
                'No Saved Locations',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          if (locationList.isNotEmpty)
            Center(
              child: Text(
                'From Current Location',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.cancel_outlined,
              size: 30,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      contentPadding: EdgeInsets.all(16),
      content: Column(
        children: [
          if (locationList.isEmpty)
            Lottie.asset(
              'assets/animations/empty.json',
              height: 150,
              width: 300,
              repeat: false,
            ),
          if (locationList.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "To:",
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
            ),
          if (locationList.isNotEmpty)
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: locationList.length,
                itemBuilder: (context, index) {
                  /* Update the traveling time before displaying  */
                  // for (var i = 0; i < locationList.length; i++) {
                  //   //caluculate the time using locationList[i][1] and locationData
                  //   locationList[i][1] = "just now";
                  // }

                  final locationName = locationList[index][0];
                  final locationTime = getLocation(index);

                  final locationTimeString = locationTime.toString();

                  // print(locationTime);
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            locationName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            locationTimeString,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        delete(index);
                      },
                      child: Icon(Icons.delete_outline),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
