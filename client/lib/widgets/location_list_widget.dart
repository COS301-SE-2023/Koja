import 'package:flutter/material.dart';

class LocationListWidget extends StatelessWidget {
  const LocationListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'From Current Locagtion',
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
      backgroundColor: Colors.grey[100],
      contentPadding: EdgeInsets.all(16),
      content: Column(
        children: [
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
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('$index'),
                  trailing: GestureDetector
                  (
                    onTap: ()
                    {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.delete_outline)
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
