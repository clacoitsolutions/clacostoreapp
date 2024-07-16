import 'package:claco_store/Page/OrderSuccesful_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RazorpayPaymentScreen(),
//     );
//   }
// }

class RazorpayPaymentScreen extends StatefulWidget {
  @override
  _RazorpayPaymentScreenState createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;
  double? _amount; // Use a double to store the amount
  String? _userName = '';
  String? _userEmail = '';
  String? _userPhone = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadUserData();
    _loadAmount(); // Load the amount from Shared Preferences
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? ''; // Provide a default value
      _userEmail = prefs.getString('emailAddress') ?? '';
      _userPhone = prefs.getString('mobileNo') ?? '';
      _amount =
          prefs.getDouble('totalAmount') ?? 0.0; // Default to 0.0 if not found
    });
  }

  Future<void> _loadAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _amount =
          prefs.getDouble('totalAmount') ?? 0.0; // Default to 0.0 if not found
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful: ${response.paymentId}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    // Navigate to OrderSummary after successful payment
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrderSuccessful(), // Pass paymentId to OrderSummary
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.code.toString()} - ${response.message}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet: ${response.walletName}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void openCheckout() {
    if (_amount == null) {
      Fluttertoast.showToast(
        msg: "Please enter amount",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      var options = {
        'key': 'rzp_test_YwHak0UIqBhpCK',
        'amount': (_amount! * 100).toInt(), // Convert to paise
        'name': 'Claco IT Services Private  Limited',
        'description': 'Test payment',
        'prefill': {
          'contact': _userPhone ?? '', // Use loaded phone or empty
          'email': _userEmail ?? '' // Use loaded email or empty
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      _razorpay.open(options);
    } catch (e) {
      print('Error: ${e.toString()}');
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Welcome to Claco IT Services Pvt. Ltd.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Display the amount from Shared Preferences
            Text(
              'Amount to be paid: ₹${_amount?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.pink, // Set the background color to blue
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Make Payment',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
