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
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navigate to home page
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('My Cart'),
            onTap: () {
              // Navigate to my cart page
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('My Orders'),
            onTap: () {
              // Navigate to my orders page
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border_outlined),
            title: Text('Wishlist'),
            onTap: () {
              // Navigate to wishlist page
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Coupons'),
            onTap: () {
              // Navigate to coupons page
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Contact Us'),
            onTap: () {
              // Navigate to contact us page
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.headset_mic),
            title: Text('Customer Support'),
            onTap: () {
              // Navigate to customer support page
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          // Add more options as needed
        ],
      ),
    );
  }
}
