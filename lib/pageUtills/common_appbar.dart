import 'package:flutter/material.dart';

import '../Page/my_cart.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPersonIconPressed;

  const CommonAppBar({
    required this.title,
    this.onPersonIconPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(80); // Increased the height of the app bar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink, // Set background color to pink
      iconTheme: IconThemeData(color: Colors.white), // Set the color of the three-line toggle icon
      elevation: 0, // Removed the elevation to make it flat
      title: Row(
        children: [
          // Image.asset(
          //   'assets/logo.png', // Replace 'assets/logo.png' with your logo image path
          //   height: 30, // Set the height of the image
          //   width: 30, // Set the width of the image
          //   color: Colors.white, // Set the color of the image
          // ),
          SizedBox(width: 10), // Added SizedBox for spacing
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18, // Adjusted the font size
            ),
          ),
        ],
      ),
      actions: [

        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white, // Set the color of the icon to white
          ),
          onPressed: () {
            Navigator.push(
              context, // Ensure context is available
              MaterialPageRoute(builder: (context) => mycart()), // Corrected mycart to MyCart
            );
          },
        ),

      ],

    );
  }
}
