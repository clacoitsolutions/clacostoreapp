import 'package:flutter/material.dart';
import 'main_page.dart'; // Import your main page here

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle( color: Colors.white),
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

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void signIn() {
    // Implement your sign-in logic here
    // For simplicity, let's assume signing in is successful
    // Replace this with your actual sign-in logic
    bool isSignInSuccessful = true;

    if (isSignInSuccessful) {
      // Navigate to the main page upon successful sign-in
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => MainPage()), // Provide the Route object
      // );
    } else {
      // Handle sign-in failure (e.g., display error message)
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
              onPressed: signIn,
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
                  'Sign In',
                  style: TextStyle(color: Colors.white),
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
                  Text(
                    'Create An Account?',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Add your click event here
                    },
                    child: Text(
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

