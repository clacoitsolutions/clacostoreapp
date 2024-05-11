import 'package:flutter/material.dart';

import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_appbar.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'My Orders'),
      body: MyOrderScreen(),

    );
  }
}

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            _buildRowWithShadow(context),
            _buildRowWithShadow(context),
            _buildRowWithShadow(context),
            _buildRowWithShadow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRowWithShadow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/orderDetails'); // Navigate to order details page
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Set border color to grey
              width: 1, // Set border width to 1px
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 170,
                width: 146, // Set width as per your requirement
                child: Center(
                  child: Image.asset(
                    'assets/image/kurti1.png', // Path to your image asset
                    height: 130,
                    width: 130,
                  ),
                ),
              ),
              Container(
                height: 160,
                width: 300, // Set width as per your requirement
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Expected by Fri April 26 ', // Text with currency symbol
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Available (in Stock)', // Text with currency symbol
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Fancy Kurti', // Text with currency symbol
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹350', // Text with currency symbol
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.green),
                        SizedBox(width: 5),
                        Text(
                          '4.5', // Rating
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
