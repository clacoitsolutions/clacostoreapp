import 'package:claco_store/pageUtills/splashScreen.dart';
import 'package:flutter/material.dart';
import 'Page/User/create_account.dart';
import 'Page/contact_us.dart';
import 'Page/firebase_connection_test.dart';
import 'Page/home/banner.dart';
import 'Page/home/slider.dart';
import 'Page/home_page.dart';
import 'Page/my_cart.dart';
import 'Page/order_details.dart';
import 'Page/user_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Page/wishlist_page.dart';
import 'firebase_options.dart'; // Make sure to import this
import 'Page/order_summary_page.dart';
import 'Page/OrderSuccesful_page.dart';
import 'Page/filter_page.dart';
import 'Page/search_product.dart';
import 'pageUtills/update_user_profile.dart';
import 'Page/onboarding_page.dart';
import 'pageUtills/onboardingScreen.dart';
import 'pageUtills/refer_earn.dart';




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
      home:SplashScreen(), // This is your new login page with OTP removed
      routes: {
        '/orderDetails': (context) => const OrderDetailsPage(),
        '/home': (context) => const HomeScreen(), // Assuming this is your home page
      },
    );
  }
}