import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api services/service_api.dart';
import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_appbar.dart';
import 'home/Chekout_page.dart';
import 'package:http/http.dart' as http;

class MycardScreen extends StatelessWidget {
  const MycardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: ' My Cart '),
      body: MyCart(),
      bottomNavigationBar: CustomBottomNavigationBar(context: context),
    );
  }
}

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final APIService _cartService = APIService();
  String selectedText = '';
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
    });
  }

  Future<void> _storeSelectedProductInfo(String productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ProductId', productId);
    await prefs.setInt('Quantity', quantity);
  }

  Future<void> _updateCartQuantity(String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/updatecartsize1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'customerid': customerId!,
          'productid': productId,
          'quantity': quantity.toString(),
        }),
      );
      if (response.statusCode == 200) {
        print('Cart item quantity updated successfully:${response.body}');
        setState(() {});
      } else {
        print('Failed to update cart item quantity: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart item quantity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.08),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = 'Claco';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedText == 'Claco' ? Colors.red : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Claco',
                        style: TextStyle(
                          color: selectedText == 'Claco' ? Colors.red : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = 'Grocery';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedText == 'Grocery' ? Colors.red : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Grocery',
                        style: TextStyle(
                          color: selectedText == 'Grocery' ? Colors.red : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: customerId != null ? _cartService.fetchData(customerId!) : Future.value([]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          } else {
            final List<dynamic> data = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    child: Column(
                      children: List.generate(data.length, (index) {
                        final item = data[index];
                        int selectedQuantity = item['Quantity'] ?? 1;

                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                flex: 8,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, top: 18, right: 20),
                                            child: Container(
                                              height: 100,
                                              width: double.infinity,
                                              child: Center(
                                                child: Image.network(
                                                  item['ProductMainImageUrl'] ?? '',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Column(
                                            children: [
                                              DropdownButton<int>(
                                                value: selectedQuantity,
                                                onChanged: (int? value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      selectedQuantity = value;
                                                      _updateCartQuantity(item['ProductID'].toString(), selectedQuantity);
                                                      _storeSelectedProductInfo(item['ProductID'].toString(), selectedQuantity);
                                                    });
                                                  }
                                                },
                                                items: List.generate(
                                                  10,
                                                      (index) => DropdownMenuItem<int>(
                                                    value: index + 1,
                                                    child: Text('Qty: ${index + 1}'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10, top: 18),
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['ProductName'] ?? '',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black.withOpacity(0.6),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Size : ${item['SizeName'] ?? ''},',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item['ColorName'] ?? ''}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Icon(Icons.star, color: Colors.green, size: 18),
                                                  Icon(Icons.star, color: Colors.green, size: 18),
                                                  Icon(Icons.star, color: Colors.green, size: 18),
                                                  Icon(Icons.star, color: Colors.green, size: 18),
                                                  Icon(
                                                    Icons.star_half,
                                                    color: Colors.grey,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    " (${item['rating']})",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Text(
                                                    '0%',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 0),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '₹${item['OnlinePrice']}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Applied',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'offer',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Delivery by",
                                        style: TextStyle(
                                          color: Colors.black87.withOpacity(0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        " Today",
                                        style: TextStyle(
                                          color: Colors.black87.withOpacity(0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        "  Free",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Handle tap event
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.save_alt_sharp,
                                                  color: Colors.black45,
                                                  size: 18,
                                                ),
                                                Text(
                                                  ' Save for later',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _showDeleteConfirmationDialog(item['CartListID'].toString());
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                                left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                                right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline_sharp,
                                                  color: Colors.black45,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Handle tap event
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Checkout()),
                                          );
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.add_shopping_cart_sharp,
                                                  color: Colors.black45,
                                                  size: 18,
                                                ),
                                                Text(
                                                  'Buy this now ',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
               // Adjust spacing between cart items and the button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the checkout page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Checkout()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(String cartListId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to remove this item?'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Background color
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteItem(cartListId);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(String cartListId) {
    _cartService.removeItemFromCart(customerId!, cartListId).then((_) {
      setState(() {});
    });
  }
}
