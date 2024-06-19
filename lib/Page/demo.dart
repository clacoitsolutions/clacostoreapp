import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class demo extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<demo> {
  String customerCode = "CUST000394";
  double totalSalePrice = 0.0;
  double totalGSTAmount = 0.0;

  Future<void> getTotalAmount() async {
    final url = Uri.parse('https://clacostoreapi.onrender.com/getTotalNetAmmount');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "customerCode": customerCode,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        totalSalePrice = jsonResponse['addresses'][0]['TotalSalePrice'];
        totalGSTAmount = jsonResponse['addresses'][0]['TotalGSTAmount'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Amount Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Total Sale Price: \$${totalSalePrice.toStringAsFixed(2)}'),
            Text('Total GST Amount: \$${totalGSTAmount.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
