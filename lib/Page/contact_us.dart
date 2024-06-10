import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactFormPage extends StatefulWidget {
  @override
  _ContactFormPageState createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://clacostoreapi.onrender.com/ContactUs'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'FullNames': _fullNameController.text,
            'EmailAddresss': _emailController.text,
            'MobileNos': _mobileNoController.text,
            'Messages': _messageController.text,
          }),
        );

        final responseBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(
                responseBody['message'] ?? 'Request submitted successfully!',
                style: TextStyle(color: Colors.green),
              ),),
            );
          });
        } else {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseBody['message'] ?? '',style: TextStyle(color: Colors.green),)),
            );
          });
        }
      } catch (error) {
        print('Error: $error');
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred. Please try again later.')),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileNoController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black54,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'Bahnschrift',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text("If you have a question about our service or have an issue to report, please send a request and we will get back to you as soon as possible"),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(labelText: 'Full Name *'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email *'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _mobileNoController,
                        decoration: InputDecoration(labelText: 'Mobile No *'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Please enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(labelText: 'Message *'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your message';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30.0),
                      Center(
                        child: TextButton(
                          onPressed: _submitForm,
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
            ),
          ],
        ),
      ),
    );
  }
}
