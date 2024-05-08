import 'package:flutter/material.dart';

class CouponDialog {
  static void show(BuildContext context) {
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
                  children: [
                    Icon(Icons.close),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              Image.network(
                'https://cdn-icons-png.freepik.com/512/579/579378.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 8),
              Text(
                'Congratulations!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'You\'ve just earned a surprise',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                '50% off',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Coupon Code: XYZ123',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Add logic for redeeming coupon
              },
              child: Container(
                width: double.infinity, // Set width to fill the available space
                child: Text(
                  'Redeem Coupon',
                  textAlign: TextAlign.center, // Center the text within the button
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0), // Set border radius to 0
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
