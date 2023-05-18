// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

//widgets
import '../../widgets/profile/userdetails.dart';
import '../../widgets/profile/settings.dart';

//page import


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'), 
        backgroundColor: Color.fromARGB(255, 135, 18, 194),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Userdetails(),
          Settings(),

        ],
      ),

    );
    //calling the home page
    // return Home();
  }
  
}

