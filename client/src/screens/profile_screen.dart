import 'package:flutter/material.dart';

//widgets
import 'navigation_management_screen.dart';
import '../widgets/user_details_widget.dart';
import '../widgets/settings_widget.dart';

//page import

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Userdetails(),
            const Divider(
              thickness: 0,
            ),
            Settings(),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationScreen(),
    );
  }
}
