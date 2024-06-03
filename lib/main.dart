import 'package:flutter/material.dart';
import 'Page/User/login.dart';
import 'Page/home_page.dart';
import 'Page/login.dart'; // Assuming this is your new login page
import 'Page/order_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      // Initially, use your new LoginPage
      home: LoginPage1(), // This is your new login page with OTP removed
      routes: {
        '/orderDetails': (context) => const OrderDetailsPage(),
        '/home': (context) => const HomeScreen(), // Assuming this is your home page
      },
    );
  }
}