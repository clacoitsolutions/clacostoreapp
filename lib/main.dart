import 'package:claco_store/Page/Category_Page.dart';
import 'package:claco_store/Page/login.dart';
import 'package:claco_store/Page/my_profile.dart';
import 'package:claco_store/pageUtills/add_address_form.dart';
import 'package:claco_store/pageUtills/splashScreen.dart';
import 'package:flutter/material.dart';
import 'Page/demo.dart';
import 'Page/home/Chekout_page.dart';

import 'Page/home/Grocery_vegitable_home_page.dart';
import 'Page/home_page.dart';
import 'Page/order_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Make sure to import this
import 'Page/order_summary_page.dart';
import 'Page/OrderSuccesful_page.dart';
import 'Page/filter_page.dart';
import 'Page/search_product.dart';
import 'pageUtills/update_user_profile.dart';
import 'Page/onboarding_page.dart';
import 'pageUtills/onboardingScreen.dart';
import 'pageUtills/refer_earn.dart';
import 'Page/coin_page.dart';

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
        primarySwatch: Colors.yellow,
      ),
      debugShowCheckedModeBanner: false,
      // Initially, use your new LoginPage
      home:  SplashScreen(),
      routes: {
        '/orderDetails': (context) => OrderDetailsScreen(),
        '/home': (context) =>
            const HomeScreen(), // Assuming this is your home page
      },
    );
  }
}
