import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Api services/Add_address_api.dart';
import '../Page/addressscreen.dart';
import '../models/Add_address_model.dart';

class AddAddressFormPage extends StatefulWidget {
  const AddAddressFormPage({Key? key}) : super(key: key);

  @override
  _AddAddressFormPageState createState() => _AddAddressFormPageState();
}

class _AddAddressFormPageState extends State<AddAddressFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _localityController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _alternativeMobileNoController = TextEditingController();
  final _offerTypeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _address2Controller = TextEditingController();

  List<Map<String, String>> _states = [];
  List<Map<String, String>> _cities = [];
  String? _selectedState;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  Future<void> _fetchStates() async {
    try {
      final states = await APIService.fetchStates();
      setState(() {
        _states = states;
      });
    } catch (e) {
      print('Failed to load states: $e');
    }
  }

  Future<void> _fetchCities(String stateId) async {
    try {
      final cities = await APIService.fetchCities(int.parse(stateId));
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      print('Failed to load cities: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load cities. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final address = Address(
        customerCode: 'CUST000394',
        name: _nameController.text,
        mobileNo: _mobileNoController.text,
        pinCode: _pinCodeController.text,
        locality: _localityController.text,
        address: _addressController.text,
        stateId: _selectedState ?? '',
        cityId: _selectedCity ?? '',
        landmark: _landmarkController.text,
        alternativeMobileNo: _alternativeMobileNoController.text,
        offerType: _offerTypeController.text,
        latitude: _latitudeController.text,
        longitude: _longitudeController.text,
        address2: _address2Controller.text,
      );

      try {
        final response = await APIService.insertAddress(address);


        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          final message = responseBody['message'] ?? 'Address added successfully!';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          // Navigate to AddAddressPage after successful insertion
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddAddressPage()),
          );
        } else {
          final responseBody = jsonDecode(response.body);
          final message = responseBody['message'] ?? 'Failed to add address!';
          print('Failed with status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddAddressPage()),
          );
        }
      } catch (e) {
        print('Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred! Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
        'Add Shopping',
        style: TextStyle(
        color: Colors.white, // Text color white
    ),
    ),
    backgroundColor: Colors.pink, // Background color blue
    iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
    actions: [
    IconButton(
    onPressed: () {
    // Implement search functionality
    },
    icon: Icon(Icons.search),
    color: Colors.white,
    ),
    IconButton(
    onPressed: () {
    // Implement add-to-cart functionality
    },
    icon: Icon(Icons.shopping_cart),
    color: Colors.white,
    ),
    ],
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(14.0),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
    // Name Field
    TextFormField(
    controller: _nameController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
    labelText: 'Enter Name',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your name';
    }
    return null;
    },
    ),
    SizedBox(height: 12), // Adding some spacing between fields
    // Mobile Number Field

      TextFormField(
        controller: _mobileNoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Enter Mobile Number',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your mobile number';
          }
          return null;
        },
      ),
      SizedBox(height: 12), // Adding some spacing between fields
      // Pincode and Use My Location
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _pinCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Pincode',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your pincode';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 12), // Adding some spacing between fields
          ElevatedButton(
            onPressed: () {
              // TODO: Implement action to use current location
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[500], // Set button background color to pink
            ),
            child: Text(
              'Use My Location',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
          ),
        ],
      ),
      SizedBox(height: 12), // Adding some spacing between fields
      // State Dropdown and City Field
      Row(
        children: [
          Expanded(
            child:DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select State',
                border: OutlineInputBorder(),
              ),
              value: _selectedState,
              isExpanded: true,
              items: _states.map<DropdownMenuItem<String>>((state) {
                return DropdownMenuItem<String>(
                  value: state['State_id'],
                  child: Text(
                    state['State_name']!,
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedCity = null; // Reset selected city when state changes
                });
                if (value != null) {
                  _fetchCities(value); // Pass selected state ID as String
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a state';
                }
                return null;
              },
            ),


          ),
          SizedBox(width: 12), // Adding some spacing between fields
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select City',
                border: OutlineInputBorder(),
              ),
              value: _selectedCity,
              isExpanded: true, // To make the dropdown width less than the input box
              items: _cities.map<DropdownMenuItem<String>>((city) {
                return DropdownMenuItem<String>(
                  value: city['City_id'],
                  child: Text(
                    city['City_name']!,
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a city';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 12), // Adding some spacing between fields
      // House Number Field
      TextFormField(
        controller: _addressController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'House No.',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your house number';
          }
          return null;
        },
      ),
      SizedBox(height: 12), // Adding some spacing between fields
      // Road Name Field
      TextFormField(
        controller: _address2Controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Road Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your road name';
          }
          return null;
        },
      ),
      SizedBox(height: 12), // Adding some spacing between fields
      // Alternative Phone Number Field
      TextFormField(
        controller: _alternativeMobileNoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Alternative Phone Number',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your alternative phone number';
          }
          return null;
        },
      ),
      SizedBox(height: 12), // Adding some spacing between fields
      TextFormField(
        controller: _landmarkController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Add Nearby Famous Shop/Mall/Landmark',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a landmark';
          }
          return null;
        },
      ),
      SizedBox(height: 12), // Row for buttons
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home button with home icon and text
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement functionality for home icon button
                  },
                  icon: Icon(Icons.home),
                ),
              ),
              Text('Home'),
            ],
          ),
          // Work button with work icon and text
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement functionality for work icon button
                  },
                  icon: Icon(Icons.work),
                ),
              ),
              Text('Work'),
            ],
          ),
          // Another icon button
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement functionality for another icon button
                  },
                  icon: Icon(Icons.ac_unit), // Corrected the icon name to demonstrate
                ),
              ),
              Text('Another'),
            ],
          ),
        ],
      ),
      SizedBox(height: 12), // Adding some spacing between fields
      // Save Address Button
      ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.pink, // Set button color to orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2), // Set border radius to 2 pixels
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17,
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
