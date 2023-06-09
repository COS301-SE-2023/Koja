import 'package:client/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/constants_util.dart';
import '../providers/event_provider.dart';
import '../widgets/user_details_widget.dart';
import '../widgets/settings_widget.dart';
import './login_screen.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: darkBlue,
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.logout),
            onPressed: () {
              serviceProvider.setAccessToken(
                null,
                eventProvider,
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}
