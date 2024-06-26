import 'package:flutter/material.dart';

import '../pageUtills/common_appbar.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OrderDeliveredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'My Orders'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Order ID - OD43108436740534100',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Divider(), // Horizontal line below the Order ID
            SizedBox(height: 12),
            _buildOrderItem(),
            SizedBox(height: 20),
            // Additional order details and actions
            // For example, displaying invoice, customer support, etc.
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'mani singh from amahara, po-nikhati kalan, raghunathpue, siwanhihar 841504',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4), // Adjust spacing between product name and size/color
                    Row(
                      children: [
                        Text(
                          'Size: M', // Replace with actual product size
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 8), // Adjust spacing between size and color
                        Text(
                          'Color: Blue', // Replace with actual product color
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200], // Placeholder color for the image
                ),
                child: Image.asset(
                  'assets/image.png', // Path to your image asset
                  fit: BoxFit.cover, // Adjust the image fit as needed
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Adjust spacing between order item and seller name
          Text(
            'Seller: XYZ Seller', // Replace with actual seller name
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4), // Adjust spacing between seller name and price
          Text(
            'Price: \$100.00', // Replace with actual price
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 8), // Inserting a line here
          Divider(), // Adding a line between the price and the end of the order item
          OrderTrackerWidget(isCancelled: false), // Adding the OrderTrackerWidget
        ],
      ),
    );
  }

}







class OrderTrackerWidget extends StatefulWidget {
  final bool isCancelled;

  const OrderTrackerWidget({Key? key, required this.isCancelled}) : super(key: key);

  @override
  _OrderTrackerWidgetState createState() => _OrderTrackerWidgetState();
}

