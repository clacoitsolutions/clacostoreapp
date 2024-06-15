import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_appbar.dart';
import '../pageUtills/invoice.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? selectedReason; // Variable to hold the selected cancellation reason
  bool isCancelled = false; // Flag to track if the order is cancelled
  double rating = 0; // Variable to hold the star rating
  String? orderId; // Variable to hold the order ID from shared preferences

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Order ID - ${orderId ?? 'Loading...'}',
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/kurti1.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fancy Kurti Black , Gold',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Size: L , Color: Black',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Seller: STIPVTLTD',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Quantity: 1',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '₹350',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Tracking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildTrackingItem('Placed', true),
                  _buildVerticalLine(true),
                  _buildTrackingItem('On the Way', false),
                  _buildVerticalLine(true),
                  _buildTrackingItem('Delivered', false),
                  _buildVerticalLine(false),
                  if (isCancelled) ...[
                    _buildTrackingItem('Cancel', false),
                    _buildVerticalLine(false, isCancelled),
                    _buildTrackingItem('Return', false),
                    _buildVerticalLine(false, isCancelled),
                    _buildTrackingItem('Refund', false),
                    _buildVerticalLine(false, isCancelled),
                  ],
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                _showCancelOrderDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5), // Background color
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                        (index) =>
                        IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: index < rating ? Colors.green : Colors.grey,
                            size: 44, // Set star size to 24
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat,
                  size: 30,
                  color: Colors.pinkAccent,
                ),
                SizedBox(width: 10),
                Text(
                  'Need help?',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Navigate to invoice page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvoicePage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat,
                          color: Colors.pinkAccent,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Invoice download',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 26,
                      color: Colors.grey,
                    ),
                  ),
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
                        vertical: 10, horizontal: 20),
                    child: Text(
                      'Shipping details',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipped Date: 10/06/2023',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Shipping Method: Standard Shipping',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Shipping Address:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Snehal Dangade',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '34/78, Near Max mall, Bapunagar, Ahmedabad',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Contact: +91 9823894793',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingItem(String title, bool isComplete) {
    return Row(
      children: <Widget>[
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isComplete ? Colors.green : Colors.grey,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 16.0,
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          title,
          style: TextStyle(
            color: isComplete ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLine(bool isActive, [bool isVisible = true]) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        width: 1.0,
        height: 30.0,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Please select a reason for cancellation:'),
                  DropdownButton<String>(
                    value: selectedReason,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedReason = newValue;
                      });
                    },
                    items: <String>[
                      'Change of mind',
                      'Ordered by mistake',
                      'Found a better price',
                      'Product not needed',
                      'Other'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle cancellation logic here
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
