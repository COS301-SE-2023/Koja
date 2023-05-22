import 'package:flutter/material.dart';

import '../Utils/constants_util.dart';
import '../widgets/user_details_widget.dart';
import '../widgets/settings_widget.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: darkBlue,
        centerTitle: true,
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Userdetails(),
            const Divider(
              thickness: 0,
              color: Colors.white,
              height: 40,
            ),
            Settings(),
          ],
        ),
      ),
    );
  }
}
