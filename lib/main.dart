import 'package:claco_store/pageUtills/get_started.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'Page/home_page.dart';
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
      home:HomeScreen(),
      routes: {
        '/orderDetails': (context) => OrderDetailsPage(),
      },
    );
  }
}

// import 'package:flutter/material.dart';
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fragment Navigation',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: Center(
//         child: Text('Home Page'),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(),
//     );
//   }
// }
//
// class Page1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: Center(
//         child: Text('Page 1'),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(),
//     );
//   }
// }
//
// class Page2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: Center(
//         child: Text('Page 2'),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(),
//     );
//   }
// }
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text('My App'),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {
//             // Navigate to search screen
//             Navigator.pushNamed(context, '/search');
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }
//
// class CustomBottomNavigationBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.pageview),
//           label: 'Page 1',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.pageview),
//           label: 'Page 2',
//         ),
//       ],
//       currentIndex: 0,
//       selectedItemColor: Colors.blue,
//       onTap: (index) {
//         // Navigate to the selected page
//         switch (index) {
//           case 0:
//             Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
//             break;
//           case 1:
//             Navigator.push(context, MaterialPageRoute(builder: (_) => Page1()));
//             break;
//           case 2:
//             Navigator.push(context, MaterialPageRoute(builder: (_) => Page2()));
//             break;
//         }
//       },
//     );
//   }
// }
