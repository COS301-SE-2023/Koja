import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';

class UserDetails extends StatelessWidget {
  final String profile;
  final String email;

  UserDetails({required this.profile, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      padding: EdgeInsets.all(15),
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
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 ClipOval(
                  //This is the profile picture
                  child: CircleAvatar(
                    radius: 50,
                    child: Center(
                      child: Text(
                        profile.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 70,
                          color: darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
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
