import 'package:koja/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class UserManualPage extends StatefulWidget {
  const UserManualPage({super.key});

  @override
  UserManualPageState createState() => UserManualPageState();
}

class UserManualPageState extends State<UserManualPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 74, 45, 133),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 74, 45, 133),
        title: const Text(
          "User Manual",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: PDF(
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: false,
          pageSnap: true,
          defaultPage: 0,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          nightMode: false,
          onPageError: (page, error) { 
          },
        ).fromAsset("assets/pdf/user_manual.pdf"),
      ),
    );
  }
}
