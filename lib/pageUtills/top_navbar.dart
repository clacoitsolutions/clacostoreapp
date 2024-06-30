import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Page/home/Chekout_page.dart';
import '../Page/home/Grocery_vegitable_home_page.dart';
import '../Page/home/grocery_home_page.dart';
import '../Page/home_page.dart';
import '../Page/my_cart.dart';
import '../Page/search_product.dart'; // Import the SearchProduct page

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onPersonIconPressed;

  const HomeAppBar({
    this.onPersonIconPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(90); // Increased the height of the app bar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink, // Set background color to pink
      elevation: 0, // Removed the elevation to make it flat
      automaticallyImplyLeading: false, //
      title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the correct page
                  );
                },
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the correct page
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 2),
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Image.asset(

                    'assets/images/Clacologo.png', // Replace with your image path
                    width: 50, // Adjust the width according to your needs
                    height: 50, // Adjust the height according to your needs
                  ),
                ),
              ),
            ),

            SizedBox(width: 10,),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroceryHome()), // Replace with the correct page
                  );
                },
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroceryHome()), // Replace with the correct page
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 2),
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Grocery',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          ]
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Material(
          color: Colors.black.withOpacity(0.02),
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10,bottom: 5),
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
                    child: Center(
                      // Wrap TextField with Center widget
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