// lib/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:claco_store/Api services/service_api.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  String _registrationMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on app start
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getString('customerId');

    if (customerId != null) {
      // User is already logged in
      Navigator.pushReplacementNamed(context, '/home');
    }
  }


  Future<void> register() async {
    var data = {
      'Name': _nameController.text,
      'MobileNo': _phoneNumberController.text,
      'ReferCode': _referralCodeController.text,
      'Email': _emailController.text,
      'Password': _passwordController.text,
    };

    APIService apiService = APIService();
    var responseData = await apiService.register(data);

    // if (responseData['message'] != null && responseData['message'].contains('Successful')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Store data in SharedPreferences with the same parameter names
      prefs.setString('customerId', responseData['data'][0]['customerid']);
      prefs.setString('name', responseData['data'][0]['name']);
      prefs.setString('mobileNo', responseData['data'][0]['MobileNumber']);
      prefs.setString('ReferCode', responseData['data'][0]['CardId']);
      prefs.setString('emailAddress', _emailController.text);
      prefs.setString('Password', responseData['data'][0]['Password']);


    // Split and store first name and last name
   // saveNameToPreferences(responseData['data'][0]['name']);

      setState(() {
        _registrationMessage = responseData['message'] ?? 'Registration Successful!';
      });

    void saveNameToPreferences(String fullName) async {
      final prefs = await SharedPreferences.getInstance();
      List<String> nameParts = fullName.split(' ');
      String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await prefs.setString('firstName', firstName);
      await prefs.setString('lastName', lastName);
    }


    // Delay the navigation for a second to show the message
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
    // } else {
    //   setState(() {
    //     _registrationMessage = responseData['message'] ?? 'Registration Failed. Please try again.';
    //   });
    // }

    print(responseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-commerce Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create an',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Account',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        filled: true,
                        fillColor: Color.fromRGBO(243, 243, 243, 1),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(243, 243, 243, 1),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(243, 243, 243, 1),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _referralCodeController,
                  decoration: InputDecoration(
                    labelText: 'Referral Code',
                    hintText: 'Enter your referral code',
                    prefixIcon: Icon(Icons.code),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(243, 243, 243, 1),
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: _showPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(243, 243, 243, 1),
                  ),
                  obscureText: !_showPassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: _showPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(243, 243, 243, 1),
                  ),
                  obscureText: !_showPassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    minimumSize: Size(double.infinity, 55),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                if (_registrationMessage.isNotEmpty)
                  Text(
                    _registrationMessage,
                    style: TextStyle(
                      color: _registrationMessage.contains('Successful') ? Colors.green : Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}