import 'package:flutter/material.dart';

import 'settings_list_widget.dart';

class Settings extends StatelessWidget {
  Widget spacer = const SizedBox(width: 30, height: 8);
  Widget inline = const SizedBox(width: 10);
  Widget forwardarrow = const SizedBox(width: 60);

  Settings({super.key});
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          settingslist(),            
        ],
      ),
    );
  }
}
