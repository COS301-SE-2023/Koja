import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
      ),
    );
  }
}
