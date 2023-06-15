import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../widgets/login_modal_widget.dart';

class Info extends StatefulWidget {
  Info({
    super.key,
  });
  @override
  InfoState createState() => InfoState("", "", "");
}

class InfoState extends State<Info> {
  InfoState(this.animation, this.title, this.description);

  final String animation, title, description;

  late PageController _pageController;

  int _pageIndex = 0;

  late List info = [
    [
      'assets/animations/puzzle.json',
      "Integration With Existing \nCalendar Apps",
      "Koja can be integrated with existing calendar apps. This allows you to easily import your existing events into Koja, and vice versa."
      // , such as Google Calendar, Apple Calendar, and Microsoft Outlook
    ],
    [
      'assets/animations/ai.json',
      "Artificial Intelligence\nIntegration",
      "As mentioned before our app is advanced, we use an Artificial Intelligence to dynamically allocate tasks for you based on your time boundaries, this means less effort for you!"
    ],
    [
      'assets/animations/location-map.json',
      "Traveling Time\nCalculator",
      "Based on your location and tasks, Koja will also find the travelling time between 2 locations and insert that time on your schedule. This reduces the hassle of having to calculate the traveling time manually."
    ],
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: info.length,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => Content(
                    animation: info[index][0],
                    title: info[index][1],
                    description: info[index][2],
                  ),
                  
                ),
            ),
            Row(
              children: [
                SizedBox(width: 20),
                ...List.generate(
                  info.length, 
                  (index) => DotIndicator(
                    isActive: index == _pageIndex,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500), 
                      curve: Curves.easeInOut);

                    // Show modal bottom sheet on last page
                    if(_pageIndex == info.length - 1) {
                      showModalBottomSheet(
                        showDragHandle: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        context: context,
                        builder: (context) => const LoginModal(),
                      );                     
                    }
                  }, 
                  child: Icon(
                    Bootstrap.arrow_right_circle_fill,
                    size: 50,
                    color: Colors.blue[700],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),       
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key, required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive ? 15 : 6, 
      width: isActive ? 12 : 6,
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.animation,
    required this.title,
    required this.description,
  });

  final String animation;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height) * 0.5,
          alignment: Alignment.center,
          child: Lottie.asset(
            animation,
            height: 200,
            width: 300,
            repeat: false,
          ),
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        SizedBox(height: 15),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer()
      ],
    );
  }
}