import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'barcode_card.dart';
import 'package:image_picker/image_picker.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String totalCoins = ''; // State variable to hold total coins

  @override
  void initState() {
    super.initState();
    _fetchTotalCoins(); // Fetch total coins when the widget initializes
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  Future<void> _fetchTotalCoins() async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/getTotalCoin'),
        body: json.encode({
          "CustomerID": "CUST000383",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        if (data.isNotEmpty) {
          setState(() {
            totalCoins = data[0]['TotalCoin'] ?? '';
          });
        }
      } else {
        throw Exception('Failed to fetch total coins');
      }
    } catch (e) {
      print('Error fetching total coins: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Image.asset(
          'images/logo.png', // Replace with your actual logo path
          height: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Image and Available Balance section
                  Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 70.0),
                              child: Image.asset(
                                '/images/coinlogo.png', // Replace with your actual image path
                                height: 70,
                                width: 300,
                              ),
                            ),
                            Positioned(
                              right: 74,
                              child: Text(
                                totalCoins, // Display total coins fetched from API
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Available Balance',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    ),
                    onPressed: () {},
                    child: Text('Use Supercoins'),
                  ),
                  SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Shop & Earn! ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Get @ ',
                        ),
                        TextSpan(
                          text: '2 SuperCoins ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '(up to 50)',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Per Rs 100',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          _scanQRCode();
                        },
                        child: Text('Send coins'),
                      ),
                      SizedBox(width: 20),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          print('Receive coins');
                        },
                        child: Text('Receive coins'),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 123.0),
                    child: Text(
                      'Transaction History',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 12),
                    child: Text(
                      'Supercharge your savings with Coins! Regular Coins last 6 months, Coins up to 1 year. '
                      'For longer options, explore loyalty points with 1-year validity!',
                    ),
                  ),
                  SizedBox(height: 4),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 180.0),
                    child: Text(
                      'Expire Coins',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 15),
                    child: Row(
                      // Use Row to align the text and additional text
                      children: [
                        Text(
                          'Expiry Date: Jan 24 2025 6:44PM',
                          style: TextStyle(color: Colors.black),
                          // Default text color
                        ),
                        SizedBox(
                          width: 40,
                        ), // Add spacing between the texts
                        Text(
                          ' -35',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12), // Red color for additional text
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 190.0),
                    child: Text(
                      'Add Coins',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 20),
                    child: Row(
                      // Use Row to align the text and additional text
                      children: [
                        Text(
                          'Add Date: Jan 24 2024 6:44PM',
                          style: TextStyle(color: Colors.black),
                          // Default text color
                        ),
                        SizedBox(
                          width: 55,
                        ), // Add spacing between the texts
                        Text(
                          ' 35',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12), // Red color for additional text
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scanQRCode() async {
    final scannedData = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Scan QR Code', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.pink,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 300,
          ),
        ),
      ),
    ));

    // Check if scannedData is not null and is a Map
    if (scannedData != null && scannedData is Map<String, dynamic>) {
      // Now you can access the data from the QR code
      String name = scannedData['Name'] ?? '';
      String mobile = scannedData['Mobile No.'] ?? '';
      String customerId = scannedData['Customer ID'] ?? '';

      // Pass data to BarCodecard
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarCodecard(
            name: name,
            mobile: mobile,
            customerId: customerId,
          ),
        ),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        try {
          // Attempt to decode the QR code data as JSON
          final Map<String, dynamic> jsonData = json.decode(result!.code!);
          // Pass the jsonData to the previous screen
          Navigator.pop(context, jsonData);
        } catch (e) {
          print('Invalid QR code format: $e');
          // Handle the case where the QR code is not in the expected format
          // You might want to show an error message to the user
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
