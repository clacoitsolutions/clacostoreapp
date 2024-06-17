import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api services/Product_order_api.dart';
import '../pageUtills/common_appbar.dart';

import 'order_details.dart';


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add http package
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Order_model.dart';
import '../pageUtills/common_appbar.dart';
import 'order_details.dart';


class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  Future<List<OrderItem>>? _futureOrderItems; // Make _futureOrderItems nullable
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
      body: FutureBuilder<List<OrderItem>>(
        future: _futureOrderItems ?? Future.value([]), // Provide a default Future if _futureOrderItems is null
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<OrderItem> orderItems = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: orderItems.map((item) {
                  return FlippableCard(item: item);
                }).toList(),
              ),
            );
          } else {
            // Handle the case where no data is available
            return Center(child: Text('No orders found.'));
          }
        },
      ),
    );
  }
}

class FlippableCard extends StatefulWidget {
  final OrderItem item;

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

  Future<void> _saveOrderIdAndNavigate(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId);
    Navigator.pushNamed(context, '/orderDetails');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _saveOrderIdAndNavigate(widget.item.orderId); // Access orderId directly from item
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

  Widget _buildOrderItemFront(OrderItem item) {
    bool isCancelled = item.deliveryStatus == 'cancelled';

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: ${item.orderId}',
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
                    ' ${item.deliveryStatus}',
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
                      'Product Name: ${item.productName}',
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
                          "null",
                          // '${item.rating}', // Assuming Rating is part of the item details
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
                      '₹${item.totalAmount}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Delivery Time: ${item.deliveryTime}',
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

Future<List<OrderItem>> fetchOrderItems(String customerId) async {
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
      List<OrderItem> orderItems = [];

      if (data.containsKey('orderItemDetails1')) {
        orderItems.addAll((data['orderItemDetails1'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList());
      }
      if (data.containsKey('orderItemDetails2')) {
        orderItems.addAll((data['orderItemDetails2'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList());
      }

      return orderItems;
    } else {
      throw Exception('Failed to load order items: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load order items: $e');
  }
}







//
// class MyOrderScreen extends StatefulWidget {
//   @override
//   _MyOrderScreenState createState() => _MyOrderScreenState();
// }
//
// class _MyOrderScreenState extends State<MyOrderScreen> {
//   Future<List<dynamic>>? _futureOrderItems;
//   String? userName;
//   String? userEmail;
//   String? customerId;
//   String? mobileNo;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('name');
//       userEmail = prefs.getString('emailAddress');
//       customerId = prefs.getString('customerId');
//       mobileNo = prefs.getString('mobileNo');
//
//       if (customerId != null) {
//         _futureOrderItems = fetchOrderItems(customerId!);
//       } else {
//         // Show message for logged out users
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CommonAppBar(title: 'My Orders'),
//       body: FutureBuilder<List<dynamic>>(
//         future: _futureOrderItems ?? Future.delayed(Duration(seconds: 1), () => []),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<dynamic> orderItems = snapshot.data!;
//             return SingleChildScrollView(
//               child: Column(
//                 children: orderItems.map((item) {
//                   return FlippableCard(item: item);
//                 }).toList(),
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else { // Handle the case where the Future is still pending
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
//
//
//
// class FlippableCard extends StatefulWidget {
//   final Map<String, dynamic> item;
//
//   const FlippableCard({Key? key, required this.item}) : super(key: key);
//
//   @override
//   _FlippableCardState createState() => _FlippableCardState();
// }
//
// class _FlippableCardState extends State<FlippableCard> {
//   bool _isFrontVisible = true;
//
//   void toggleCard() {
//     setState(() {
//       _isFrontVisible = !_isFrontVisible;
//     });
//   }
//
//   Future<void> _saveProductIdAndNavigate(String orderId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('orderId', orderId);
//     Navigator.pushNamed(context, '/orderDetails');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _saveProductIdAndNavigate(widget.item['OrderId']);
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.4),
//               spreadRadius: 1,
//               blurRadius: 8,
//               offset: Offset(0, 5),
//             ),
//           ],
//           color: Colors.white,
//         ),
//         child: AnimatedSwitcher(
//           duration: Duration(milliseconds: 300),
//           child: _isFrontVisible
//               ? _buildOrderItemFront(widget.item)
//               : _buildOrderItemBack(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOrderItemFront(Map<String, dynamic> item) {
//     bool isCancelled = item['DeliveryStatus'] == 'cancelled';
//
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Order ID: ${item['OrderId']}',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Container(
//                     width: 10,
//                     height: 10,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isCancelled ? Colors.red : Colors.green,
//                     ),
//                   ),
//                   SizedBox(width: 1),
//                   Text(
//                     ' ${item['DeliveryStatus']}',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 18), // Adjust spacing as needed
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 height: 120,
//                 width: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: NetworkImage(item['ProductMainImageUrl']),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 8),
//                     Text(
//                       'Product Name: ${item['ProductName']}',
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.orange, size: 20),
//                         SizedBox(width: 5),
//                         Text(
//                           '${item['Rating']}', // Assuming Rating is part of the item details
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '₹${item['TotalAmount']}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.pinkAccent,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Delivery Time: ${item['DeliveryTime']}',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOrderItemBack() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Center(
//         child: Text(
//           'Additional Details or Actions',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//       ),
//     );
//   }
// }
