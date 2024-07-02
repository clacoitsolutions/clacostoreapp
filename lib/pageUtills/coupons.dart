import 'package:claco_store/pageUtills/common_appbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'coupon_dilog_box.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<Coupons> {
  List<dynamic> coupons = []; // List to store fetched coupons

  @override
  void initState() {
    super.initState();
    print('Initializing CouponsPage');
    fetchCoupons();
  }

  @override
  void dispose() {
    print('Disposing CouponsPage');
    super.dispose();
  }

  Future<void> fetchCoupons() async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/assigncoupan'),
        body: jsonEncode({
          'CustomerId': 'CUST000394', // Replace with your actual customer ID
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse JSON data and update state
        var jsonResponse = json.decode(response.body);
        setState(() {
          coupons = jsonResponse['data'];
        });
      } else {
        throw Exception('Failed to load coupons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Coupons',),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: coupons.asMap().entries.map((entry) {
              int index = entry.key;
              var coupon = entry.value;
              Color cardColor = (index % 2 == 0) ? Colors.pink.shade50 : Colors.cyan.shade50;

              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      height: 120.0,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            height: 100.0,
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Image.network(
                                'https://example.com/path/to/images/${coupon['Image']}', // Update the path accordingly
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${coupon['Discount']}% off',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    coupon['CoupanName'],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${coupon['StartDate'].substring(0, 7)} - ${coupon['EndDate'].substring(0, 7)}',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // When the text is tapped, show the modal
                              CouponDialog.show(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Apply Coupon',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
