import 'package:flutter/material.dart';
import '../../Api services/Checkout_Api.dart';
import '../../pageUtills/top_navbar.dart';
import '../my_cart.dart';
import 'Chekout_page.dart';
import 'Vegitable_Fruit.dart';
import 'package:claco_store/pageUtills/common_appbar.dart';
import 'grocery_home_page.dart';

class GroceryHome extends StatefulWidget {
  @override
  State<GroceryHome> createState() => _GroceryHomeState();

  Future<void> _fetchCartItems() async {
    try {
      final cartItems = await CartApiService.fetchCartItems('CUST000394');
      setState(() {
        var _cartItems = cartItems;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      // Handle error
    }
  }

  void setState(Null Function() param0) {}
}

class _GroceryHomeState extends State<GroceryHome> {
  String selectedButton = 'home'; // Default to 'home'
  List<dynamic> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Container(
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
                  padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selectedButton == 'home' ? Colors.pink : Colors.transparent,
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
                            foregroundColor: selectedButton == 'home' ? Colors.pink : Colors.black,
                            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selectedButton == 'second' ? Colors.pink : Colors.transparent,
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
                            foregroundColor: selectedButton == 'second' ? Colors.pink : Colors.black,
                            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MycardScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.pink),
                      SizedBox(width: 5),
                      Text(
                        '${_cartItems.length} items',
                        style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16),
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
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
