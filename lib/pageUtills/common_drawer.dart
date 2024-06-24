import 'package:claco_store/Page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Page/my_cart.dart';
import '../Page/my_order.dart';
import '../Page/wishlist_page.dart'; // Import SharedPreferences


class CommonDrawer extends StatefulWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  String? userName;
  String? userEmail;
  String? customerId;
  String? mobileNo;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name');
      userEmail = prefs.getString('emailAddress');
      customerId = prefs.getString('customerId');
      mobileNo = prefs.getString('mobileNo');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // User Account Header
          UserAccountsDrawerHeader(
            accountName:
            Text(userName ?? 'XYZ', style: TextStyle(color: Colors.white)),
            accountEmail: Text(
                userEmail ?? 'abcd@example.com', style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName != null ? userName![0] : 'T',
                style: TextStyle(fontSize: 40.0, color: Colors.purple),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
          ),

          // Other Drawer Items
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {

              Navigator.push(
                  context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('My Cart'),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MycardScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border_outlined),
            title: Text('My Wishlist'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('My Order'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOrderScreen()),
              );
            },
          ),
          // Logout Option at the Bottom
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              // Add functionality for Logout
              Navigator.pop(context); // Close the drawer

              final prefs = await SharedPreferences.getInstance();
              prefs.clear(); // Clear all data from Shared Preferences

              // Navigate to the login page after logout
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}