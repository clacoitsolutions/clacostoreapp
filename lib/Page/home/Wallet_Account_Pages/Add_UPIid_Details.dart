import 'package:claco_store/Page/home/Wallet_Account_Pages/Wallet_Account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UPIIDForm extends StatefulWidget {
  @override
  _UPIIDFormState createState() => _UPIIDFormState();
}

class _UPIIDFormState extends State<UPIIDForm> {
  final _formKey = GlobalKey<FormState>();
  final _holderNameController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  String? customerId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString('customerId');
    });
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/cardapi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'UPI_ID': _upiIdController.text,
          'Mobile_Number': _mobileNumberController.text,
          'AccountName': _holderNameController.text,
          'CustomerId': customerId,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        final responseData = json.decode(response.body);
        print('Response: $responseData');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Card details submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WalletAccountPage()),
        );
        // Optionally navigate to another page or reset the form
      } else {
        // Handle error response
        print('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit card details'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'UPI ID Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildInputField('Full Name', 'Holder Name', _holderNameController),
                    SizedBox(height: 10),
                    _buildInputField('example@upi', 'UPI ID', _upiIdController),
                    SizedBox(height: 10),
                    _buildInputField('1234567890', 'Mobile Number', _mobileNumberController),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10), // Padding around the button content
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String placeholder, String labelText, TextEditingController controller, {double width = double.infinity}) {
    return Container(
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: placeholder,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _holderNameController.dispose();
    _upiIdController.dispose();
    _mobileNumberController.dispose();

    super.dispose();
  }
}
