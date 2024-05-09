import 'package:flutter/material.dart';

import '../pageUtills/add_address_form.dart';
import '../pageUtills/common_appbar.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Address'),
      body: Container(
        color: Colors.grey[200] , // Set background color to gray
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.zero, // Set padding to zero
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to the add address form page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddAddressFormPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.blue),
                        label: Text(
                          'Add Address',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),



                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 3, // Add elevation for a shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Set border radius
                    ),
                    color: Colors.white, // Set card background color to white
                    child: Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: mani singh'),
                              SizedBox(height: 8),
                              Text('Road Name: Rajput Marg'),
                              SizedBox(height: 8),
                              Text('House Number: 7'),
                              SizedBox(height: 8),
                              Text('City: Siwan'),
                              SizedBox(height: 8),
                              Text('State: Bihar'),
                              SizedBox(height: 8),
                              Text('Pincode: 841504'),
                              SizedBox(height: 8),
                              Text('Phone Number: 979-871-3528'), // Add phone number information here
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert), // Three dots icon
                            onSelected: (value) {
                              // Handle menu item selection
                              if (value == 'edit') {
                                // TODO: Implement edit functionality
                              } else if (value == 'remove') {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmation"),
                                      content: Text("Are you sure you want to remove this address?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // TODO: Implement remove functionality
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'remove',
                                child: Text('Remove'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),




              ],
            ),
          ),
        ),
      ),
    );
  }
}

