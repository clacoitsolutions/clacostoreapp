import 'package:flutter/material.dart';

class ContactFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Make dialog background transparent
      insetPadding: EdgeInsets.zero, // Remove inset padding
      child: Stack(
        children: [
          // Background page
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the dialog when tapping outside
              },
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          // Contact form dialog
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white, // Set background color to white
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Bahnschrift', // Use the font family name declared in pubspec.yaml
                      fontWeight: FontWeight.w600, // You can also specify the font weight if needed
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text("If you have a question about our service or have an issue to report, please send a request and we will get back to you as soon as possible"),
                  SizedBox(height: 16.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Full Name *'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Email *'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Mobile No *'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Message *'),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Add your form submission logic here
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                      ),
                      child: Text(
                        'Submit Request',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
