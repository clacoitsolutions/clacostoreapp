import 'package:claco_store/Page/home/Wallet_Account_Pages/Wallet_Account.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDetailsForm extends StatefulWidget {
  @override
  _AccountDetailsFormState createState() => _AccountDetailsFormState();
}

class _AccountDetailsFormState extends State<AccountDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _confirmNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();

  String? _customerId;

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
  }

  Future<void> _loadCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _customerId = prefs.getString('customerId');
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/getbankpayment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'CustomerId': _customerId ?? '', // Add the customer ID if you have it
          'Holder_Name': _accountHolderNameController.text,
          'AccountNumber': _accountNumberController.text,
          'IFSC_Number': _ifscCodeController.text,
          'Bank_Name': _bankNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        final responseData = json.decode(response.body);
        print('Response: $responseData');

        // Show success message
        Fluttertoast.showToast(
          msg: "Bank Account Linked Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // Ensures the toast is at the bottom
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Navigate to WalletAccountPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WalletAccountPage()),
        );
      } else {
        // Handle error response
        print('Error: ${response.body}');
        Fluttertoast.showToast(
          msg: "Failed to link bank account",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // Ensures the toast is at the bottom
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
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
                      'Account Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildInputField('Account Holder Name', _accountHolderNameController),
                    SizedBox(height: 10),
                    _buildInputField('Account Number', _accountNumberController),
                    SizedBox(height: 10),
                    _buildConfirmNumberField('Confirm Number', _confirmNumberController, _accountNumberController),
                    SizedBox(height: 10),
                    _buildInputField('Bank Name', _bankNameController),
                    SizedBox(height: 16),
                    _buildInputField('IFSC Code', _ifscCodeController),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                      ),
                      child: Text(
                        'Link Account',
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

  Widget _buildInputField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmNumberField(String labelText, TextEditingController controller, TextEditingController accountNumberController) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        } else if (value != accountNumberController.text) {
          return 'Account numbers do not match';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _confirmNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    super.dispose();
  }
}
