import 'package:flutter/material.dart';

import '../Page/home_page.dart';
import '../Page/my_cart.dart';
import '../Page/my_profile.dart';
import '../Page/user_signin.dart';
import '../Page/wishlist_page.dart';
import '../grocery_mainpage.dart';


class CustomBottomNavigationBar extends StatefulWidget {
  final BuildContext context;

  const CustomBottomNavigationBar({Key? key, required this.context}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  // List to maintain the selected state of each button
  List<bool> _isSelected = [true, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconButton(Icons.home_outlined, 0),
          _buildIconButton(Icons.favorite_outline, 1),
          _buildIconButton(Icons.shopping_cart_outlined, 2),
          _buildIconButton(Icons.search, 3),
          _buildIconButton(Icons.settings_outlined, 4),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, int index) {
    return IconButton(
      onPressed: () {
        // Update the selected state of each button
        setState(() {
          for (int i = 0; i < _isSelected.length; i++) {
            if (i == index) {
              _isSelected[i] = true;
            } else {
              _isSelected[i] = false;
            }
          }
        });

        // Navigate to the corresponding page based on the index
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              widget.context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            Navigator.push(
              widget.context,
              MaterialPageRoute(builder: (context) => WishListScreen()),
            );
            break;
          case 2:
            Navigator.push(
              widget.context,
              MaterialPageRoute(builder: (context) => MycardScreen()),
            );
            break;
          case 3:
            Navigator.push(
              widget.context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
            break;
          case 4:
            Navigator.push(
              widget.context,
              MaterialPageRoute(builder: (context) => MyProfileScreen()),
            );
            break;
        }
      },
      color: _isSelected[index] ? Colors.white : Colors.grey,
      iconSize: 28,
      padding: EdgeInsets.all(0), // To remove default padding
      splashRadius: 30, // Increase splash radius for better touch feedback
      tooltip: "", // Remove tooltip to avoid displaying text on long press
      splashColor: Colors.transparent, // Remove splash color
      highlightColor: Colors.transparent, // Remove highlight color
      // Use a container to change the background color dynamically
      // and ensure the icon button covers the entire area
      // This will make the entire button clickable
      icon: Container(
        padding: EdgeInsets.all(12), // Adjust padding to fit the icon
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isSelected[index] ? Colors.pink : Colors.transparent,
        ),
        child: Icon(icon, color: _isSelected[index] ? Colors.white : Colors.grey),
      ),
    );
  }
}
