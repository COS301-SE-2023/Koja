import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';
import '../screens/login_screen.dart';

class Userdetails extends StatelessWidget {
  
  String profile = "", email = "";

  Userdetails(String profile, String email)
  {
    this.profile = profile;
    this.email = email;
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      padding: EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    // side: const BorderSide(width: 1, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Icon(
                    Icons.logout_outlined,
                    size: 30,
                    color:Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ClipOval(
                  //This is the profile picture
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/icons/coffee.png',         
                    ),
                  ),
                ),
                //This is the name of the user
                Text(
                  email,
                  style: const TextStyle(
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
