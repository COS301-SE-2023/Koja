import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LocationListWidget extends StatelessWidget {
  final List<String> locationNames;

  const LocationListWidget({
    Key? key,
    required this.locationNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(locationNames.isEmpty)
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

          if(locationNames.isNotEmpty)
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
      content: 
      Column(
        children: [
          if(locationNames.isEmpty)
          Lottie.asset(
            'assets/animations/empty.json',
            height: 150,
            width: 300,
            repeat: false,
          ),

          if(locationNames.isNotEmpty)
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
          
          if(locationNames.isNotEmpty)
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount:5,
              itemBuilder: (context, index) {
                final locationName = locationNames[index];
                return ListTile(
                  title: Text(locationName),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.delete_outline),
                  ),
                  // onTap: () {
                  //   Navigator.of(context).pop();
                  // },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