class _OrderTrackerWidgetState extends State<OrderTrackerWidget> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildTrackingItem(Icons.check_circle, 'Placed', '2024-06-05', true),
          _buildVerticalLine(true),
          _buildTrackingItem(Icons.directions_run, 'On the Way', '2024-06-06', true),
          _buildVerticalLine(true),
          _buildTrackingItem(Icons.done, 'Delivered', '2024-06-07', true),
          SizedBox(height: 10),
          if (widget.isCancelled)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVerticalLine(false),
                _buildCancelledTrackingItem(Icons.cancel, 'Cancel', '2024-06-08', false),
                _buildVerticalLine(false),
                _buildCancelledTrackingItem(Icons.loop, 'Return', '2024-06-09', false),
                _buildVerticalLine(false),
                _buildCancelledTrackingItem(Icons.money_off, 'Refund', '2024-06-10', false),
              ],
            ),
          Divider(), // Horizontal line

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showReturnAndRefundDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Return & Refund',
                    style: TextStyle(color: Colors.black87), // Set text color to a darker shade
                  ),
                ),
              ),

              SizedBox(width: 10), // Adjust the width between buttons as needed

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Need Help button press
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjust padding as needed

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child: Text(
                    'Need Help',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Divider(),


          ElevatedButton(
            onPressed: () {
              // Handle Download Invoice button press
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              minimumSize: Size(390, 0), // Set the minimum width
            ),
            child: Text(
              'Download Invoice',
              style: TextStyle(color: Colors.black),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildTrackingItem(IconData icon, String title, String date, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ?Colors.lightGreen : Colors.grey.withOpacity(0.5),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey.withOpacity(0.5),
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isActive ? Colors.black54 : Colors.black,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        Text(
          'Date: $date',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLine(bool isActive, [bool isCancelledOrReturned = false]) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Container(
        width: 5,
        height: isCancelledOrReturned ? 60 : 40,
        color: isActive ? Colors.lightGreen : Colors.grey.withOpacity(1.5),
      ),
    );
  }


  Widget _buildCancelledTrackingItem(IconData icon, String title, String date, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.red : Colors.grey.withOpacity(0.5),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey.withOpacity(0.5),
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isActive ? Colors.red : Colors.black,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        Text(
          'Date: $date',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }


  void _showReturnAndRefundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Return & Refund'),
          content: Text('Choose an option:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showReturnAndRefund(context); // Incorrect line// Handle Return option
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Set border radius to 5 pixels
                ),// Set the primary color to #ED0E87
              ),
              child: Text('Refund',
                style: TextStyle(color: Colors.black),
              ),

            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showReplaceDialog(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
              child: Text('Replace',
                style: TextStyle(color: Colors.black),
              ),

            ),
          ],
        );
      },
    );
  }




  void _showReplaceDialog(BuildContext context) {
    String? selectedReason;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Replace Order'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Reason for Replacement:'),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: Text('Defective product'),
                          value: 'Defective product',
                          groupValue: selectedReason,
                          activeColor: Color(0xFFED1A63),
                          onChanged: (String? value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text('Wrong item received'),
                          value: 'Wrong item received',
                          groupValue: selectedReason,
                          activeColor: Color(0xFFED1A63),
                          onChanged: (String? value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text('Item damaged during shipping'),
                          value: 'Item damaged during shipping',
                          groupValue: selectedReason,
                          activeColor: Color(0xFFED1A63),
                          onChanged: (String? value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text('Order incomplete'),
                          value: 'Order incomplete',
                          groupValue: selectedReason,
                          activeColor: Color(0xFFED1A63),
                          onChanged: (String? value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text('Other'),
                          value: 'Other',
                          groupValue: selectedReason,
                          activeColor: Color(0xFFED1A63),
                          onChanged: (String? value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        labelText: 'Comments',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

                              if (pickedFile != null) {
                                setState(() {
                                  _image = File(pickedFile.path);
                                });
                              }
                            },
                            icon: Icon(
                              Icons.add_photo_alternate, // Replace with appropriate icon
                              size: 50, // Set icon size to 30 pixels
                              color: Color(0xFFED1A63), // Set icon color to #ED1A63
                            ),
                            tooltip: 'Insert Image',
                          ),
                        ),
                        if (_image != null)
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Image.file(
                                _image!,
                                height: 100,
                                width: 100,
                              ),
                            ],
                          ),
                      ],
                    ),



                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFED1A63),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child: Text('Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Replace Order action
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFED1A63),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child: Text('Replace Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}


void _showReturnAndRefund(BuildContext context) {
  String? selectedReason;
  TextEditingController commentController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  File? image;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Center(child: Text('Refund')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Reason for Return:'),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: Text('Item not as described'),
                        value: 'Item not as described',
                        groupValue: selectedReason,
                        activeColor: Color(0xFFED1A63), // Change the color here
                        onChanged: (String? value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),

                      RadioListTile<String>(
                        title: Text('Received damaged item'),
                        value: 'Received damaged item',
                        groupValue: selectedReason,
                        activeColor: Color(0xFFED1A63),
                        onChanged: (String? value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Ordered wrong item'),
                        value: 'Ordered wrong item',
                        groupValue: selectedReason,
                        activeColor: Color(0xFFED1A63),
                        onChanged: (String? value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Item did not fit'),
                        value: 'Item did not fit',
                        groupValue: selectedReason,
                        activeColor: Color(0xFFED1A63),
                        onChanged: (String? value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: 'Comments',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: accountController,
                    decoration: InputDecoration(
                      labelText: 'Account Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ifscController,
                    decoration: InputDecoration(
                      labelText: 'IFSC Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

                            if (pickedFile != null) {
                              setState(() {
                                image = File(pickedFile.path);

                              });
                            }
                          },
                          icon: Icon(
                            Icons.add_photo_alternate, // Replace with appropriate icon
                            size: 50, // Set icon size to 30 pixels
                            color: Color(0xFFED1A63), // Set icon color to #ED1A63
                          ),
                          tooltip: 'Insert Image',
                        ),
                      ),
                      if (image != null)
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Image.file(
                              image!,
                              height: 100,
                              width: 100,
                            ),
                          ],
                        ),
                    ],
                  ),


                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ),

                child: Text('Cancel',
                    style: TextStyle(color: Colors.black)
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle Refund Order action
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ),
                child: Text('Refund Order',
                    style: TextStyle(color: Colors. black)
                ),

              ),
            ],
          );
        },
      );
    },
  );
}



