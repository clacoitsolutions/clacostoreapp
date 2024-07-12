import 'package:flutter/material.dart';
import '../Api services/authservice.dart'; // Import your AuthService here
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart'; // Import your main page here

class LoginPage1  extends StatelessWidget {
  const LoginPage1 ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink, // Set background color to pink
        iconTheme: IconThemeData(color: Colors.white), // Set default back arrow icon color to white
      ),
      body: SignInForm(), // Display the sign-in form
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _message;

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final response = await AuthService().login(
        userName: emailController.text,
        password: passwordController.text,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap your Column with SingleChildScrollView
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Back! ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
            ),
            SizedBox(height: 25.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Mobile No.',
                prefixIcon: Icon(Icons.person),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
            ),
            SizedBox(height: 25.0),
            TextFormField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Add click event here
                  },
                  child: Text(
                    'Login with OTP',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Add click event here
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: _isLoading ? null : signIn,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  _isLoading ? 'Loading...' : 'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
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
            SizedBox(height: 30.0),
            Center(
              child: Text('-OR-', style: TextStyle(color: Colors.grey)),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create An Account?',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Add your click event here
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.pink,
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
