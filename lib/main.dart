import 'package:claco_store/pageUtills/login_with_otp.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'Page/test_api.dart';
import 'Page/home_page.dart';
import 'Page/login.dart';
import 'Page/order_details.dart';
import 'Page/user_signin.dart';

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
      home:LoginScreen (),
      routes: {
        '/orderDetails': (context) => const OrderDetailsPage(),
      },
    );
  }
}