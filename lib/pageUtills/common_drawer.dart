import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences


class CommonDrawer extends StatefulWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  String? userName;
  String? userEmail;

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
              // Navigate to the Home Screen
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('My Cart'),
            onTap: () {
              // Navigate to the Cart Screen
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart'); // Assuming you have a cart route
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border_outlined),
            title: Text('My Wishlist'),
            onTap: () {
              // Navigate to the Wishlist Screen
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wishlist'); // Assuming you have a wishlist route
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Add functionality for Settings
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
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