import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Page/onboarding_page.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(), // Make container fill the entire screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/getstart1.jpg"), // Replace with your image path
            fit: BoxFit.cover, // Cover the whole screen
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You want\nAuthentic, here\nYou go!', // Modify the text with line breaks
              textAlign: TextAlign.center, // Align text to the center
              style: TextStyle(
                fontSize: 54.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Finf it hare ,buy it now! ', // Modify the text with line breaks
              textAlign: TextAlign.center, // Align text to the center
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0), // Add some space between the text and the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Set button background color to red
                minimumSize: MaterialStateProperty.all<Size>(Size(200, 60)), // Set minimum button size
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0), // Add padding to the button
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 40.0, // Set button text size
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}