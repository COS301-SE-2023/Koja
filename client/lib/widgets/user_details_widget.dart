import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';

class UserDetails extends StatelessWidget {
  final String profile, email;

  UserDetails({required this.profile, required this.email});

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
