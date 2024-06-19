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

  @override
  void initState() {
    super.initState();
    futureAddresses = fetchAddresses();
    initSharedPreferences();
  }

  // Initialize SharedPreferences instance
  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Function to save SrNo and CustomerId to SharedPreferences
  Future<void> saveDataToSharedPreferences(String srNo, String customerId) async {
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

  // Function to call API to change delivery status
  Future<void> _changeDeliveryStatus(String srNo, String customerId) async {
    try {
      final url = Uri.parse('https://clacostoreapi.onrender.com/ChangeDeliveryCurrentstatus1');
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
          MaterialPageRoute(builder: (context) => Checkout()), // Replace with your checkout page
        );
      } else {
        // API call failed
        print('API Error: ${response.statusCode}');
        // Show error message using snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update delivery status. Please try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Exception occurred during API call
      print('Exception: $e');
      // Show error message using snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please check your internet connection and try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: CommonAppBar(title: 'Address'),
      body: Container(
        color: Colors.grey[200],
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
                      padding: EdgeInsets.zero,
                      child: ElevatedButton.icon(
                        onPressed: () {
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
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final address = snapshot.data![index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              color: selectedAddressIndex == index ? Colors.white : Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedAddressIndex = index; // Update selected index
                                  });
                                  // Call function to save SrNo and CustomerId to SharedPreferences
                                  saveDataToSharedPreferences(address.srNo, address.customerCode);
                                  // Call function to change delivery status via API
                                  _changeDeliveryStatus(address.srNo, address.customerCode);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Name: ${address.name}'),
                                          SizedBox(height: 8),
                                          Text('Road Name: ${address.address}'),
                                          SizedBox(height: 8),
                                          Text('House Number: ${address.address}'),
                                          SizedBox(height: 8),
                                          Text('City: ${address.cityName}'),
                                          SizedBox(height: 8),
                                          Text('State: ${address.stateId}'),
                                          SizedBox(height: 8),
                                          Text('Pincode: ${address.pinCode}'),
                                          SizedBox(height: 8),
                                          Text('Phone Number: ${address.mobileNo}'),
                                        ],
                                      ),
                                      Radio(
                                        value: index,
                                        groupValue: selectedAddressIndex,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedAddressIndex = value as int; // Update selected index
                                          });
                                          // Call function to save SrNo and CustomerId to SharedPreferences
                                          saveDataToSharedPreferences(address.srNo, address.customerCode);
                                          // Call function to change delivery status via API
                                          _changeDeliveryStatus(address.srNo, address.customerCode);
                                        },
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
