import 'package:flutter/material.dart';

import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_appbar.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'My Orders'),
      body: Column(
        children: [
          _buildSearchAndFiltersRow(context),
          Expanded(
            child: MyOrderScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFiltersRow(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Your order here...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  int rating = 0; // Variable to store rating

  // Sample list of orders
  List<Order> orders = [
    Order(
      deliveryDate: 'Delivery Expected by Fri April 26',
      availability: 'Available (in Stock)',
      productName: 'Fancy Kurti',
      price: '₹350',
      quantity: 'Quantity: 1',
      imagePath: 'assets/images/kurti1.png',
    ),
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: orders.map((order) {
          return _buildOrderContainer(context, order);
        }).toList(),
      ),
    );
  }

  Widget _buildOrderContainer(BuildContext context, Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/orderDetails'); // Navigate to order details page
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey, // Set border color to grey
            width: 1, // Set border width to 1px
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 110,
              width: 110, // Set width as per your requirement
              child: Center(
                child: Image.asset(
                  order.imagePath, // Path to your image asset
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            SizedBox(width: 10), // Added spacing between image and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName, // Product name
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    order.deliveryDate, // Delivery date
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    order.availability, // Availability
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 2),
                  Text(
                    order.price, // Price
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    order.quantity, // Quantity
                    style: TextStyle(
                      fontSize: 16,
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
}

class Order {
  final String deliveryDate;
  final String availability;
  final String productName;
  final String price;
  final String quantity;
  final String imagePath;

  Order({
    required this.deliveryDate,
    required this.availability,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });
}
