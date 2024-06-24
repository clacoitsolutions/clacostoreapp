import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderSuccessful extends StatefulWidget {
  @override
  _OrderSuccessfulState createState() => _OrderSuccessfulState();
}

class _OrderSuccessfulState extends State<OrderSuccessful> {
  // Initialize variables to store API response data
  String orderId = '';
  String paymentMode = '';
  String deliveryStatus = '';
  String name = '';
  String mobileNo = '';
  String addressType = '';
  String address = '';
  double netPayable = 0.0;

  // Function to fetch data from API
  Future<void> fetchData() async {
    // API endpoint URL
    final String apiUrl = 'https://clacostoreapi.onrender.com/getOrderConfirm';

    try {
      // Send POST request with OrderID
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'OrderID': 'ORD101001092'}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        final jsonData = jsonDecode(response.body);
        final data =
            jsonData['data'][0]; // Assuming there's only one order in the list

        setState(() {
          orderId = data['OrderId'];
          paymentMode = data['PaymentMode'];
          deliveryStatus = data['DeliveryStatus'];
          name = data['Name'];
          mobileNo = data['MobileNo'];
          addressType = data['AddressType'];
          address = data['Address'];
          netPayable = data['NetPayable'];
        });
      } else {
        // Handle other status codes
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Placed',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFe83e8c),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFe83e8c),
                  child: Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Hey $name', // Display fetched name
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Order Successfully Placed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "We'll send you a shipping confirmation email\nas soon as your order ships.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Your order will be sent to this address:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(address), // Display fetched address
                Text('Phone No: $mobileNo'), // Display fetched mobile number
                SizedBox(height: 8),
                Text(
                    '$netPayable rupees only'), // Display fetched net payable amount
                SizedBox(height: 8),
                Text(paymentMode), // Display fetched payment mode
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle check status action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFe83e8c),
                      ),
                      child: Text(
                        'Check Status',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle continue action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFe83e8c),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(), // Divider line
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "The payment of ",
                        style: TextStyle(
                            color:
                                Colors.black), // Default color for other text
                      ),
                      TextSpan(
                        text: "₹$netPayable",
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ), // Pink color for ₹$netPayable
                      ),
                      TextSpan(
                        text:
                            " you'll make when the delivery arrives with your order.",
                        style: TextStyle(
                            color:
                                Colors.black), // Default color for other text
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///// with Props /////////////////

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class OrderSuccessful extends StatefulWidget {
//   final String orderId; // Add a field to accept orderId
//
//   OrderSuccessful({required this.orderId}); // Modify the constructor to accept orderId
//
//   @override
//   _OrderSuccessfulState createState() => _OrderSuccessfulState();
// }
//
// class _OrderSuccessfulState extends State<OrderSuccessful> {
//   // Initialize variables to store API response data
//   String paymentMode = '';
//   String deliveryStatus = '';
//   String name = '';
//   String mobileNo = '';
//   String addressType = '';
//   String address = '';
//   double netPayable = 0.0;
//
//   // Function to fetch data from API
//   Future<void> fetchData() async {
//     // API endpoint URL
//     final String apiUrl = 'https://clacostoreapi.onrender.com/getOrderConfirm';
//
//     try {
//       // Send POST request with OrderID
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         body: jsonEncode({'OrderID': widget.orderId}), // Use the passed orderId
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         // Parse JSON response
//         final jsonData = jsonDecode(response.body);
//         final data = jsonData['data'][0]; // Assuming there's only one order in the list
//
//         setState(() {
//           paymentMode = data['PaymentMode'];
//           deliveryStatus = data['DeliveryStatus'];
//           name = data['Name'];
//           mobileNo = data['MobileNo'];
//           addressType = data['AddressType'];
//           address = data['Address'];
//           netPayable = data['NetPayable'];
//         });
//       } else {
//         // Handle other status codes
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle exceptions
//       print('Error: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData(); // Fetch data when widget initializes
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Order Placed',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color(0xFFe83e8c),
//       ),
//       body: Center(
//         child: Card(
//           margin: EdgeInsets.all(16.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           elevation: 5,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Color(0xFFe83e8c),
//                   child: Icon(
//                     Icons.check,
//                     size: 40,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Hey $name', // Display fetched name
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Order Successfully Placed',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "We'll send you a shipping confirmation email\nas soon as your order ships.",
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Your order will be sent to this address:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(address), // Display fetched address
//                 Text('Phone No: $mobileNo'), // Display fetched mobile number
//                 SizedBox(height: 8),
//                 Text('$netPayable rupees only'), // Display fetched net payable amount
//                 SizedBox(height: 8),
//                 Text(paymentMode), // Display fetched payment mode
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle check status action
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFe83e8c),
//                       ),
//                       child: Text(
//                         'Check Status',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle continue action
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFe83e8c),
//                       ),
//                       child: Text(
//                         'Continue',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Divider(), // Divider line
//                 Text.rich(
//                   TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "The payment of ",
//                         style: TextStyle(color: Colors.black), // Default color for other text
//                       ),
//                       TextSpan(
//                         text: "₹$netPayable",
//                         style: TextStyle(color: Colors.pink,
//                           fontWeight: FontWeight.bold,
//                         ), // Pink color for ₹$netPayable
//                       ),
//                       TextSpan(
//                         text: " you'll make when the delivery arrives with your order.",
//                         style: TextStyle(color: Colors.black), // Default color for other text
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
