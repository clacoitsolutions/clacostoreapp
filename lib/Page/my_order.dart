import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api services/Product_order_api.dart';
import '../pageUtills/common_appbar.dart';

import 'order_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Orders',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyOrderScreen(),
      routes: {
        '/orderDetails': (context) => OrderDetailsScreen(),
      },
    );
  }
}

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  late Future<List<dynamic>> _futureOrderItems;

  @override
  void initState() {
    super.initState();
    _futureOrderItems = fetchOrderItems('CUST000458'); // Replace 'CUST000458' with actual customerId logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'My Orders'),

      body: FutureBuilder<List<dynamic>>(
        future: _futureOrderItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> orderItems = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: orderItems.map((item) {
                  return FlippableCard(item: item);
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // By default, show a loading spinner
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class FlippableCard extends StatefulWidget {
  final Map<String, dynamic> item;

  const FlippableCard({Key? key, required this.item}) : super(key: key);

  @override
  _FlippableCardState createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard> {
  bool _isFrontVisible = true;

  void toggleCard() {
    setState(() {
      _isFrontVisible = !_isFrontVisible;
    });
  }

  Future<void> _saveProductIdAndNavigate(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId);
    Navigator.pushNamed(context, '/orderDetails');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _saveProductIdAndNavigate(widget.item['OrderId']);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
          color: Colors.white,
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _isFrontVisible
              ? _buildOrderItemFront(widget.item)
              : _buildOrderItemBack(),
        ),
      ),
    );
  }

  Widget _buildOrderItemFront(Map<String, dynamic> item) {
    bool isCancelled = item['DeliveryStatus'] == 'cancelled';

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: ${item['OrderId']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCancelled ? Colors.red : Colors.green,
                    ),
                  ),
                  SizedBox(width: 1),
                  Text(
                    ' ${item['DeliveryStatus']}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18), // Adjust spacing as needed
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(item['ProductMainImageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Product Name: ${item['ProductName']}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        SizedBox(width: 5),
                        Text(
                          '${item['Rating']}', // Assuming Rating is part of the item details
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹${item['TotalAmount']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Delivery Time: ${item['DeliveryTime']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemBack() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Additional Details or Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
