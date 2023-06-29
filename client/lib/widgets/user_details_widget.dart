<<<<<<< HEAD
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';
import '../screens/login_screen.dart';

class Userdetails extends StatelessWidget {

  String profile = "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg?quality=90&resize=500,454";
  String email = "koja@epi-use.com";
=======
import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';

class UserDetails extends StatelessWidget {
  final String profile, email;

  UserDetails({required this.profile, required this.email});
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      padding: EdgeInsets.all(16),
<<<<<<< HEAD
      decoration: BoxDecoration(
=======
      decoration: const BoxDecoration(
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        color: darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Align(
<<<<<<< HEAD
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Container(
                height: 40,
                width: 44,
                color: Color.fromRGBO(250, 250, 250, 0.1),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    side: BorderSide(width: 2, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Center(
                    child: Icon(
                      Icons.logout_outlined,
                      size: 19,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
=======
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
<<<<<<< HEAD
                ClipOval(
                  //This is the profile picture 
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      profile,
=======
                const ClipOval(
                  //This is the profile picture
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/icons/coffee.png',
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
                    ),
                  ),
                ),
                //This is the name of the user
                Text(
                  email,
<<<<<<< HEAD
                  style: TextStyle(
=======
                  style: const TextStyle(
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
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
