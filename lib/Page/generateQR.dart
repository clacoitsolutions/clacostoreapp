import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomerQRCode extends StatefulWidget {
  @override
  _CustomerQRCodeState createState() => _CustomerQRCodeState();
}

class _CustomerQRCodeState extends State<CustomerQRCode> {
  String _qrCodeData = 'Name: Tushar Sonker\n'
      'Mobile No.: 6453478383\n'
      'Customer ID: CUST5654';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImageView(
              data: _qrCodeData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Scan this QR Code',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

/// Through API QR Generator /////////////////////////////

//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:http/http.dart' as http; // For making API requests
// import 'dart:convert'; // For handling JSON data
//
// class CustomerQRCode extends StatefulWidget {
//   @override
//   _CustomerQRCodeState createState() => _CustomerQRCodeState();
// }
//
// class _CustomerQRCodeState extends State<CustomerQRCode> {
//   String? _customerId;
//   String? _qrCodeData;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCustomerId(); // Fetch initial customer ID when the widget is created
//   }
//
//   // Function to fetch customer ID from your API
//   Future<void> _fetchCustomerId() async {
//     try {
//       // Replace with your actual API endpoint and headers
//       final response = await http.get(Uri.parse('https://your-api-endpoint.com/customer_id'),
//           headers: {'Authorization': 'Bearer your_api_token'});
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           _customerId = data['customerId']; // Assuming your API returns "customerId"
//           _qrCodeData = _customerId; // Update QR code data
//         });
//       } else {
//         print('Error fetching customer ID: ${response.statusCode}');
//         // Handle errors appropriately (e.g., display an error message)
//       }
//     } catch (error) {
//       print('Error fetching customer ID: $error');
//       // Handle errors appropriately (e.g., display an error message)
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer QR Code'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // Display customer ID
//             Text(
//               'Customer ID: ${_customerId ?? "Loading..."}',
//               style: TextStyle(fontSize: 18.0),
//             ),
//             SizedBox(height: 20.0),
//             // Display QR code
//             _qrCodeData != null
//                 ? QrImage(
//               data: _qrCodeData!,
//               version: QrVersions.auto,
//               size: 200.0,
//             )
//                 : CircularProgressIndicator(), // Show a loading indicator while fetching data
//             SizedBox(height: 20.0),
//             // Button to simulate changing customer ID (replace with your actual logic)
//             ElevatedButton(
//               onPressed: () {
//                 // Replace with your logic to fetch a new customer ID (e.g., from user input, database, etc.)
//                 _fetchCustomerId(); // Update QR code after fetching
//               },
//               child: Text('Change Customer ID'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
