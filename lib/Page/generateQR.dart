import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRCodeGeneratorWidget extends StatefulWidget {
  @override
  _QRCodeGeneratorWidgetState createState() => _QRCodeGeneratorWidgetState();
}

class _QRCodeGeneratorWidgetState extends State<QRCodeGeneratorWidget> {
  String customerId = "CUST000388";
  Future<Customer?>? _customerDataFuture;

  @override
  void initState() {
    super.initState();
    _getCustomerIDAndFetchData(); // Get CustomerID from SharedPreferences and fetch customer data
  }

  Future<void> _getCustomerIDAndFetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCustomerId = prefs.getString('customerId');
    if (storedCustomerId != null) {
      setState(() {
        customerId = storedCustomerId;
        _customerDataFuture = _fetchCustomerData(customerId);
      });
    } else {
      // Handle the case when CustomerID is not found in SharedPreferences
      print('CustomerID not found in SharedPreferences');
    }
  }

  Future<Customer?> _fetchCustomerData(String customerId) async {
    final apiUrl =
        'https://clacostoreapi.onrender.com/getReciverCustomerDetails';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"CustomerID": customerId}),
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final customerJson = responseData['data'][0];
          print("Decoded Data: $customerJson");
          return Customer.fromJson(customerJson);
        } else {
          throw Exception('No customer data found');
        }
      } else {
        throw Exception('Failed to load customer data');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void _refreshData(String newCustomerId) {
    setState(() {
      customerId = newCustomerId;
      _customerDataFuture = _fetchCustomerData(newCustomerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Coin QR Code '),
      ),
      body: Center(
        child: FutureBuilder<Customer?>(
          future: _customerDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              final customerData = snapshot.data!;
              final qrData = jsonEncode({
                'CustomerId': customerData.customerId,
                'Name': customerData.name,
                'MobileNo': customerData.mobileNo,
              });
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Customer ID: ${customerData.customerId}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Name: ${customerData.name}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Mobile No: ${customerData.mobileNo}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}

class Customer {
  final String customerId;
  final String name;
  final String mobileNo;

  Customer({
    required this.customerId,
    required this.name,
    required this.mobileNo,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['CustomerId'] ?? '',
      name: json['Name'] ?? '',
      mobileNo: json['MobileNo'] ?? '',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QRCodeGeneratorWidget(),
  ));
}
