import 'package:flutter/material.dart';
<<<<<<< HEAD

import '../Utils/constants_util.dart';
import '../widgets/user_details_widget.dart';
import '../widgets/settings_widget.dart';
=======
import 'package:provider/provider.dart';

import '../Utils/constants_util.dart';
import '../providers/event_provider.dart';
import '../widgets/user_details_widget.dart';
import '../widgets/settings_widget.dart';
import './login_screen.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({super.key});
<<<<<<< HEAD
  

  @override
  Widget build(BuildContext context) {
=======

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: darkBlue,
        centerTitle: true,
<<<<<<< HEAD
        
=======
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.logout),
            onPressed: () {
              eventProvider.setAccessToken(accessToken: null);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
<<<<<<< HEAD
            Userdetails(),
            const Divider(
              thickness: 0,
              color: Colors.white,
              height: 40,
            ),
            Settings(),
=======
            UserDetails(
                profile: "assets/icons/coffee.png",
                email: "u19012366@tuks.co.za"),
            const Divider(
              thickness: 0,
              height: 40,
            ),
            const Settings(),
            SizedBox(
              height: 2,
            ),
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
          ],
        ),
      ),
    );
  }
}
