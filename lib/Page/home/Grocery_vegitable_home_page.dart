import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/Grocery_api.dart';
import '../home_page.dart';
import 'Chekout_page.dart';
import 'Vegitable_Fruit.dart';
import 'grocery_home_page.dart';
import 'package:claco_store/pageUtills/top_navbar.dart';

class GroceryHome extends StatefulWidget {
  @override
  State<GroceryHome> createState() => _GroceryHomeState();
}

class _GroceryHomeState extends State<GroceryHome> {
  String selectedButton = 'home'; // Default to 'home'
  List<dynamic> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _refreshCartModal() {
    setState(() {}); // This empty setState will trigger a rebuild of the modal
  }

  Future<String> _loadFullLocationName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullLocationName') ?? '';
  }

  Future<void> _fetchCartItems() async {
    try {
      final cartItems = await CartApiService.fetchCartItems('CUST000394');
      setState(() {
        _cartItems = cartItems;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      // Handle error
    }
  }

  Future<void> _updateCartSize(
      String customerId, String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/updatecartsize1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "customerid": customerId,
          "productid": productId,
          "quantity": quantity.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('Cart size updated successfully');
        // Fetch the cart items again to reflect the updated quantity
        await _fetchCartItems();
      } else {
        print(
            'Failed to update cart size. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart size: $e');
    }
  }

  void _decrementCounter(String productId, int currentQuantity) async {
    int index = _cartItems.indexWhere((item) => item['ProductID'] == productId);
    if (currentQuantity > 1 && index != -1) {
      int newQuantity = currentQuantity - 1;
      await _updateCartSize('CUST000394', productId, newQuantity);
      setState(() {
        _cartItems[index]['Quantity'] = newQuantity;
      });
      _refreshCartModal(); // Refresh modal to reflect updated cart
    }
  }

  void _incrementCounter(String productId, int currentQuantity) async {
    int index = _cartItems.indexWhere((item) => item['ProductID'] == productId);
    if (index != -1) {
      int newQuantity = currentQuantity + 1;
      await _updateCartSize('CUST000394', productId, newQuantity);
      setState(() {
        _cartItems[index]['Quantity'] = newQuantity;
      });
      _refreshCartModal(); // Refresh modal to reflect updated cart
    }
  }

  void _showCartModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: _buildCartItems(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart,
                                        color: Colors.pink),
                                    SizedBox(width: 5),
                                    Text(
                                      '${_cartItems.length} items',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(0),
                                border:
                                    Border.all(color: Colors.pink, width: 2),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Checkout()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
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
          },
        );
      },
    );
  }

  Widget _buildCartItems() {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final productId = _cartItems[index]['ProductID'];
          final currentQuantity = _cartItems[index]['Quantity'];

          return Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
                        SizedBox(height: 25),
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
                                  onPressed: () => _decrementCounter(
                                      productId, currentQuantity),
                                  padding: EdgeInsets.all(0),
                                  constraints: BoxConstraints(),
                                  splashRadius: 20,
                                  iconSize: 18,
                                  icon: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 5),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.pink, // Pink background color
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child:
                                        Icon(Icons.remove, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 0.2),
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    currentQuantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _incrementCounter(
                                      productId, currentQuantity),
                                  padding: EdgeInsets.all(0),
                                  constraints: BoxConstraints(),
                                  splashRadius: 20,
                                  iconSize: 18,
                                  icon: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.pink, // Pink background color
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.pink, // Set the background color to pink
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 5),
                      FutureBuilder<String>(
                        future: _loadFullLocationName(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            );
                          } else {
                            return CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Handle user icon tap
                    },
                    child: Icon(Icons.person, color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.pink,
            elevation: 0,
            automaticallyImplyLeading: false,
            pinned: true, // This ensures the SliverAppBar stays fixed
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Claco',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroceryHome()),
                            );
                          },
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroceryHome()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Grocery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: Colors.black.withOpacity(0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.search,
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                            Expanded(
                              child: Center(
                                child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Search any products..',
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(bottom: 8.0),
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.mic,
                                color: Colors.grey.withOpacity(0.7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
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
                        padding: EdgeInsets.only(
                            right: 20, left: 20, top: 20, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: selectedButton == 'home'
                                        ? Colors.pink
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButton = 'home';
                                  });
                                },
                                child: Text('Grocery'),
                                style: TextButton.styleFrom(
                                  foregroundColor: selectedButton == 'home'
                                      ? Colors.pink
                                      : Colors.black,
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: selectedButton == 'second'
                                        ? Colors.pink
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButton = 'second';
                                  });
                                },
                                child: Text('Vegetable & Fruit'),
                                style: TextButton.styleFrom(
                                  foregroundColor: selectedButton == 'second'
                                      ? Colors.pink
                                      : Colors.black,
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    selectedButton == 'home' ? GroceryHomePage() : Vegitable(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    _showCartModalSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.pink),
                      SizedBox(width: 5),
                      Text(
                        '${_cartItems.length} items',
                        style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(color: Colors.pink, width: 2),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Checkout()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
