import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/wishlist_model.dart'; // Adjust path as per your project structure
import '../pageUtills/bottom_navbar.dart'; // Adjust path as per your project structure
import '../pageUtills/common_appbar.dart'; // Adjust path as per your project structure

class WishListScreen extends StatelessWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'WishList'),
      body: WishlistPage(),
      bottomNavigationBar: CustomBottomNavigationBar(context: context),
    );
  }
}

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<WishList> wishList = [];
  String customerId = 'ayush@gmail.com'; // Default customerId, can be updated from SharedPreferences
  String message = ''; // Message to display based on API response

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print("Loading user data...");
    final prefs = await SharedPreferences.getInstance();
    customerId = prefs.getString('CustomerId') ?? 'ayush@gmail.com';

    try {
      var response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/wishlist'),
        body: jsonEncode({'CustomerId': customerId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("Response data: $responseData");

        setState(() {
          wishList = List<WishList>.from(
            responseData['data'].map((item) => WishList.fromJson(item)),
          );
          if (wishList.isEmpty) {
            message = 'No items found in your wishlist.';
          } else {
            message = '';
          }
        });

        print("Data loaded successfully");
        print("Number of items: ${wishList.length}");
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          message = 'Failed to load wishlist. Please try again later.';
        });
        // Handle error, e.g., show error message to the user
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        message = 'Error occurred while loading wishlist. Please check your internet connection.';
      });
      // Handle error, e.g., show error message to the user
    }
  }

  Future<void> _removeItemFromWishlist(String productId) async {
    final url = Uri.parse('https://clacostoreapi.onrender.com/DeleteWishlist');
    try {
      final response = await http.delete(
        url,
        body: jsonEncode({
          'EntryBy': customerId,
          'ProductId': productId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Item removed from wishlist. Response: $responseData');

        // Assuming the API returns a message in the response
        var apiMessage = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(apiMessage),
        ));

        _loadUserData(); // Reload wishlist after deletion
      } else {
        print('Failed to remove item from wishlist. Status code: ${response.statusCode}');
        var errorMessage = 'Failed to remove item from wishlist. Status code: ${response.statusCode}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ));
        // Handle error, e.g., show error message to the user
      }
    } catch (e) {
      print('Error occurred: $e');
      var errorMessage = 'Error occurred while removing item from wishlist. Please check your internet connection.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      // Handle error, e.g., show error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.08),
      body: _buildWishlist(),
    );
  }

  Widget _buildWishlist() {
    if (wishList.isEmpty && message.isNotEmpty) {
      // Display message if wishlist is empty or there was an error
      return Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        itemCount: (wishList.length / 2).ceil(), // Calculate number of rows needed
        itemBuilder: (context, index) {
          // Calculate indices for the current row
          final int startIndex = index * 2;
          final int endIndex = startIndex + 1;

          return Row(
            children: [
              Expanded(
                child: startIndex < wishList.length
                    ? wishlistitem(wishList[startIndex])
                    : SizedBox.shrink(),
              ),
              SizedBox(width: 10), // Adjust spacing between items as needed
              Expanded(
                child: endIndex < wishList.length
                    ? wishlistitem(wishList[endIndex])
                    : SizedBox.shrink(),
              ),
            ],
          );
        },
      );
    }
  }

  Widget wishlistitem(WishList wishListItem) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: Image.network(
                      wishListItem.ProductMainImageUrl ?? '',
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _showDeleteConfirmationDialog(wishListItem.productId);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wishListItem.ProductName ?? 'ProductName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '₹${wishListItem.RegularPrice}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(
                        Icons.star_half,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Text(
                        "2,55,999",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      // Add to Cart logic
                    },
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: Text('Confirmation'),
    content: Text('Are you sure you want to remove this item from wishlist?'),
    actions: <Widget>[
          TextButton(
          onPressed: () {
        Navigator.of(context).pop();
      },
          child: Text('Cancel'),
          ),
          TextButton(
          onPressed: () {
          Navigator.of(context).pop();
          _removeItemFromWishlist(productId);
          },
          child: Text('Yes'),
          ),
          ],
          );
        },
    );
  }
}

