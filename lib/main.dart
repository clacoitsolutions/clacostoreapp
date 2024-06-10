import 'package:claco_store/pageUtills/splashScreen.dart';
import 'package:flutter/material.dart';
import 'Page/User/create_account.dart';
import 'Page/contact_us.dart';
import 'Page/firebase_connection_test.dart';
import 'Page/home/banner.dart';
import 'Page/home/slider.dart';
import 'Page/home_page.dart';
import 'Page/order_details.dart';
import 'Page/user_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Make sure to import this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      // Initially, use your new LoginPage
      home: ContactFormPage(), // This is your new login page with OTP removed
      routes: {
        '/orderDetails': (context) => const OrderDetailsPage(),
        '/home': (context) => const HomeScreen(), // Assuming this is your home page
      },
    );
  }
}