import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Api services/Add_address_api.dart';
import '../addressscreen.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Checkout'),
      body: MyCart(),
    );
  }
}

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  int _counter = 1;
  bool _isSelected1 = false;
  bool _isSelected2 = false;
  String _name = '';
  String _address = '';
  String _pinCode = '';
  String _mobileNo = '';
  String _state = '';
  String _city = '';
  List<dynamic> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchAddressData();
    _fetchCartItems();
  }

  Future<void> _fetchAddressData() async {
    // Simulating fetching address data from API
    final addressData = await ApiService.fetchAddressData("CUST000394");
    if (addressData != null) {
      setState(() {
        _name = addressData['Name'];
        _address = addressData['Address'];
        _pinCode = addressData['PinCode'];
        _mobileNo = addressData['MobileNo'];
        _state = addressData['State_name'];
        _city = addressData['CityName'];
      });
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/addToCart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'CustomerId': 'CUST000394',
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _cartItems = responseData['data'];
        });
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      // Handle error
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) _counter--;
    });
  }

  void _toggleSelection(int boxNumber) {
    setState(() {
      if (boxNumber == 1) {
        _isSelected1 = true;
        _isSelected2 = false;
      } else {
        _isSelected1 = false;
        _isSelected2 = true;
      }
    });
  }

  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
          child: Row(
            children: [
              // Image Container (20% width)
              Expanded(
                flex: 3,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.all(8),
                  child: Image.network(
                    _cartItems[index]['ProductMainImageUrl'],
                    fit: BoxFit.cover,
                    height: 60,
                  ),
                ),
              ),
              // Text Container (80% width)
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cartItems[index]['ProductName'],
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹ ${_cartItems[index]['OnlinePrice'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.pink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _decrementCounter,
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                splashRadius: 20,
                                iconSize: 24,
                                icon: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 0.2),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Icon(Icons.remove, color: Colors.grey),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 0.2),
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFF5F4F4FF),
                                ),
                                child: Text(
                                  '$_counter',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _incrementCounter,
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                splashRadius: 20,
                                iconSize: 24,
                                icon: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 0.2),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Icon(Icons.add, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummarySection() {
    return Container(
      height: 170,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items (${_cartItems.length})', style: TextStyle(color: Colors.grey)),
                Text('₹1500.0'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping', style: TextStyle(color: Colors.grey)),
                Text('₹40.0'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Import charge', style: TextStyle(color: Colors.grey)),
                Text('₹40.0'),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade200),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price', style: TextStyle(fontWeight: FontWeight.w700)),
                Text('₹1580.00', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSelection() {
    return Container(
      height: 85,
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
        Row(
        children: [
        GestureDetector(
        onTap: () {
      _toggleSelection(1);
      },
        child: Container(
          width: 17,
          height: 17,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _isSelected1 ? Colors.pink : Colors.grey,
              width: 2.0,
            ),
            color: _isSelected1 ? Colors.pink : Colors.transparent,
          ),
        ),
      ),
      SizedBox(width: 5),
      Text('Cash On Delivery'),
      ],
    ),
    SizedBox(height: 10),
    Row(
    children: [
    GestureDetector(
    onTap: () {
    _toggleSelection(2);
    },
    child: Container(
    width: 17,
    height: 17,
    decoration: BoxDecoration(
    shape: BoxShape.circle,

    border: Border.all(
    color: _isSelected2 ? Colors.pink : Colors.grey,
    width: 2.0,
    ),
    color: _isSelected2 ? Colors.pink : Colors.transparent,
    ),
    ),
    ),
    SizedBox(width: 5),
    Text('Other'),
    ],
    ),
    ],
    ),
    ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Implement logic to handle continue button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          'Continue',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.08),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Shipping address',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(top: 10, left: 15, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _name,
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle button press
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddAddressPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.pink, width: 1),
                                ),
                              ),
                              child: Text(
                                'Change',
                                style: TextStyle(fontSize: 14, color: Colors.pink),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _address,
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '$_pinCode , ',
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Text(
                        '$_city ,',
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Text(
                        _state,
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            _buildCartItems(),
            SizedBox(height: 8),
            Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 1),
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 15,
                    right: 60,
                    bottom: 0,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Coupon Code',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    width: 60,
                    height: 48,
                    child: Container(
                      color: Colors.pink,
                      child: const Center(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            _buildSummarySection(),
            SizedBox(height: 20),
            _buildPaymentSelection(),
            SizedBox(height: 10),
            _buildContinueButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}



void main() {
  runApp(MaterialApp(
    home: Checkout(),
  ));
}

