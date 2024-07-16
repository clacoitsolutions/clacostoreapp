import 'dart:convert';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:claco_store/Page/deliverystatus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../pageUtills/common_appbar.dart';

class OrderDetailsScreen extends StatefulWidget {
  late final String orderId;
  OrderDetailsScreen({required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String orderId; // Updated to late initialization
  late SharedPreferences prefs; // Add this line for SharedPreferences

  bool isCancelled = false;
  double rating = 0;
  List<Map<String, dynamic>> orderItems = [];
  String? deliveryStatus;
  List<StepperData> stepData = [];
  int activeStep = 0;

  @override
  void initState() {
    super.initState();
    orderId = widget.orderId; // Initialize orderId from widget parameter
    _fetchOrderDetails(orderId); // Fetch order details for initial orderId
    _loadOrderId(); // Load order ID from SharedPreferences
  }

  Future<void> _loadOrderId() async {
    prefs = await SharedPreferences.getInstance();
    // Get order ID from arguments
    orderId = prefs.getString('orderId') ??
        ''; // Assuming 'orderId' is stored as a String
    _fetchOrderDetails(orderId); // Fetch order details for initial orderId
    setState(() {
      deliveryStatus = prefs.getString('deliveryStatus');
    });
  }

  Future<void> _fetchOrderDetails(String orderId) async {
    var apiUrl = 'https://clacostoreapi.onrender.com/clickorderdetails';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          orderItems = List<Map<String, dynamic>>.from(jsonData['orderItems']);
          if (orderItems.isNotEmpty) {
            deliveryStatus =
                orderItems[0]['DeliveryStatus']?.toLowerCase() ?? 'placed';
            activeStep = _getOrderStatusIndex(deliveryStatus!);
            _updateOrderStatus(
                deliveryStatus!); // Update the UI with new status
          }
        });
        // Save the status to SharedPreferences
        prefs.setString('deliveryStatus', deliveryStatus!);
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  // Helper function to get the index of the delivery status
  int _getOrderStatusIndex(String status) {
    List<String> orderStatuses = [
      'Placed',
      'Packed', // Assuming "Packed" is a status
      'On the Way',
      'Delivered'
    ];
    return orderStatuses.indexOf(status);
  }

  void _updateOrderStatus(String status) {
    setState(() {
      switch (status.toLowerCase()) {
        case 'placed':
          stepData = [
            StepperData(
              title: StepperText("Order Placed"),
              subtitle: StepperText("Your order has been placed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Packed"),
              subtitle: StepperText("Your order has been packed."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            StepperData(
              title: StepperText("On the Way"),
              subtitle: StepperText("Your order is on the way."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            StepperData(
              title: StepperText("Delivered"),
              subtitle: StepperText("Your order has been delivered."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            //   StepperData(
            //     title: StepperText("Returned"),
            //     subtitle: StepperText("Your order has been returned."),
            //     iconWidget:
            //         Icon(Icons.radio_button_unchecked, color: Colors.grey),
            //   ),
            //   StepperData(
            //     title: StepperText("Cancelled"),
            //     subtitle: StepperText("Your order has been cancelled."),
            //     iconWidget:
            //         Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ];
          break;
        case 'ontheway':
          stepData = [
            StepperData(
              title: StepperText("Order Placed"),
              subtitle: StepperText("Your order has been placed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Packed"),
              subtitle: StepperText("Your order has been packed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("On the Way"),
              subtitle: StepperText("Your order is on the way."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            // StepperData(
            //   title: StepperText("Delivered"),
            //   subtitle: StepperText("Your order has been delivered."),
            //   iconWidget:
            //       Icon(Icons.radio_button_unchecked, color: Colors.grey),
            // ),
            // StepperData(
            //   title: StepperText("Returned"),
            //   subtitle: StepperText("Your order has been returned."),
            //   iconWidget:
            //       Icon(Icons.radio_button_unchecked, color: Colors.grey),
            // ),
            // StepperData(
            //   title: StepperText("Cancelled"),
            //   subtitle: StepperText("Your order has been cancelled."),
            //   iconWidget:
            //       Icon(Icons.radio_button_unchecked, color: Colors.grey),
            // ),
          ];
          break;
        case 'delivered':
          stepData = [
            StepperData(
              title: StepperText("Order Placed"),
              subtitle: StepperText("Your order has been placed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Packed"),
              subtitle: StepperText("Your order has been packed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("On the Way"),
              subtitle: StepperText("Your order is on the way."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Delivered"),
              subtitle: StepperText("Your order has been delivered."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            // StepperData(
            //   title: StepperText("Returned"),
            //   subtitle: StepperText("Your order has been returned."),
            //   iconWidget:
            //       Icon(Icons.radio_button_unchecked, color: Colors.grey),
            // ),
            // StepperData(
            //   title: StepperText("Cancelled"),
            //   subtitle: StepperText("Your order has been cancelled."),
            //   iconWidget:
            //       Icon(Icons.radio_button_unchecked, color: Colors.grey),
            // ),
          ];
          break;
        case 'returned':
          stepData = [
            StepperData(
              title: StepperText("Order Placed"),
              subtitle: StepperText("Your order has been placed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Packed"),
              subtitle: StepperText("Your order has been packed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("On the Way"),
              subtitle: StepperText("Your order is on the way."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Delivered"),
              subtitle: StepperText("Your order has been delivered."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Returned"),
              subtitle: StepperText("Your order has been returned."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Cancelled"),
              subtitle: StepperText("Your order has been cancelled."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
          ];
          break;
        case 'cancelled':
          stepData = [
            StepperData(
              title: StepperText("Order Placed"),
              subtitle: StepperText("Your order has been placed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            // StepperData(
            //   title: StepperText("Packed"),
            //   subtitle: StepperText("Your order has been packed."),
            //   iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            // ),
            // StepperData(
            //   title: StepperText("On the Way"),
            //   subtitle: StepperText("Your order is on the way."),
            //   iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            // ),
            // StepperData(
            //   title: StepperText("Delivered"),
            //   subtitle: StepperText("Your order has been delivered."),
            //   iconWidget:
            //       Icon(Icons.radio_button_unchecked, color: Colors.grey),
            // ),
            // StepperData(
            //   title: StepperText("Returned"),
            //   subtitle: StepperText("Your order has been returned."),
            //   iconWidget:
            //       Icon(Icons.radio_button_unchecked, color: Colors.grey),
            // ),
            StepperData(
              title: StepperText("Cancelled"),
              subtitle: StepperText("Your order has been cancelled."),
              iconWidget: Icon(Icons.cancel, color: Colors.red),
            ),
          ];
          break;
        default:
        // Default to initial status if none matches
          stepData = [
            StepperData(
              title: StepperText("Order Placed"),
              subtitle: StepperText("Your order has been placed."),
              iconWidget: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            StepperData(
              title: StepperText("Packed"),
              subtitle: StepperText("Your order has been packed."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            StepperData(
              title: StepperText("On the Way"),
              subtitle: StepperText("Your order is on the way."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            StepperData(
              title: StepperText("Delivered"),
              subtitle: StepperText("Your order has been delivered."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            StepperData(
              title: StepperText("Returned"),
              subtitle: StepperText("Your order has been returned."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            StepperData(
              title: StepperText("Cancelled"),
              subtitle: StepperText("Your order has been cancelled."),
              iconWidget:
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
          ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Order Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Order ID - ${orderId ?? 'Loading...'}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                var item = orderItems[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.network(
                            item['ProductMainImageUrl'],
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['ProductName'].length > 20
                                    ? '${item['ProductName'].substring(0, 20)}...'
                                    : item['ProductName'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                ' ₹${item['TotalAmount'] ?? 'NA'}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Quantity: ${item['Quantity']}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Tracking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // Navigate to deliveryStatus page here
                      // You'll need to define your deliveryStatus page and pass the status
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Deliverystatus(
                            status: deliveryStatus ??
                                '', // Pass the current deliveryStatus
                          ),
                        ),
                      );
                    },
                    child: AnotherStepper(
                      stepperList: stepData,
                      stepperDirection: Axis.vertical,
                      // iconWidth: 40,
                      // iconHeight: 40,
                      activeBarColor: Colors.green,
                      inActiveBarColor: Colors.grey,
                      inverted: false,
                      verticalGap: 20,
                      // horizontalGap: 20,
                      // animationDuration: 500,
                      activeIndex: activeStep,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: deliveryStatus != 'delivered' &&
                  deliveryStatus != 'cancelled',
              child: InkWell(
                onTap: () {
                  _showCancelOrderDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Cancel Order',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
                color: Color(0xFFF5F5F5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      'Shipping details',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          orderItems.isNotEmpty
                              ? orderItems[0]['CustomerName'] ?? 'Loading...'
                              : 'Loading...',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ), // Add space between name and mobile number
                      SizedBox(
                          width:
                          10), // Add space between name and mobile number
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 60), // Add right padding to Mobile No
                        child: Text(
                          orderItems.isNotEmpty
                              ? orderItems[0]['CustomerMobile'] ?? 'Loading...'
                              : 'Loading...',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  _buildShippingDetail(
                    'Address:',
                    orderItems.isNotEmpty
                        ? orderItems[0]['CustomerAddress'] ?? 'Loading...'
                        : 'Loading...',
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
                color: Color(0xFFF5F5F5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      'Payment details',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShippingDetail(
                    'Payment Method:',
                    orderItems.isNotEmpty
                        ? orderItems[0]['PaymentMode'] ?? 'Loading...'
                        : 'Loading...',
                  ),
                  _buildShippingDetail(
                    'Delivery',
                    orderItems.isNotEmpty
                        ? orderItems[0]['DeliveryTime'] ?? 'Fast'
                        : 'Fast',
                  ),
                  _buildShippingDetail(
                    'Delivery Charges:',
                    orderItems.isNotEmpty
                        ? orderItems[0]['DeliveryCharges'].toString() ??
                        'Loading...'
                        : 'Loading...',
                  ),
                  _buildDivider(),
                  _buildShippingDetailprice(
                    'Gross Amount:',
                    orderItems.isNotEmpty
                        ? orderItems[0]['TotalAmount'].toString() ??
                        'Loading...'
                        : 'Loading...',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetailprice(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 10),
              Text(
                '₹ $value',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.grey,
        height: 1,
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancel Order"),
          content: Text("Are you sure you want to cancel this order?"),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("CONFIRM"),
              onPressed: () {
                setState(() {
                  isCancelled = true;
                  _updateOrderStatus('cancelled');
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
