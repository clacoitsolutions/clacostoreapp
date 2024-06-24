// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'dart:io';
// import 'dart:convert'; // Import dart:convert
//
// // ... [Your CoinPage code remains the same] ...
//
// class BarCodecard extends StatefulWidget {
//   final String name;
//   final String mobile;
//   final String customerId;
//
//   BarCodecard({
//     required this.name,
//     required this.mobile,
//     required this.customerId,
//   });
//
//   @override
//   _CustomerCardState createState() => _CustomerCardState();
// }
//
// class _CustomerCardState extends State<BarCodecard> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _customerIdController = TextEditingController();
//   String? _selectedNumber; // To store the selected dropdown value
//
//   List<String> _dropdownItems = ['1', '2', '3', '4', '5'];
//
//   @override
//   void initState() {
//     super.initState();
//     // Set initial values from the constructor
//     _nameController.text = widget.name;
//     _mobileController.text = widget.mobile;
//     _customerIdController.text = widget.customerId;
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileController.dispose();
//     _customerIdController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4.0,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'Customer Details',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a name';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     controller: _mobileController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: 'Mobile No.',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a mobile number';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     controller: _customerIdController,
//                     decoration: InputDecoration(
//                       labelText: 'Customer ID',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 24.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Dropdown for numbers
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 10.0),
//                         decoration: BoxDecoration(
//                           color: Colors.pinkAccent, // Set hot pink background
//                           borderRadius: BorderRadius.circular(
//                               5.0), // Optional rounded corners
//                         ),
//                         child: DropdownButtonHideUnderline(
//                           // Hide default underline
//                           child: DropdownButton<String>(
//                             value: _selectedNumber,
//                             hint: Text(
//                               'Shared Coin',
//                               style: TextStyle(
//                                   color: Colors.white), // White hint text
//                             ),
//                             dropdownColor: Colors
//                                 .pinkAccent, // Background color of dropdown list
//                             style: TextStyle(
//                                 color: Colors.white), // White text for items
//                             items: _dropdownItems.map((String item) {
//                               return DropdownMenuItem<String>(
//                                 value: item,
//                                 child: Text(item),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 _selectedNumber = newValue!;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       Spacer(), // To push the Share button to the right
//                       // Share button
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             // Process and share the data
//                             String dataToShare =
//                                 'Name: ${_nameController.text}\n'
//                                 'Mobile: ${_mobileController.text}\n'
//                                 'Customer ID: ${_customerIdController.text}\n'
//                                 'Selected Number: $_selectedNumber';
//
//                             // Use a share plugin or custom logic to share 'dataToShare'
//                             // For example, using the 'share_plus' package:
//                             // Share.share(dataToShare);
//                             print(dataToShare);
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Colors.pinkAccent, // Set hot pink background
//                           foregroundColor: Colors.white, // Set white text color
//                         ),
//                         child: Text('Share'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarCodecard extends StatefulWidget {
  final String name;
  final String mobile;
  final String customerId;

  BarCodecard({
    required this.name,
    required this.mobile,
    required this.customerId,
  });

  @override
  _CustomerCardState createState() => _CustomerCardState();
}

class _CustomerCardState extends State<BarCodecard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _customerIdController = TextEditingController();
  String? _selectedNumber;

  List<String> _dropdownItems = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _mobileController.text = widget.mobile;
    _customerIdController.text = widget.customerId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Customer Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile No.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _customerIdController,
                    decoration: InputDecoration(
                      labelText: 'Customer ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedNumber,
                            hint: Text(
                              'Shared Coin',
                              style: TextStyle(color: Colors.white),
                            ),
                            dropdownColor: Colors.pinkAccent,
                            style: TextStyle(color: Colors.white),
                            items: _dropdownItems.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedNumber = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _shareCoin();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareCoin() async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/sharedcoin'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "CustomerID": widget.customerId,
          "ReciverCustomerId": "CUST000473", // Replace with actual recipient ID
          "SelectedValue":
              _selectedNumber ?? '10', // Default to '1' if not selected
        }),
      );

      if (response.statusCode == 200) {
        print('Coin shared successfully');
        print(response.body);
        // Handle success scenario as needed
      } else {
        throw Exception('Failed to share coin');
      }
    } catch (e) {
      print('Error sharing coin: $e');
      // Handle error scenario as needed
    }
  }
}
