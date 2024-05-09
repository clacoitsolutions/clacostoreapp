
import 'package:flutter/material.dart';

class PasswordResetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PasswordTextField(
              labelText: 'New Password',
            ),
            SizedBox(height: 20),
            PasswordTextField(
              labelText: 'Confirm Password',
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Add your logic to update the password
              },
              child: Text(
                'Update Password',
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String labelText;

  const PasswordTextField({Key? key, required this.labelText}) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}









