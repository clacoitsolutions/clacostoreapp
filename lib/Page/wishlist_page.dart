import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api services/Wishlist_API.dart';
import '../models/wishlist_model.dart'; // Adjust path as per your project structure
import '../pageUtills/bottom_navbar.dart'; // Adjust path as per your project structure
import '../pageUtills/common_appbar.dart'; // Adjust path as per your project structure

class WishListScreen extends StatelessWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'WishList'),
    );
  }
}

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<WishList> wishList = [];
  String message = '';
  String? userName;
  String? userEmail;
  String? customerId;
  String? mobileNo;

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
      customerId = prefs.getString('customerId');
      mobileNo = prefs.getString('mobileNo');

      if (customerId != null) {
        _loadUserDataApi();
      } else {
        message = 'Please login to view your wishlist';
      }
    });
  }

  Future<void> _loadUserDataApi() async {
    print("Loading user data...");
    try {
      List<WishList> data =
          await WishlistService.loadWishlistData('ayush@gmail.com');
      setState(() {
        wishList = data;
        if (wishList.isEmpty) {
          message = 'No items found in your wishlist.';
        } else {
          message = '';
        }
      });

      print("Data loaded successfully");
      print("Number of items: ${wishList.length}");
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        message =
            'Error occurred while loading wishlist. Please check your internet connection.';
      });
    }
  }

  Future<void> _removeItemFromWishlist(String productId) async {
    try {
      String apiMessage =
          await WishlistService.removeItemFromWishlist(customerId!, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(apiMessage),
      ));
      _loadUserData(); // Reload wishlist after deletion
    } catch (e) {
      print('Error occurred: $e');
      var errorMessage =
          'Error occurred while removing item from wishlist. Please check your internet connection.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _addToCart(String productId) async {
    try {
      String apiMessage =
          await WishlistService.addToCart(customerId!, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(apiMessage),
      ));
    } catch (e) {
      print('Error occurred: $e');
      var errorMessage =
          'Error occurred while adding item to cart. Please check your internet connection.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
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
      return Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        itemCount: (wishList.length / 2).ceil(),
        itemBuilder: (context, index) {
          final int startIndex = index * 2;
          final int endIndex = startIndex + 1;

          return Row(
            children: [
              Expanded(
                child: startIndex < wishList.length
                    ? wishlistitem(wishList[startIndex])
                    : SizedBox.shrink(),
              ),
              SizedBox(width: 0),
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
              offset: Offset(0, 2),
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
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: Image.network(
                      wishListItem.ProductMainImageUrl ?? '',
                      height: 100,
                      width: double.infinity,
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
                    '₹${wishListItem.RegularPrice.toString()}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      _addToCart(wishListItem.productId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.pink),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      child: const Center(
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
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
          content:
              Text('Are you sure you want to remove this item from wishlist?'),
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
