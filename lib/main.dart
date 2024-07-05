import 'package:claco_store/pageUtills/splashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String initialOrderId = prefs.getString('orderId') ??
      'ORD101001128'; // Default value if not found
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
      // Initially, use your new LoginPage
      home: SplashScreen(),
      routes: {
        '/orderDetails': (context) => OrderDetailsScreen(
            orderId: ModalRoute.of(context)!.settings.arguments as String),
        '/home': (context) =>
            const HomeScreen(), // Assuming this is your home page
      },
    );
  }
}
