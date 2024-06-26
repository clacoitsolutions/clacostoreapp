import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../pageUtills/common_appbar.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? orderId;
  bool isCancelled = false;
  double rating = 0;
  List<Map<String, dynamic>> orderItems = [];
  String? deliveryStatus;

  @override
  void initState() {
    super.initState();
    _getOrderIdFromPreferences();
  }

  Future<void> _getOrderIdFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      orderId = prefs.getString('orderId');
    });
    if (orderId != null) {
      await _fetchOrderDetails(orderId!);
      setState(() {
        if (orderItems.isNotEmpty && orderItems[0]['DeliveryStatus'] != null) {
          deliveryStatus = orderItems[0]['DeliveryStatus'];
        }
      });
    }
  }

  Future<void> _fetchOrderDetails(String orderId) async {
    var apiUrl = 'https://clacostoreapi.onrender.com/clickorderdetails';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          orderItems = List<Map<String, dynamic>>.from(jsonData['orderItems']);
        });
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Order Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Order ID - ${orderId ?? 'Loading...'}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                var item = orderItems[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.network(
                            item['ProductMainImageUrl'],
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['ProductName'].length > 20
                                    ? '${item['ProductName'].substring(0, 20)}...'
                                    : item['ProductName'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                ' ₹${item['TotalAmount'] ?? 'NA'}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Quantity: ${item['Quantity']}',
                                style: TextStyle(fontSize: 15),
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
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Tracking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildTrackingItem('Placed', deliveryStatus != null, false),
                  _buildVerticalLine(deliveryStatus != 'Delivered' && deliveryStatus != 'Cancelled'),
                  _buildTrackingItem('On the Way', deliveryStatus == 'On the Way' || deliveryStatus == 'Delivered', deliveryStatus == 'Cancelled'),
                  _buildVerticalLine(deliveryStatus == 'On the Way'),
                  if (deliveryStatus == 'Cancelled') ...[
                    _buildTrackingItem('Cancelled', true, true),
                  ] else ...[
                    _buildTrackingItem('Delivered', deliveryStatus == 'Delivered', false),
                  ],
                ],
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                _showCancelOrderDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Cancel Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
                color: Color(0xFFF5F5F5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      'Shipping details',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShippingDetail('Name:', orderItems.isNotEmpty ? orderItems[0]['CustomerName'] ?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail('Mobile No:', orderItems.isNotEmpty ? orderItems[0]['CustomerMobile'] ?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail('Address:', orderItems.isNotEmpty ? orderItems[0]['CustomerAddress']?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail('Pincode:', orderItems.isNotEmpty ? orderItems[0]['CustomerPinCode']?? 'Loading...' : 'Loading...'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
                color: Color(0xFFF5F5F5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      'Payment details',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShippingDetail('Payment Method:', orderItems.isNotEmpty ? orderItems[0]['PaymentMode'] ?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail('Delivery', orderItems.isNotEmpty ? orderItems[0]['DeliveryTime'] ?? 'Fast' : 'Fast'),
                  _buildShippingDetail('Delivery Charges:', orderItems.isNotEmpty ? orderItems[0]['DeliveryCharges'].toString() ?? 'Loading...' : 'Loading...'),
                  _buildDivider(),
                  _buildShippingDetailprice('Gross Amount:', orderItems.isNotEmpty ? orderItems[0]['TotalAmount'].toString() ?? 'Loading...' : 'Loading...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingItem(String title, bool isActive, bool isCancelled) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCancelled
                ? Colors.red
                : (isActive ? Colors.green : Colors.grey),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isCancelled ? Colors.red : (isActive ? Colors.black : Colors.grey),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLine(bool isActive) {
    return Container(
      width: 2,
      height: 20,
      color: isActive ? Colors.green : Colors.grey,
    );
  }

  Widget _buildShippingDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetailprice(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 10),
              Text(
                '₹ $value',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.pink),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.grey,
        height: 1,
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancel Order"),
          content: Text("Are you sure you want to cancel this order?"),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("CONFIRM"),
              onPressed: () {
                setState(() {
                  isCancelled = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
