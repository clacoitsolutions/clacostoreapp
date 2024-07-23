import 'package:claco_store/Page/home/Wallet_Account_Pages/Wallet_Account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CardForm extends StatefulWidget {
  @override
  _CardFormState createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _holderNameController = TextEditingController();
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
          'CustomerId': customerId,
          'CardNumber': _cardNumberController.text,
          'CVV': _cvvController.text,
          'ExpireDate': _expiryDateController.text,
          'HolderName': _holderNameController.text,
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
          child: Material(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.credit_card, size: 40.0),
                        Text(
                          'Any Card',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Card Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildInputField('0000 0000 0000 0000', 'Card Number', Icons.credit_card, _cardNumberController),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInputField('MM/YY', 'Expiry Date', Icons.calendar_today, _expiryDateController, width: 120),
                        _buildInputField('...', 'CVV', Icons.security, _cvvController, width: 120),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildInputField('Account holder full name', 'Account Holder Name', Icons.person, _holderNameController),
                    SizedBox(height: 20),
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
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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

  Widget _buildInputField(String placeholder, String labelText, IconData iconData, TextEditingController controller, {double width = double.infinity}) {
    return Container(
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: placeholder,
          border: OutlineInputBorder(),
          suffixIcon: Icon(iconData),
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
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _holderNameController.dispose();
    super.dispose();
  }
}
