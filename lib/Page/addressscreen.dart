import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Api services/Add_address_api.dart';
import '../models/Add_address_model.dart';
import '../pageUtills/add_address_form.dart';
import '../pageUtills/common_appbar.dart';
import 'home/Chekout_page.dart'; // Import your checkout page

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late Future<List<ShowAddress>> futureAddresses;
  int selectedAddressIndex = -1; // Track selected address index
  late SharedPreferences prefs; // SharedPreferences instance
  List<ShowAddress> addresses = []; // List to store addresses

  @override
  void initState() {
    super.initState();
    futureAddresses = fetchAddresses();
    initSharedPreferences();
    loadAddressesFromSharedPreferences(); // Load from SharedPreferences on init
  }

  // Initialize SharedPreferences instance
  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Function to save SrNo and CustomerId to SharedPreferences
  Future<void> saveDataToSharedPreferences(
      String srNo, String customerId) async {
    await prefs.setString('SrNo', srNo);
    await prefs.setString('CustomerCode', customerId);
  }

  // Function to fetch SrNo from SharedPreferences
  String? getStoredSrNo() {
    return prefs.getString('SrNo');
  }

  // Function to fetch CustomerId from SharedPreferences
  String? getStoredCustomerId() {
    return prefs.getString('CustomerCode') ?? '';
  }

  // Function to load addresses from SharedPreferences
  void loadAddressesFromSharedPreferences() async {
    final storedAddresses = prefs.getStringList('addresses');
    if (storedAddresses != null) {
      setState(() {
        addresses = storedAddresses.map((address) {
          final addressMap = jsonDecode(address) as Map<String, dynamic>;
          return ShowAddress.fromJson(addressMap);
        }).toList();
      });
    }
  }

  // Function to save addresses to SharedPreferences
  void saveAddressesToSharedPreferences() async {
    final encodedAddresses =
    addresses.map((address) => jsonEncode(address.toJson())).toList();
    await prefs.setStringList('addresses', encodedAddresses);
  }

  // Function to call API to change delivery status
  Future<void> _changeDeliveryStatus(String srNo, String customerId) async {
    try {
      final url = Uri.parse(
          'https://clacostoreapi.onrender.com/ChangeDeliveryCurrentstatus1');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'srno': srNo.toString(),
          'CustomerId': customerId,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully called API
        print('API Response: ${response.body}');
        // Show success message using snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delivery status updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to checkout page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Checkout()), // Replace with your checkout page
        );
      } else {
        // API call failed
        print('API Error: ${response.statusCode}');
        // Show error message using snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text('Failed to update delivery status. Please try again later.'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      // Exception occurred during API call
      print('Exception: $e');
      // Show error message using snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'An error occurred. Please check your internet connection and try again.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Address',
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Add Address Button
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddAddressFormPage(),
                            ),
                          ).then((value) {
                            // Refresh the address list after adding a new address
                            setState(() {
                              futureAddresses = fetchAddresses();
                              loadAddressesFromSharedPreferences(); // Reload from SharedPreferences
                            });
                          });
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
                // Display Addresses
                Expanded(
                  child: FutureBuilder<List<ShowAddress>>(
                    future: futureAddresses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No addresses found.'));
                      } else {
                        // Update 'addresses' list with data from the API
                        addresses = snapshot.data!;
                        saveAddressesToSharedPreferences(); // Save to SharedPreferences

                        return ListView.builder(
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              color: selectedAddressIndex == index
                                  ? Colors.white
                                  : Colors
                                  .white, // You may adjust the colors based on your UI design
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedAddressIndex =
                                        index; // Update selected index
                                  });
                                  // Call function to save SrNo and CustomerId to SharedPreferences
                                  saveDataToSharedPreferences(
                                      address.srNo, address.customerCode);
                                  // Call function to change delivery status via API
                                  _changeDeliveryStatus(
                                      address.srNo, address.customerCode);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Name and Phone Number row
                                      // First  row for Name, Phone Number, Landmark, City Name, State ID, Pincode
                                      Row(
                                        children: [
                                          Text(
                                            '${address.name}, ${address.mobileNo}, ${address.landmark}, ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // Second  row  City Name, State ID, Pincode
                                      Row(
                                        children: [
                                          Text(
                                            '${address.landmark},${address.cityName},',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      // Second  row  City Name, State ID, Pincode
                                      Row(
                                        children: [
                                          Text(
                                            '${address.stateId}, ${address.pinCode}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                            256.0), // Adjust the padding as needed
                                        child: Radio(
                                          value: index,
                                          groupValue: selectedAddressIndex,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedAddressIndex = value
                                              as int; // Update selected index
                                            });
                                            // Call function to save SrNo and CustomerId to SharedPreferences
                                            saveDataToSharedPreferences(
                                                address.srNo,
                                                address.customerCode);
                                            // Call function to change delivery status via API
                                            _changeDeliveryStatus(address.srNo,
                                                address.customerCode);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
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
