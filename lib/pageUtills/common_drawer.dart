import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('XYZ', style: TextStyle(color: Colors.white)),
            accountEmail: Text('abcd@example.com', style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'T',
                style: TextStyle(fontSize: 40.0, color: Colors.purple),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
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
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Add functionality for Logout
              Navigator.pop(context); // Close the drawer
              // Add your logout logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border_outlined),
            title: Text('My Wishlist'),
            onTap: () {
              // Add functionality for Logout
              Navigator.pop(context); // Close the drawer
              // Add your logout logic here
            },
          ),
        ],
      ),
    );
  }
}
