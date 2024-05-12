import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package for TextInputFormatter

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());
  bool _showSubmitButton = true; // Initially set to true
  bool _showOTPField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Welcome\nan account!',
              style: TextStyle(
                fontSize: 45.0, // Adjust font size as needed
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
            SizedBox(height: 20.0), // Add some spacing
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: 'Enter Mobile Number',
                border: OutlineInputBorder(), // Add border here
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow numbers
                LengthLimitingTextInputFormatter(10), // Limit input to 10 digits
              ],
              onChanged: (value) {
                setState(() {
                  _showSubmitButton = value.isNotEmpty;
                });
              },
            ),

            SizedBox(height: 20.0), // Add some spacing
            Visibility(
              visible: _showSubmitButton,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit action here
                  setState(() {
                    _showOTPField = true; // Show OTP input box
                    _showSubmitButton = false; // Hide submit button
                  });
                  print("Mobile Number submitted: ${_mobileController.text}");
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // Background color red
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0), // Add border radius here
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0), // Add some spacing
            Visibility(
              visible: _showOTPField,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                          (index) => SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _otpControllers[index],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(1),
                          ],
                          onChanged: (value) {
                            if (value.length == 1 && index < 5) {
                              FocusScope.of(context).nextFocus(); // Move focus to the next TextField
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus(); // Move focus to the previous TextField
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0), // Add some spacing
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle OTP verification here
                        print("OTP submitted: ${_otpControllers.map((controller) => controller.text).join()}"); // Combine OTP values from all controllers

                        setState(() {
                          _showSubmitButton = true; // Show the submit button again
                          _showOTPField = false; // Hide the OTP input fields
                        });
                      },
                      child: Text(
                        'Verify',
                        style: TextStyle(color: Colors.white), // Text color white
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color green
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // Add border radius here
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


