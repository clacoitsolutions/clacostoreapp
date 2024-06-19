import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_appbar.dart';
import '../pageUtills/invoice.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'OrderDetails'),
      body: OrderDetailsScreen(),
      bottomNavigationBar: CustomBottomNavigationBar(context: context),
    );
  }
}

class OrderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? selectedReason; // Variable to hold the selected cancellation reason
  bool isCancelled = false; // Flag to track if the order is cancelled
  double rating = 0; // Variable to hold the star rating
  Map<String, dynamic>? orderDetails;
  bool isLoading = true; // Variable to track loading state

  final TextEditingController _cancelReasonController = TextEditingController();

  void _showCancelOrderDialog(BuildContext context, String orderId, String initialReason) {
    _cancelReasonController.text = initialReason;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: Color(0xFFe83e8c), // Set header background color to pink
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cancel Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,// Set header text color to white
                  ),
                ),
                Text(
                  //'Order ID: $orderId', // Display order ID dynamically
                  'Order ID: ORD101001116',
                  style: TextStyle(
                    color: Colors.white, // Set header text color to white
                    fontSize: 12, // Set font size to 15
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _cancelReasonController,
                decoration: InputDecoration(
                  labelText: 'Cancel Reason',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _cancelOrder(orderId, _cancelReasonController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFe83e8c), // Set button background color to pink
                ),
                child: Text(
                  'Proceed',
                  style: TextStyle(
                    color: Colors.white, // Set button text color to white
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _cancelOrder(String orderId, String cancelReason) async {
    final String apiUrl = 'https://clacostoreapi.onrender.com/CancelOrder';
    final Map<String, dynamic> body = {
      // 'OrderId': orderId,
      // 'CancelReason': cancelReason,
      'OrderId': 'ORD101001116',
      'CancelReason': cancelReason,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      final String message = responseData['message'];
      final String serverMessage = responseData['data'][0]['msg'];

      print('Response: $message - $serverMessage'); // Print response to console

      Navigator.of(context).pop(); // Close the dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Response: $message - $serverMessage')),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    fetchOrderDetails(); // Fetch order details when screen initializes
  }

  Future<void> fetchOrderDetails() async {
    final apiUrl = 'https://clacostoreapi.onrender.com/getOrderConfirm';
    final body = jsonEncode({"OrderID": "ORD101001092"});

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
          setState(() {
            orderDetails = jsonData['data'][0];
            isLoading = false; // Set loading to false when data is fetched
          });
        } else {
          setState(() {
            isLoading = false; // Set loading to false even if no data is found
          });
          print('No order details found.');
        }
      } else {
        setState(() {
          isLoading = false; // Set loading to false on failure
        });
        print('Failed to load order details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false on error
      });
      print('Error fetching order details: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : orderDetails == null
          ? Center(child: Text('No order details found.')) // Show message if no details found
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Order ID - ${orderDetails!['OrderId']}',
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/kurti1.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fancy Kurti Black , Gold',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Size: L , Color: Black',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Seller: STIPVTLTD',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Quantity: 1',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '₹350',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Tracking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildTrackingItem('Placed', true),
                  _buildVerticalLine(true),
                  _buildTrackingItem('On the Way', false),
                  _buildVerticalLine(true),
                  _buildTrackingItem('Delivered', false),
                  _buildVerticalLine(false),
                  isCancelled
                      ? _buildTrackingItem('Cancel', false)
                      : SizedBox.shrink(),
                  _buildVerticalLine(false, isCancelled),
                  isCancelled
                      ? _buildTrackingItem('Return', false)
                      : SizedBox.shrink(),
                  _buildVerticalLine(false, isCancelled),
                  isCancelled
                      ? _buildTrackingItem('Refund', false)
                      : SizedBox.shrink(),
                  _buildVerticalLine(false, isCancelled),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // InkWell(
            //   onTap: () {
            //     _showCancelOrderDialog(context);
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: Text(
            //       'Cancel Order',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 20,
            //       ),
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                _showCancelOrderDialog(context, 'ORD101001092', 'Aise hi');
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0), // Add left padding here
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFe83e8c), // Set background color to pink
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Cancel Order',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                ),
              ),
            ),


          SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5), // Background color
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                        (index) => IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: index < rating ? Colors.green : Colors.grey,
                        size: 44, // Set star size to 24
                      ),
                      onPressed: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat,
                  size: 30,
                  color: Colors.pinkAccent,
                ),
                SizedBox(width: 10),
                Text(
                  'Need help?',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Navigate to invoice page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvoicePage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.chat,color: Colors.pinkAccent,),
                        // Added icon for invoice download
                        SizedBox(width: 5),

                        Text(
                          'Invoice download',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 20.0), // Add some right padding
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 26,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
                color: Color(0xFFF5F5F5), // Background color
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      'Shipping details',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${orderDetails!['Name']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Address: ${orderDetails!['Address']}'),
                        Text('Mobile No: ${orderDetails!['MobileNo']}'),

                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
                color: Color(0xFFF5F5F5), // Background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      'Price Details',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'List Price',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '₹499',
                          style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric( vertical: 10,horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discounted Price',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '₹199',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Extra 15% off upto ₹100',
                          style: TextStyle(fontSize: 16,),
                        ),
                        Text(
                          '- ₹30',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),

                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${orderDetails!['NetPayable'].toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
                color: Color(0xFFF5F5F5), // Background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black, // Changed to black
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  // Navigate to invoice page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvoicePage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        ' Cash On Delivery : ₹169.0',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: _buildProductCard('assets/images/saree.png', 'Mouni Roy Black Saree For Farewell ', '4.5', '₹1550'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildProductCard('assets/images/saree1.png', 'Black Georgette Saree With Full Heavy', '4.5', '₹2050'),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String imagePath, String productName, String rating, String price) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.green),
                    SizedBox(width: 5),
                    Text(
                      rating,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingItem(String status, bool isActive) {
    List<String> displayStatuses = ['Placed', 'On the Way', 'Delivered'];

    if (displayStatuses.contains(status)) {
      if (status == 'Cancel' && !isCancelled) {
        return SizedBox.shrink();
      } else if (status == 'Delivered' && isCancelled) {
        return SizedBox.shrink();
      } else {
        return Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.green : Colors.grey[300],
              ),
              child: isActive ? Icon(Icons.check, color: Colors.white) : null, // Add a white hole in the center
            ),
            SizedBox(width: 10),
            Text(
              status,
              style: TextStyle(
                fontSize: 21,
                color: isActive ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildVerticalLine(bool isActive, [bool isCancelledOrReturned = false]) {
    Color lineColor = isCancelledOrReturned ? Colors.red : Colors.green;

    if (isActive && !isCancelledOrReturned) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          height: 70,
          width: 5,
          color:Colors.grey,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  //
  // void _showCancelOrderDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text("Cancel Order"),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("Select a reason for cancellation:"),
  //                 SizedBox(height: 10),
  //                 _buildCancellationOption(context, "Item not needed", setState),
  //                 _buildCancellationOption(context, "Found better price elsewhere", setState),
  //                 _buildCancellationOption(context, "Delivery delayed", setState),
  //                 _buildCancellationOption(context, "Other", setState),
  //               ],
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text("Cancel"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   if (selectedReason != null) {
  //                     print("Selected Reason: $selectedReason");
  //                     if (selectedReason == "Item not needed") {
  //                       setState(() {
  //                         isCancelled = true;
  //                       });
  //                     }
  //                   } else {
  //                     print("Please select a reason for cancellation");
  //                   }
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text("OK"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }


  Widget _buildCancellationOption(BuildContext context, String option, Function(void Function()) setState) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedReason = option;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Radio<bool>(
              value: selectedReason == option,
              groupValue: true,
              onChanged: (bool? value) {
                setState(() {
                  selectedReason = option;
                });
              },
            ),
            Text(option),
          ],
        ),
      ),
    );
  }
}



void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OrderDetailsPage(),
  ));
}
