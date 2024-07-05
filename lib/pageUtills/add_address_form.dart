import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import '../Api services/Add_address_api.dart';
import '../Page/addressscreen.dart';
import '../models/Add_address_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences

class AddAddressFormPage extends StatefulWidget {
  const AddAddressFormPage({Key? key}) : super(key: key);

  @override
  _AddAddressFormPageState createState() => _AddAddressFormPageState();
}

class _AddAddressFormPageState extends State<AddAddressFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _srNo = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _localityController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _alternativeMobileNoController = TextEditingController();
  // final _offerTypeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _address2Controller = TextEditingController();
  final _StateController = TextEditingController();
  final _CityController = TextEditingController();

  List<Map<String, String>> _states = [];
  List<Map<String, String>> _cities = [];
  String _selectedState = '';
  String _selectedCity = '';

  Location location = Location();
  LocationData? _currentLocation;
  String? _customerCode;

  List<ShowAddress> addresses = [];

  @override
  void initState() {
    super.initState();
    _fetchStates();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _mobileNoController.text = prefs.getString('mobileNo') ?? '';
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied.');
        }
      }

      LocationData locationData = await location.getLocation();
      _updateAddressFields(locationData); // Update fields using Google Maps API
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateAddressFields(LocationData locationData) async {
    final apiKey =
        'AIzaSyAl1R0a3KP6a5VUwtQvQPQZ8wFKjwxpREs'; // Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final results = decoded['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final address = results[0]['formatted_address'];
        final addressComponents =
            results[0]['address_components'] as List<dynamic>;

        // Extracting the landmark from the address string
        final landmark = address!.split(',')[0].trim();

        setState(() {
          _selectedState = _getAddressComponentValue(
              addressComponents, 'administrative_area_level_1');
          _selectedCity =
              _getAddressComponentValue(addressComponents, 'locality');
          _pinCodeController.text =
              _getAddressComponentValue(addressComponents, 'postal_code');
          _address2Controller.text =
              _getAddressComponentValue(addressComponents, 'locality');
          _CityController.text = _selectedCity;
          _StateController.text = _selectedState;
          _landmarkController.text =
              landmark; // Set the landmark in the controller

          // Update other fields as needed...
        });
      }
    } else {
      throw Exception('Failed to fetch address details.');
    }
  }

  String _getAddressComponentValue(
      List<dynamic> addressComponents, String type) {
    final component = addressComponents.firstWhere(
        (component) => component['types'].contains(type),
        orElse: () => null);
    return component != null ? component['long_name'] as String : '';
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
        //   offerType: _offerTypeController.text,
        latitude: _latitudeController.text,
        longitude: _longitudeController.text,
        address2: _address2Controller.text,
      );

      try {
        final response = await APIService.insertAddress(address);

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          final message =
              responseBody['message'] ?? 'Address added successfully!';
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
        iconTheme:
            IconThemeData(color: Colors.white), // Set back arrow color to white
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
                      onPressed: _getCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .pink[500], // Set button background color to pink
                      ),
                      child: Text(
                        'Use My Location',
                        style: TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12), // Adding some spacing between fields
                // State Dropdown and City Field
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Enter State', // Updated label
                          border: OutlineInputBorder(),
                        ),
                        controller:
                            _StateController, // Add a controller for the city
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a city'; // Updated validation message
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Enter City ', // Updated label
                          border: OutlineInputBorder(),
                        ),
                        controller:
                            _CityController, // Add a controller for the other city
                        // You can add a validator if required, but it's optional for this field
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
                  controller: _landmarkController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Landmark',
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
                  controller: _addressController,
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
                            icon: Icon(Icons
                                .ac_unit), // Corrected the icon name to demonstrate
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
                      borderRadius: BorderRadius.circular(
                          2), // Set border radius to 2 pixels
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
// import '../Api services/Add_address_api.dart';
// import '../Page/addressscreen.dart';
// import '../models/Add_address_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AddAddressFormPage extends StatefulWidget {
//   const AddAddressFormPage({Key? key}) : super(key: key);
//
//   @override
//   _AddAddressFormPageState createState() => _AddAddressFormPageState();
// }
//
// class _AddAddressFormPageState extends State<AddAddressFormPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _srNo = TextEditingController();
//   final _nameController = TextEditingController();
//   final _mobileNoController = TextEditingController();
//   final _pinCodeController = TextEditingController();
//   final _localityController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _landmarkController = TextEditingController();
//   final _alternativeMobileNoController = TextEditingController();
//   final _latitudeController = TextEditingController();
//   final _longitudeController = TextEditingController();
//   final _address2Controller = TextEditingController();
//   final _StateController = TextEditingController();
//   final _CityController = TextEditingController();
//
//   List<Map<String, String>> _states = [];
//   List<Map<String, String>> _cities = [];
//   String _selectedState = '';
//   String _selectedCity = '';
//
//   Location location = Location();
//   LocationData? _currentLocation;
//   String? _customerCode;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchStates();
//     _loadUserData();
//     fetchAddresses();
//
//     // Add listeners to automatically submit form data on changes
//     _nameController.addListener(_automaticSubmit);
//     _mobileNoController.addListener(_automaticSubmit);
//     _pinCodeController.addListener(_automaticSubmit);
//     _localityController.addListener(_automaticSubmit);
//     _addressController.addListener(_automaticSubmit);
//     _landmarkController.addListener(_automaticSubmit);
//     _alternativeMobileNoController.addListener(_automaticSubmit);
//     _latitudeController.addListener(_automaticSubmit);
//     _longitudeController.addListener(_automaticSubmit);
//     _address2Controller.addListener(_automaticSubmit);
//     _StateController.addListener(_automaticSubmit);
//     _CityController.addListener(_automaticSubmit);
//   }
//
//   Future<void> _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _nameController.text = prefs.getString('name') ?? '';
//       _mobileNoController.text = prefs.getString('mobileNo') ?? '';
//       _landmarkController.text = prefs.getString('landmark') ?? '';
//       _CityController.text = prefs.getString('city') ?? '';
//       _StateController.text = prefs.getString('state') ?? '';
//       _addressController.text = prefs.getString('fullLocationName') ?? '';
//       _pinCodeController.text = prefs.getString('pinCode') ?? '';
//       _latitudeController.text = prefs.getDouble('latitude')?.toString() ?? '';
//       _longitudeController.text =
//           prefs.getDouble('longitude')?.toString() ?? '';
//
//       _customerCode =
//           prefs.getString('customerid') ?? 'CUST000394'; // Default if not found
//     });
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled;
//       PermissionStatus permissionGranted;
//
//       serviceEnabled = await location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if (!serviceEnabled) {
//           throw Exception('Location services are disabled.');
//         }
//       }
//
//       permissionGranted = await location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           throw Exception('Location permission denied.');
//         }
//       }
//
//       LocationData locationData = await location.getLocation();
//       _updateAddressFields(locationData); // Update fields using Google Maps API
//     } catch (e) {
//       print('Error getting location: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to get location: ${e.toString()}')),
//       );
//     }
//   }
//
//   Future<void> _updateAddressFields(LocationData locationData) async {
//     final apiKey =
//         'AIzaSyAl1R0a3KP6a5VUwtQvQPQZ8wFKjwxpREs'; // Replace with your API key
//     final url =
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=$apiKey';
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       final results = decoded['results'] as List<dynamic>;
//       if (results.isNotEmpty) {
//         final address = results[0]['formatted_address'];
//         final addressComponents =
//             results[0]['address_components'] as List<dynamic>;
//
//         // Extracting the landmark from the address string
//         final landmark = address!.split(',')[0].trim();
//
//         setState(() {
//           _selectedState = _getAddressComponentValue(
//               addressComponents, 'administrative_area_level_1');
//           _selectedCity =
//               _getAddressComponentValue(addressComponents, 'locality');
//           _pinCodeController.text =
//               _getAddressComponentValue(addressComponents, 'postal_code');
//           _address2Controller.text =
//               _getAddressComponentValue(addressComponents, 'locality');
//           _CityController.text = _selectedCity;
//           _StateController.text = _selectedState;
//           _landmarkController.text =
//               landmark; // Set the landmark in the controller
//
//           // Update other fields as needed...
//         });
//       }
//     } else {
//       throw Exception('Failed to fetch address details.');
//     }
//   }
//
//   String _getAddressComponentValue(
//       List<dynamic> addressComponents, String type) {
//     final component = addressComponents.firstWhere(
//         (component) => component['types'].contains(type),
//         orElse: () => null);
//     return component != null ? component['long_name'] as String : '';
//   }
//
//   Future<void> _fetchStates() async {
//     try {
//       final states = await APIService.fetchStates();
//       setState(() {
//         _states = states;
//       });
//     } catch (e) {
//       print('Failed to load states: $e');
//     }
//   }
//
//   Future<void> _fetchCities(String stateId) async {
//     try {
//       final cities = await APIService.fetchCities(int.parse(stateId));
//       setState(() {
//         _cities = cities;
//       });
//     } catch (e) {
//       print('Failed to load cities: $e');
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to load cities. Please try again later.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   Future<List<ShowAddress>> fetchAddresses() async {
//     final response = await http.post(
//       Uri.parse('https://clacostoreapi.onrender.com/displayAddress'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'CustomerCode': _customerCode ?? 'CUST000394',
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       final List<dynamic> data = jsonResponse['data'];
//       return data.map((json) => ShowAddress.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load addresses');
//     }
//   }
//
//   void _automaticSubmit() {
//     if (_formKey.currentState?.validate() ?? false) {
//       _submitForm();
//     }
//   }
//
//   Future<void> _submitForm() async {
//     final address = Address(
//       customerCode: 'CUST000394',
//       name: _nameController.text,
//       mobileNo: _mobileNoController.text,
//       pinCode: _pinCodeController.text,
//       locality: _localityController.text,
//       address: _addressController.text,
//       stateId: _selectedState,
//       cityId: _selectedCity,
//       landmark: _landmarkController.text,
//       alternativeMobileNo: _alternativeMobileNoController.text,
//       latitude: _latitudeController.text,
//       longitude: _longitudeController.text,
//       address2: _address2Controller.text,
//     );
//
//     try {
//       final response = await APIService.insertAddress(address);
//
//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//         final message =
//             responseBody['message'] ?? 'Address added successfully!';
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//         // Navigate to AddAddressPage after successful insertion
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => AddAddressPage()),
//         );
//       } else {
//         final responseBody = jsonDecode(response.body);
//         final message = responseBody['message'] ?? 'Failed to add address!';
//         print('Failed with status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => AddAddressPage()),
//         );
//       }
//     } catch (e) {
//       print('Exception: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred! Please try again.')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileNoController.dispose();
//     _pinCodeController.dispose();
//     _localityController.dispose();
//     _addressController.dispose();
//     _landmarkController.dispose();
//     _alternativeMobileNoController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     _address2Controller.dispose();
//     _StateController.dispose();
//     _CityController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Address'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               TextFormField(
//                 controller: _srNo,
//                 decoration: const InputDecoration(labelText: 'Sr No'),
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//               ),
//               TextFormField(
//                 controller: _mobileNoController,
//                 decoration: const InputDecoration(labelText: 'Mobile No'),
//               ),
//               TextFormField(
//                 controller: _pinCodeController,
//                 decoration: const InputDecoration(labelText: 'Pin Code'),
//               ),
//               TextFormField(
//                 controller: _localityController,
//                 decoration: const InputDecoration(labelText: 'Locality'),
//               ),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: 'Address'),
//               ),
//               TextFormField(
//                 controller: _landmarkController,
//                 decoration: const InputDecoration(labelText: 'Landmark'),
//               ),
//               TextFormField(
//                 controller: _alternativeMobileNoController,
//                 decoration:
//                     const InputDecoration(labelText: 'Alternative Mobile No'),
//               ),
//               TextFormField(
//                 controller: _latitudeController,
//                 decoration: const InputDecoration(labelText: 'Latitude'),
//               ),
//               TextFormField(
//                 controller: _longitudeController,
//                 decoration: const InputDecoration(labelText: 'Longitude'),
//               ),
//               TextFormField(
//                 controller: _address2Controller,
//                 decoration: const InputDecoration(labelText: 'Address 2'),
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedState.isEmpty ? null : _selectedState,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedState = newValue!;
//                     _fetchCities(_selectedState);
//                   });
//                 },
//                 items: _states.map((state) {
//                   return DropdownMenuItem<String>(
//                     value: state['StateId'],
//                     child: Text(state['StateName'] ?? ''),
//                   );
//                 }).toList(),
//                 decoration: const InputDecoration(labelText: 'State'),
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedCity.isEmpty ? null : _selectedCity,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedCity = newValue!;
//                   });
//                 },
//                 items: _cities.map((city) {
//                   return DropdownMenuItem<String>(
//                     value: city['CityName'],
//                     child: Text(city['CityName'] ?? ''),
//                   );
//                 }).toList(),
//                 decoration: const InputDecoration(labelText: 'City'),
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _getCurrentLocation,
//                 child: const Text('Get Current Location'),
//               ),
//               const SizedBox(height: 16.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
