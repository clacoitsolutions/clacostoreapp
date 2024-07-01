import 'package:flutter/material.dart';
import '../Page/home_page.dart';
import '../Page/my_cart.dart';
import '../Page/my_profile.dart';
import '../Page/search_product.dart';
import '../Page/wishlist_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final BuildContext context;

  const CustomBottomNavigationBar({Key? key, required this.context})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      color: Colors.pink,
      elevation: 6,
      shape: const CircularNotchedRectangle(),
      notchMargin: 0,
      child: Container(

        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
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
      ),
    );
  }

  Widget _buildIconButton(IconData icon, int index) {
    return IconButton(
      onPressed: () {
        // Update the selected index
        setState(() {
          _selectedIndex = index;
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
              MaterialPageRoute(builder: (context) => MycardScreen  ()),
            );
            break;
          case 3:
            Navigator.push(
              widget.context,
              MaterialPageRoute(
                builder: (context) => SearchProduct(
                  products: [],
                  ratingProducts: [],
                  discountproducts: [],
                  categoryProducts: [],
                  sizeProducts: [],
                ),
              ),
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
      color: Colors.transparent  ,
      iconSize: 28,
      padding: EdgeInsets.all(0),
      splashRadius: 28,
      tooltip: "",
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selectedIndex == index ? Colors.white : Colors.transparent,
        ),
        child: Icon(icon, color: _selectedIndex == index ? Colors.pink : Colors.white),
      ),
    );
  }
}
