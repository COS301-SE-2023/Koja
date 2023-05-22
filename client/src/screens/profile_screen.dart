import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//widgets
import '../widgets/time_picker_widget.dart';
import 'login_screen.dart';
import 'navigation_management_screen.dart';
import '../widgets/user_details_widget.dart';
import '../widgets/settings_widget.dart';
import 'event_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

//page import

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Userdetails(),
            Divider(
              thickness: 0,
            ),
            Settings(),
          ],
        ),
      ),
    );
  }
}