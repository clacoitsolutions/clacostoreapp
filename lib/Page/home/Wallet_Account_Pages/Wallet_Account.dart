import 'package:claco_store/Page/home/Wallet_Account_Pages/Add_Account_Details.dart';
import 'package:claco_store/Page/home/Wallet_Account_Pages/Add_CardDetails.dart';
import 'package:claco_store/Page/home/Wallet_Account_Pages/Add_UPIid_Details.dart';
import 'package:claco_store/pageUtills/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletAccountPage extends StatefulWidget {
  @override
  _WalletAccountPageState createState() => _WalletAccountPageState();
}

class _WalletAccountPageState extends State<WalletAccountPage> {
  String? customerId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString('customerId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Wallet Account'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                // Handle form submission
                onPressed: () => _showAccountDetailsForm(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pink,
                  backgroundColor: Colors.white,
                  // Border color (pink)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // Rounded corners
                    side: BorderSide(color: Colors.pink, width: 2),
                    // Border width and color
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  // Padding around the button content
                ),
                child: Text(
                  'Add Account',
                  style: TextStyle(
                    color: Colors.pink,
                    // Text color (pink)
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                // Handle form submission
                onPressed: () => _showCardForm(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pink,
                  backgroundColor: Colors.white,
                  // Border color (pink)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // Rounded corners
                    side: BorderSide(color: Colors.pink, width: 2),
                    // Border width and color
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  // Padding around the button content
                ),
                child: Text(
                  'Add Card',
                  style: TextStyle(
                    color: Colors.pink,
                    // Text color (pink)
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                // Handle form submission
                onPressed: () => _showUPIIDForm(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pink,
                  backgroundColor: Colors.white,
                  // Border color (pink)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // Rounded corners
                    side: BorderSide(color: Colors.pink, width: 2),
                    // Border width and color
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  // Padding around the button content
                ),
                child: Text(
                  'Add UPIID',
                  style: TextStyle(
                    color: Colors.pink,
                    // Text color (pink)
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              if (customerId != null) ...[
                BankAccountCard(customerId: customerId!),
                SizedBox(height: 16.0),
                DebitCard(customerId: customerId!),
              ] else
                Center(child: CircularProgressIndicator()),
              SizedBox(height: 16.0),
              UpiDetailsCard(customerId: '',),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccountDetailsForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AccountDetailsForm(),
    );
  }

  void _showCardForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CardForm(),
    );
  }

  void _showUPIIDForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => UPIIDForm(),
    );
  }
}

class BankAccountCard extends StatelessWidget {
  final String customerId;

  BankAccountCard({required this.customerId});

  Future<Map<String, dynamic>> fetchBankDetails() async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/getbankpayments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'CustomerId': customerId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bank details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchBankDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!['orderItems'] == null || snapshot.data!['orderItems'].isEmpty) {
          return Center(child: Text('No Bank Details Found'));
        } else {
          var bankDetails = snapshot.data!['orderItems'][0];
          return Card(
            elevation: 5,
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA8CBB3), Color(0xFFCAA4D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank Account Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    RichText(
                      text: TextSpan(
                        text: 'Account Holder Name:     ',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: bankDetails['Holder_Name'] ?? 'N/A',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    RichText(
                      text: TextSpan(
                        text: 'Account Number:     ',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: bankDetails['AccountNumber'],
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    RichText(
                      text: TextSpan(
                        text: 'Bank Name:     ',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: bankDetails['Bank_Name'],
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    RichText(
                      text: TextSpan(
                        text: 'IFSC Code:     ',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: bankDetails['IFSC_Number'],
                            style: TextStyle(fontWeight: FontWeight.normal),
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
      },
    );
  }
}


class DebitCard extends StatelessWidget {
  final String customerId;

  DebitCard({required this.customerId});

  Future<Map<String, dynamic>> fetchCardDetails() async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/showcardapi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'CustomerId': customerId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load card details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCardDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!['orderItems'] == null || snapshot.data!['orderItems'].isEmpty) {
          return Center(child: Text('No Card Details Found'));
        } else {
          var cardDetails = snapshot.data!['orderItems'][0];
          return Card(
            elevation: 5,
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0425F8), Color(0xFFF80459)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Details Label
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Card Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Card Number
                  Text(
                    cardDetails['card_number'] ?? 'N/A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Cardholder Name
                  Text(
                    cardDetails['Holder_Name'] ?? 'N/A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Expiry Date and CVV
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cardDetails['expire_date'] ?? 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        cardDetails['cvv_number'] ?? 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}




class UpiDetailsCard extends StatefulWidget {
  final String customerId;

  UpiDetailsCard({required this.customerId});

  @override
  _UpiDetailsCardState createState() => _UpiDetailsCardState();
}

class _UpiDetailsCardState extends State<UpiDetailsCard> {
  String upiId = '';
  String mobileNumber = '';
  String accountHolderName = '';

  @override
  void initState() {
    super.initState();
    fetchUpiDetails();
  }

  Future<void> fetchUpiDetails() async {
    const String apiUrl = 'https://clacostoreapi.onrender.com/showUPI';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'CustomerId': widget.customerId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final orderItem = data['orderItems'][0];

      setState(() {
        upiId = orderItem['UPI_Number'] ?? '';
        mobileNumber = orderItem['MobileNo'] ?? '';
        accountHolderName = orderItem['AccountName'] ?? '';
      });
    } else {
      throw Exception('Failed to load UPI details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return (upiId.isNotEmpty && mobileNumber.isNotEmpty && accountHolderName.isNotEmpty)
        ? Card(
      elevation: 5,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf8d7e8), Color(0xFF9bdde2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UPI Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            RichText(
              text: TextSpan(
                text: 'UPI ID:     ',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.black87),
                children: [
                  TextSpan(
                    text: upiId,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                text: 'Mobile Number:     ',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.black87),
                children: [
                  TextSpan(
                    text: mobileNumber,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                text: 'Account Holder Name:     ',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.black87),
                children: [
                  TextSpan(
                    text: accountHolderName,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : Container(); // Return an empty container if data is null
  }
}