

import 'package:claco_store/pageUtills/splashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Page/firebase_connection_test.dart';
import 'firebase_options.dart';
import 'Page/home_page.dart';
import 'Page/order_details.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
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
      home: SplashScreen(),
      routes: {
        '/orderDetails': (context) => OrderDetailsScreen(),
        '/home': (context) =>
            const HomeScreen(), // Assuming this is your home page
      },
    );
  }
}
