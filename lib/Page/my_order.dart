import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Order_model.dart';
import '../pageUtills/common_appbar.dart';
import 'order_details.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  Future<Map<String, List<OrderItem>>>? _futureOrderItems;
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
        _futureOrderItems = fetchOrderItems(customerId!);
      } else {
        // Show message for logged out users
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'My Orders'),
      body: FutureBuilder<Map<String, List<OrderItem>>>(
        future: _futureOrderItems ?? Future.value({}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, List<OrderItem>> groupedOrderItems = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: groupedOrderItems.entries.map((entry) {
                  return FlippableCard(orderId: entry.key, items: entry.value);
                }).toList(),
              ),
            );
          } else {
            return Center(child: Text('No orders found.'));
          }
        },
      ),
    );
  }
}

class FlippableCard extends StatefulWidget {
  final String orderId;
  final List<OrderItem> items;

  const FlippableCard({Key? key, required this.orderId, required this.items}) : super(key: key);

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

  Future<void> _saveOrderIdAndNavigate(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId);
    Navigator.pushNamed(context, '/orderDetails');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _saveOrderIdAndNavigate(widget.orderId);
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
        child: _isFrontVisible
            ? _buildOrderItemFront(widget.orderId, widget.items.first.deliveryStatus, widget.items)
            : _buildOrderItemBack(),
      ),
    );
  }

  Widget _buildOrderItemFront(String orderId, String deliveryStatus, List<OrderItem> items) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: $orderId',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getDeliveryStatusColor(deliveryStatus),
                    ),
                  ),
                  SizedBox(width: 8), // Add spacing between the circle and the text
                  Text(
                    deliveryStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18),
          Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(item.productMainImageUrl),
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
                            item.productName.length > 20
                                ? '${item.productName.substring(0, 20)}...'
                                : item.productName,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '₹${item.totalAmount}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Quantity: ${item.quantity}',
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  Color _getDeliveryStatusColor(String deliveryStatus) {
    // Normalize deliveryStatus to lower case for consistent comparison
    String status = deliveryStatus;

    switch (status) {
      case 'cancelled':
        return Colors.red;
      case 'Placed':
        return Colors.yellow;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.green; // Default color if status is not recognized
    }
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

Future<Map<String, List<OrderItem>>> fetchOrderItems(String customerId) async {
  try {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/getorderitems'),
      body: jsonEncode({'CustomerId': customerId}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      Map<String, List<OrderItem>> groupedOrderItems = {};

      if (data.containsKey('orderItemDetails1')) {
        for (var item in data['orderItemDetails1']) {
          OrderItem orderItem = OrderItem.fromJson(item);
          groupedOrderItems.putIfAbsent(orderItem.orderId, () => []).add(orderItem);
        }
      }
      if (data.containsKey('orderItemDetails2')) {
        for (var item in data['orderItemDetails2']) {
          OrderItem orderItem = OrderItem.fromJson(item);
          groupedOrderItems.putIfAbsent(orderItem.orderId, () => []).add(orderItem);
        }
      }

      return groupedOrderItems;
    } else {
      throw Exception('Failed to load order items: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load order items: $e');
  }
}
