<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
import 'package:client/Utils/constants_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
<<<<<<< HEAD
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
=======
  AboutUsPageState createState() => AboutUsPageState();
}

class AboutUsPageState extends State<AboutUsPage> with SingleTickerProviderStateMixin 
{
  @override
  void initState() {
    super.initState();
  }

>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: const Text(
                'Koja',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Welcome to our Scheduler App!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Our app is designed to provide you with advanced scheduling capabilities and make your life more organized and efficient.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              '1. Integration with Google Calendar:',
              style: TextStyle(fontSize: 16.0),
            ),
            const Text(
              '   - Sync your events and schedules with Google Calendar for seamless management across platforms.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            const Text(
              '2. Dynamic Travel Calculations:',
              style: TextStyle(fontSize: 16.0),
            ),
            const Text(
              '   - Our app can calculate travel times and distances for your events, helping you plan your day efficiently.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            const Text(
              '3. Personalized Scheduling:',
              style: TextStyle(fontSize: 16.0),
            ),
            const Text(
              '   - Create customized schedules tailored to your needs and preferences.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'We hope our app simplifies your scheduling tasks and brings more order to your daily life. Happy scheduling!',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
=======
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
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> d075a8edfcf0503bd2778e6b3d7b1d8fba6186f9
