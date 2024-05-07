import 'package:flutter/material.dart';

import '../Page/home_page.dart';
import '../Page/my_cart.dart';
import '../Page/my_profile.dart';
import '../Page/wishlist_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final BuildContext context;

  const CustomBottomNavigationBar({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            color: Colors.red,
          ),
          IconButton(
            icon: Icon(Icons.favorite_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  WishListScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MycardScreen()),
              );
            },
            iconSize: 28,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
