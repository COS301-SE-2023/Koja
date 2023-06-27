import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  AboutUsPageState createState() => AboutUsPageState();
}

class AboutUsPageState extends State<AboutUsPage> with SingleTickerProviderStateMixin 
{
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0, // Adjust the width of the underline
                      ),
                    ),
                  ),
                  child: Text(
                    'KOJA',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Raleway', // Replace with your desired font family
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2.0),
              Container(
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/animations/welcome.json',
                  height: 200, width: 300
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.95,
                child: const Text(
                 'Welcome to our Scheduler App!',
                 style: TextStyle(
                   fontSize: 20.0,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                   fontFamily: 'Raleway', 
                 ),
                 textAlign: TextAlign.center,
                    ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 1.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.95,
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'Our app is designed to provide you with advanced scheduling capabilities and make your life more organized and efficient.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: 'Raleway', 
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              /* Key Features */
              SizedBox(
                width: MediaQuery.of(context).size.width*0.95,
                child: const Text(
                  'Key Features:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Raleway', 
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 1.0,
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      '1. Integration with Google Calendar',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontFamily: 'Raleway', 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      // borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      'Sync your events from Google Calendar for a unified and seamless scheduling experience within the app.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontFamily: 'Raleway', 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      '2. Manual & Dynamic Event Creation',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontFamily: 'Raleway', 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      // borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      'You can create your events manually and our app will also help you by creating tasks for you dynamically based on your time boundaries.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontFamily: 'Raleway', 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      '3. Task Prioritization',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontFamily: 'Raleway', 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      // borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      'You can prioritize your tasks based on their importance and urgency and our app will schedule them accordingly.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontFamily: 'Raleway', 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}