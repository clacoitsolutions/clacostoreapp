import 'package:claco_store/Page/home/Grocery_vegitable_home_page.dart';
import 'package:claco_store/pageUtills/bottom_navbar.dart';
import 'package:claco_store/pageUtills/splashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'Page/order_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String initialOrderId =
      prefs.getString('orderId') ?? ''; // Default value if not found
  runApp(MyApp(initialOrderId: initialOrderId));
}

class MyApp extends StatelessWidget {
  final String initialOrderId;

  const MyApp({Key? key, required this.initialOrderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Now starts with SplashScreen
      routes: {
        '/orderDetails': (context) =>
            OrderDetailsScreen(orderId: initialOrderId),
        '/home': (context) => const BottomPage(),
      },
    );
  }
}
