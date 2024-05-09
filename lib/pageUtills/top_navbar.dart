import 'package:flutter/material.dart';

import '../Page/my_cart.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onPersonIconPressed;

  const HomeAppBar({
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

        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MycardScreen()),
            );
          },
          child:

             SizedBox(
              width: 80, // Set the width of the circular image
              height: 80, // Set the height of the circular image
              child: CircleAvatar(
                radius: 20, // Adjust the radius as per your requirement
                backgroundImage: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjdx6kwUFu3LgLTVh0t2t38H4-RjFPOQdPr0JunoiQRQ&s",
                ),
              ),
            ),

        ),
      ],


      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Material(
          color: Colors.black.withOpacity(0.02),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0), // Increased padding for the search icon
                    child: Icon(Icons.search, color: Colors.grey.withOpacity(0.5)),
                  ),
                  Expanded(
                    child: Center( // Wrap TextField with Center widget
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Search any products..',
                          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 8.0), // Adding padding to the bottom of the text
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.mic, color: Colors.grey.withOpacity(0.7)),
                ],
              ),
            ),
          ),
        ),
      ),



    );
  }
}


