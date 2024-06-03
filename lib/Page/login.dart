import 'package:flutter/material.dart';
import '../Api services/authservice.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class LoginPage1 extends StatefulWidget {
  const LoginPage1({Key? key}) : super(key: key);

  @override
  State<LoginPage1> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage1> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _message;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _message = null;
      });

      try {
        final response = await AuthService().login(
          userName: _userNameController.text,
          password: _passwordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        if (response != null && response['message'] == 'Login successful') {
          // Store data in Shared Preferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('customerId', response['data']['CustomerId']);
          prefs.setString('name', response['data']['Name']);
          prefs.setString('emailAddress', response['data']['EmailAddress']);
          prefs.setString('mobileNo', response['data']['MobileNo']);
          prefs.setInt('role', response['data']['Role']);
          prefs.setString('referCode', response['data']['ReferCode']);

          setState(() {
            _message = 'Login successful';
          });
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
        } else {
          setState(() {
            _message = response != null ? 'Login failed: ${response['message']}' : 'Login failed';
          });
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        print('Error: $error');
        setState(() {
          _message = 'An error occurred';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      _isLoading ? 'Loading...' : 'Login',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    backgroundColor: Colors.red,
                  ),
                ),
                SizedBox(height: 20),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _message!.startsWith('Login successful')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add your logic to navigate to the sign-up page
                      },
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // Add your logic to handle "Forget Password?" action
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ... (rest of the code: AuthService, HomeScreen, main.dart)