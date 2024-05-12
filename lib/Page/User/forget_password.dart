import 'package:flutter/material.dart';

import '../../pageUtills/forget_update_password.dart';

class ForgotPasswordPage extends StatelessWidget {
  void forgotPassword(BuildContext context) {
    // Navigate to the password reset page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordResetPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''), // Empty string to remove the title text
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Forgot  ',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Password ?',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your mobile number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter OTP', // Added text field for OTP
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We will send you a message to reset your password',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.5, // Line height 1.5 times the font size
                  ),
                ),
                SizedBox(height: 45),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Call the forgotPassword function
                      forgotPassword(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20), // Adjust vertical padding here
                      child: Text(
                        'Forgot Password',
                        textAlign: TextAlign.center, // Align text in the center
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button background color
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ], // Close the Column widget here
            ),
          ],
        ),
      ),
    );
  }
}

























