// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable

import 'package:flutter/material.dart';

import '../screens/login_screen.dart';



class Settings extends StatelessWidget {
  Widget spacer = const SizedBox(width: 30, height: 8);
  Widget inline = const SizedBox(width: 10);
  Widget forwardarrow = const SizedBox(width: 60);

  Settings({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0),
            //Time Picker
            Row(
              children: [
                inline,
                Container(
                  height: 70,
                  width: 40,
                  decoration: BoxDecoration(
                    // color: Color.fromARGB(255, 191, 24, 238),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_time_sharp),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {},
                    iconSize: 40,
                  ),
                ),
                inline,
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Activity Time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      Text(
                        'Set the time you want to be active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                    ],
                  ),
                ),
                forwardarrow,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ],
            ),
            spacer,
            //Location
            Row(
              children: [
                inline,
                Container(
                  height: 70,
                  width: 40,
                  decoration: BoxDecoration(
                    // color: Color.fromARGB(255, 191, 24, 238),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.my_location_outlined),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {},
                    iconSize: 40,
                  ),
                ),
                inline,
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      Text(
                        'Set your location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            spacer,
            //About Us
            Row(
              children: [
                inline,
                Container(
                  height: 70,
                  width: 40,
                  decoration: BoxDecoration(
                    // color: Color.fromARGB(255, 191, 24, 238),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.info_outline),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {},
                    iconSize: 40,
                  ),
                ),
                inline,
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      Text(
                        'Learn more about the app',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 100),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 217, 0, 255)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 150,
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 20.0,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
