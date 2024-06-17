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
  String? deliveryStatus; // Define delivery status variable

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
      // Example of setting deliveryStatus based on conditions (adjust as per your logic)
      setState(() {
        if (orderItems.isNotEmpty) {
          if (orderItems[0]['DeliveryStatus'] != null) {
            deliveryStatus = orderItems[0]['DeliveryStatus'];
          }
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
      // Handle error as needed, e.g., show a snackbar or retry option
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
            // Display order items fetched from API
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                var item = orderItems[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
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
                            height: 120,
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
                                'Seller: ${item['Seller'] ?? 'NA'}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Quantity: ${item['Quantity']}',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                '₹ ${item['TotalAmount']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
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
                  _buildTrackingItem('Placed', deliveryStatus == 'cancelled' || deliveryStatus == null),
                  _buildVerticalLine(deliveryStatus != 'Delivered'),
                  _buildTrackingItem('On the Way', deliveryStatus == 'cancelled' || deliveryStatus == null),
                  _buildVerticalLine(deliveryStatus != 'Cancelled'),
                  if (deliveryStatus == 'cancelled') ...[
                    _buildTrackingItem('cancelled', true),
                    SizedBox(height: 20),
                  ] else ...[
                    _buildTrackingItem('Delivered', deliveryStatus == 'Delivered'),
                    _buildVerticalLine(false),
                  ],
                  if (isCancelled || deliveryStatus == 'Cancelled') ...[
                    _buildTrackingItem('Cancel', deliveryStatus == 'Cancelled'),
                    _buildVerticalLine(false, deliveryStatus == 'Cancelled'),
                    _buildTrackingItem('Return', deliveryStatus == 'Cancelled'),
                    _buildVerticalLine(false, deliveryStatus == 'Cancelled'),
                    _buildTrackingItem('Refund', deliveryStatus == 'Cancelled'),
                    _buildVerticalLine(false, deliveryStatus == 'Cancelled'),
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
                color: Color(0xFFF5F5F5), // Background color
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShippingDetail(
                      'Customer Name:', orderItems.isNotEmpty ? orderItems[0]['CustomerName'] ?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail(
                      'Customer Mobile:', orderItems.isNotEmpty ? orderItems[0]['CustomerMobile'] ?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail(
                      'Customer Address:', orderItems.isNotEmpty ? orderItems[0]['CustomerAddress'] ?? 'Loading...' : 'Loading...'),
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
                color: Color(0xFFF5F5F5), // Background color
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShippingDetail('Payment Mode:',
                      orderItems.isNotEmpty ? orderItems[0]['PaymentMode'] ?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail('Delivery Time:',
                      orderItems.isNotEmpty ? orderItems[0]['DeliveryTime'] ?? 'Loading...' : 'Loading...'),
                  _buildShippingDetail('Delivery Charges:',
                      orderItems.isNotEmpty ? orderItems[0]['DeliveryCharges'].toString() ?? 'Loading...' : 'Loading...'),
                  _buildDivider(),
                  _buildShippingDetailprice('Gross Amount:',
                      orderItems.isNotEmpty ? orderItems[0]['GrossAmount'].toString() ?? 'Loading...' : 'Loading...'),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingItem(String title, bool isActive) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.red : Colors.grey,
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 16, color: isActive ? Colors.black : Colors.grey),
        ),
      ],
    );
  }

  Widget _buildVerticalLine(bool isActive, [bool isCancelled = false]) {
    return Container(
      width: 2,
      height: 20,
      color: isActive ? Colors.red : (isCancelled ? Colors.grey : Colors.transparent),
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.black54),
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

  Widget _buildPaymentDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 16),
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
                // Implement cancel order logic here
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

