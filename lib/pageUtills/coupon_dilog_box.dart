import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CouponDialog {
  static void show(BuildContext context, Map<String, dynamic> coupon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.close),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              Image.network(
                '${coupon['Image']}',
                width: 100,
                height: 100,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
              const SizedBox(height: 8),
              const Text(
                'Congratulations!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'You\'ve just earned a surprise',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${coupon['Discount']}% off',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Coupon Code: ${coupon['CoupanCode']}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                redeemCoupon(context, coupon['CoupanCode']);
              },
              child: Container(
                width: double.infinity,
                child: const Text(
                  'Redeem Coupon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> redeemCoupon(BuildContext context, String coupanCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/redeem-coupon'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'CoupanCode': coupanCode,
        }),
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
      } else {
        throw Exception('Failed to redeem coupon: ${response.statusCode}');
      }
    } catch (e) {
      print('Error redeeming coupon: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error redeeming coupon: $e')),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }
}
