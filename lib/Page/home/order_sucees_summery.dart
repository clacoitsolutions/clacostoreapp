import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const OrderSummaryScreen({Key? key, required this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Order ID: ${orderDetails['OrderId']}'),
            SizedBox(height: 10),
            Text('Name: ${orderDetails['Name']}'),
            SizedBox(height: 10),
            Text('Mobile No: ${orderDetails['MobileNo']}'),
            SizedBox(height: 10),
            Text('Email Address: ${orderDetails['EmailAddress']}'),
            SizedBox(height: 10),
            Text('Net Payable: ₹${orderDetails['NetPayable']}'),
          ],
        ),
      ),
    );
  }
}
