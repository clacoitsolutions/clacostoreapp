import 'package:flutter/material.dart';
import 'dart:async';

import '../main.dart';
import 'onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SplashScreens()), // Replace with your next screen
      );
    });
  }

  // void _navigateAfterDelay() {
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => widget.nextScreen),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink, // Set background color to pink
        child: Center(
          child: Text(
            'Claco',
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
