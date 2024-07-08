import 'dart:convert';

import 'package:claco_store/Page/search_product.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_drawer.dart';
import '../pageUtills/top_navbar.dart';
import 'home/Grocery_vegitable_home_page.dart';
import 'home/category.dart';
import 'home/slider.dart';
import 'package:http/http.dart' as http;
import 'home/top_section_filtter.dart';
import 'home/trandingProduct.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showTrending = true; // Initial state for trending products
  String? _userName; // For displaying user name in the drawer
  String _searchQuery = ''; // For searching locations
  String _fullLocationName = ''; // To display the full address
  final TextEditingController _searchController = TextEditingController();
  String? _landmark, _city, _state, _country, _pinCode;
  double? _latitude, _longitude;
  String _locationMessage = "Tap the button to get your location";
  bool _isLoadingLocation = true;
  List<String> _locationSuggestions = []; // List to store suggestions

  final String _apiKey =
      "AIzaSyA47g1GVaa0SYZVRAL21W0QpmK9Y8XrE3w"; // Replace with your API key
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  final GooglePlace _googlePlace = GooglePlace(
      "AIzaSyA47g1GVaa0SYZVRAL21W0QpmK9Y8XrE3w"); // Replace with your Google Places API key

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadLocationDetails(); // Load saved location details
  }

  Future<void> _searchLocation(String query) async {
    var result = await _googlePlace.autocomplete.get(
      query,
      language: "en", // Language of the results
      types: "address", // Restrict results to addresses
    );

    setState(() {
      _locationSuggestions = result?.predictions
              ?.map((prediction) => prediction.description ?? '')
              .toList() ??
          []; // Handle null predictions
    });
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoadingLocation = true; // Show indicator before fetching location
      _locationMessage = ""; // Clear any previous error messages
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      await _getLocationNameFromCoordinates(position);
    } catch (e) {
      setState(() {
        _locationMessage = "Error getting location: $e";
      });
    } finally {
      setState(() {
        _isLoadingLocation = false; // Hide indicator after fetching
      });
    }
  }

  Future<void> _getLocationNameFromCoordinates(Position position) async {
    final String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_apiKey";

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        setState(() {
          _fullLocationName = data['results'][0]['formatted_address'];
          _parseLocationDetails(data['results'][0]['address_components']);
          _saveLocationDetails();
        });
      } else {
        setState(() {
          _locationMessage = "Location not found";
        });
      }
    } else {
      print("Error getting location name: ${response.statusCode}");
    }
  }

  void _parseLocationDetails(List<dynamic> components) {
    for (var component in components) {
      if (component['types'].contains('point_of_interest')) {
        _landmark = component['long_name'];
        break;
      } else if (component['types'].contains('street_address')) {
        _landmark = component['long_name'];
        break;
      } else if (component['types'].contains('route')) {
        _landmark = component['long_name'];
        break;
      } else if (component['types'].contains('political')) {
        _landmark = component['long_name'];
        break;
      }
    }
    if (_landmark != null) {
      for (var component in components) {
        if (component['types'].contains('street_number')) {
          _landmark = '${component['long_name']} / $_landmark';
        } else if (component['types'].contains('neighborhood')) {
          _landmark = '${component['long_name']} / $_landmark';
        }
      }
    }
    for (var component in components) {
      if (component['types'].contains('locality')) {
        _city = component['long_name'];
      } else if (component['types'].contains('administrative_area_level_1')) {
        _state = component['long_name'];
      } else if (component['types'].contains('country')) {
        _country = component['long_name'];
      } else if (component['types'].contains('postal_code')) {
        // Get Pincode
        _pinCode = component['long_name']; // Store the Pincode
      }
    }
  }

  Future<void> _saveLocationDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('landmark', _landmark ?? '');
    prefs.setString('city', _city ?? '');
    prefs.setString('state', _state ?? '');
    prefs.setString('country', _country ?? '');
    prefs.setDouble('latitude', _latitude ?? 0.0);
    prefs.setDouble('longitude', _longitude ?? 0.0);
    prefs.setString('fullLocationName', _fullLocationName);
    prefs.setString(
        'pinCode', _pinCode ?? ''); // Store the pincode in SharedPreferences
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name');
    });
  }

  Future<void> _checkIfLocationSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final locationSaved = prefs.containsKey('fullLocationName');
    if (!locationSaved) {
      _showLocationSelectionBottomSheet(context);
    }
  }

  Future<void> _loadLocationDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullLocationName = prefs.getString('fullLocationName') ?? '';
      _city = prefs.getString('city') ?? '';
      _pinCode = prefs.getString('pinCode') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top row that is not fixed
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () async {
                // Call method to show location selection and get new location
                var newLocation =
                    await _showLocationSelectionBottomSheet(context);
                if (newLocation != null) {
                  setState(() {
                    // Update the state with the new location
                    _fullLocationName = newLocation;
                  });
                }
              },
              child: Container(
                color: Colors.pink,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          _fullLocationName.isEmpty
                              ? 'Get Current Location' // Default text
                              : '$_city, $_pinCode', // Use fetched location
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Handle user icon tap
                      },
                      child: Icon(Icons.person, color: Colors.white, size: 26),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SliverAppBar that remains fixed at the top
          SliverAppBar(
            backgroundColor: Colors.pink,
            elevation: 0,
            automaticallyImplyLeading: false,
            pinned: true, // This ensures the SliverAppBar stays fixed
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomPage()),
                            );
                          },
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomPage()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Claco',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroceryHome()),
                            );
                          },
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroceryHome()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Grocery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.black.withOpacity(0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: Colors.black.withOpacity(0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to MyPage when the search box is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchProduct(
                                                products: [],
                                                categoryProducts: [],
                                                ratingProducts: [],
                                                discountproducts: [],
                                                sizeProducts: [],
                                              )),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.search,
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: TextField(
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              hintText: 'Search any products..',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5)),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 8.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.mic,
                                          color: Colors.grey.withOpacity(0.7)),
                                    ],
                                  ),
                                ),
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
          // Body content
          SliverToBoxAdapter(
            child: HomeBody(),
          ),
        ],
      ),
    );
  }

  _showLocationSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Container(
              height: 600,
              width: 450,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Select location',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search location',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.pinkAccent, // Set pink color
                      ),
                      filled: true, // Set filled to true
                      fillColor: Colors.white, // Set background color to white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none, // Remove border
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _searchLocation(value);
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // Display suggestions
                  if (_locationSuggestions.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _locationSuggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _locationSuggestions[index];
                          return ListTile(
                            title: Text(suggestion),
                            onTap: () {
                              setState(() {
                                _fullLocationName =
                                    suggestion; // Update full location
                                _searchQuery =
                                    suggestion; // Update search query
                                _locationSuggestions = []; // Clear suggestions
                                _searchController.text =
                                    suggestion; // Update TextField
                              });
                              // You can also perform other actions like getting coordinates
                              // for the selected location
                            },
                          );
                        },
                      ),
                    ),
                  // Use a GestureDetector for the location button
                  GestureDetector(
                    onTap: _getUserLocation,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20), // Round corners
                        color: Colors.white, // White background
                        border: Border.all(
                          color: Colors.grey[300]!, // Light grey border
                          width: 1, // Border thickness
                        ),
                      ),
                      child: Row(
                        children: [
                          // Image.asset for the custom icon
                          Image.asset(
                            'images/cloco.png', // Replace with your image path
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Get Current Location',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Show full location name in a popup card
                  // Display the fetched address
                  if (_fullLocationName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ' $_fullLocationName',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            // Positioned close (cross) icon

            Positioned(
              top: 10,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool _showTrending = true; // Initial state for trending products
  String? _userName; // For displaying user name in the drawer
  String _searchQuery = ''; // For searching locations
  String _fullLocationName = ''; // To display the full address
  final TextEditingController _searchController = TextEditingController();
  String? _landmark, _city, _state, _country, _pinCode;
  double? _latitude, _longitude;
  String _locationMessage = "Tap the button to get your location";
  bool _isLoadingLocation = true;
  List<String> _locationSuggestions = []; // List to store suggestions

  final String _apiKey =
      "AIzaSyA47g1GVaa0SYZVRAL21W0QpmK9Y8XrE3w"; // Replace with your API key
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  final GooglePlace _googlePlace = GooglePlace(
      "AIzaSyA47g1GVaa0SYZVRAL21W0QpmK9Y8XrE3w"); // Replace with your Google Places API key

  @override
  void initState() {
    super.initState();
    //_loadUserName();
    //_checkIfLocationSaved(); // Check if location has been saved
  }

  // Future<void> _searchLocation(String query) async {
  //   var result = await _googlePlace.autocomplete.get(
  //     query,
  //     language: "en", // Language of the results
  //     types: "address", // Restrict results to addresses
  //   );
  //
  //   setState(() {
  //     _locationSuggestions = result?.predictions
  //             ?.map((prediction) => prediction.description ?? '')
  //             .toList() ??
  //         []; // Handle null predictions
  //   });
  // }
  //
  // Future<void> _getUserLocation() async {
  //   setState(() {
  //     _isLoadingLocation = true; // Show indicator before fetching location
  //     _locationMessage = ""; // Clear any previous error messages
  //   });
  //
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);
  //     await _getLocationNameFromCoordinates(position);
  //   } catch (e) {
  //     setState(() {
  //       _locationMessage = "Error getting location: $e";
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoadingLocation = false; // Hide indicator after fetching
  //     });
  //   }
  // }
  //
  // Future<void> _getLocationNameFromCoordinates(Position position) async {
  //   final String apiUrl =
  //       "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_apiKey";
  //
  //   final response = await http.get(Uri.parse(apiUrl));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (data['results'].isNotEmpty) {
  //       setState(() {
  //         _fullLocationName = data['results'][0]['formatted_address'];
  //         _parseLocationDetails(data['results'][0]['address_components']);
  //         _saveLocationDetails();
  //       });
  //     } else {
  //       setState(() {
  //         _locationMessage = "Location not found";
  //       });
  //     }
  //   } else {
  //     print("Error getting location name: ${response.statusCode}");
  //   }
  // }
  //
  // void _parseLocationDetails(List<dynamic> components) {
  //   for (var component in components) {
  //     if (component['types'].contains('point_of_interest')) {
  //       _landmark = component['long_name'];
  //       break;
  //     } else if (component['types'].contains('street_address')) {
  //       _landmark = component['long_name'];
  //       break;
  //     } else if (component['types'].contains('route')) {
  //       _landmark = component['long_name'];
  //       break;
  //     } else if (component['types'].contains('political')) {
  //       _landmark = component['long_name'];
  //       break;
  //     }
  //   }
  //   if (_landmark != null) {
  //     for (var component in components) {
  //       if (component['types'].contains('street_number')) {
  //         _landmark = '${component['long_name']} / $_landmark';
  //       } else if (component['types'].contains('neighborhood')) {
  //         _landmark = '${component['long_name']} / $_landmark';
  //       }
  //     }
  //   }
  //   for (var component in components) {
  //     if (component['types'].contains('locality')) {
  //       _city = component['long_name'];
  //     } else if (component['types'].contains('administrative_area_level_1')) {
  //       _state = component['long_name'];
  //     } else if (component['types'].contains('country')) {
  //       _country = component['long_name'];
  //     } else if (component['types'].contains('postal_code')) {
  //       // Get Pincode
  //       _pinCode = component['long_name']; // Store the Pincode
  //     }
  //   }
  // }
  //
  // Future<void> _saveLocationDetails() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('landmark', _landmark ?? '');
  //   prefs.setString('city', _city ?? '');
  //   prefs.setString('state', _state ?? '');
  //   prefs.setString('country', _country ?? '');
  //   prefs.setDouble('latitude', _latitude ?? 0.0);
  //   prefs.setDouble('longitude', _longitude ?? 0.0);
  //   prefs.setString('fullLocationName', _fullLocationName);
  //   prefs.setString(
  //       'pinCode', _pinCode ?? ''); // Store the pincode in SharedPreferences
  // }
  //
  // Future<void> _loadUserName() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _userName = prefs.getString('name');
  //   });
  // }

  // Future<void> _checkIfLocationSaved() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final locationSaved = prefs.containsKey('fullLocationName');
  //   if (!locationSaved) {
  //     _showLocationSelectionBottomSheet(context);
  //   }
  // }

  void toggleTrending() {
    setState(() {
      _showTrending = !_showTrending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.02),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 0),
              homeScreenSlider(),

              SizedBox(height: 10),

              HomeCategory(),
              SizedBox(height: 5),

              topSectionFilter(context),
              SizedBox(height: 0),
              // Toggle Trending Products
              TrendingProduct(),
              SizedBox(height: 20),
              // ... rest of your widgets ...

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                            10), // Border radius for all sides
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 10, top: 8), // Add top padding here
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trending Products ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 16, // Adjust the size as needed
                                    ),
                                    SizedBox(
                                        width:
                                            4), // Add some space between the icon and the text
                                    Text(
                                      '22h 55m 20s remaining',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10, // Add space between text and button
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10), // Add padding to the right
                            child: ElevatedButton(
                              onPressed: () {
                                // Add functionality for the button
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.pink,
                                side: const BorderSide(
                                    color: Colors.white), // Add border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      3), // Border radius for button
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('View all'),
                                  Icon(Icons.arrow_forward), // Right arrow icon
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add space between text and button
                ],
              ),

              const SizedBox(
                height: 10, // Add space between text and button
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 15, // Add space between text and button
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white, // Set background color to white
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: Image.network(
                                    'https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_640.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Boys Shoes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Nike Air Jordan Retro 1 Low Mystic Black',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '₹1500',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(
                                          Icons.star_half,
                                          color: Colors.grey,
                                          size: 15,
                                        ),
                                        Text(
                                          "2,55,999",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white, // Set background color to white
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: Image.network(
                                    'https://cdn.pixabay.com/photo/2023/06/17/22/51/shoes-8070908_640.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'girls Shoes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Nike Air Jordan Retro 1 Low Mystic Black',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '₹1500',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(
                                          Icons.star_half,
                                          color: Colors.grey,
                                          size: 15,
                                        ),
                                        Text(
                                          "2,55,999",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
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
                  const SizedBox(
                    height: 15, // Add space between text and button
                  ),
                  Container(
                    height: 260, // Set the height as needed
                    width: double.infinity, // Make it full width
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Container(
                          height: 200, // 80% of the container's height
                          width: double.infinity, // Make it full width
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(5), // Add border radius
                            image: const DecorationImage(
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2017/09/26/17/34/ballet-2789416_640.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Add some space between the image and the text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 20), // Add left padding to the column
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Arrivals ', // Your additional text
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Summer’ 25 Collections', // Your additional text
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 10), // Add right padding to the button
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Add functionality for the button
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          20), // Add padding to the button
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Border radius for button
                                  ),
                                ),
                                icon: Icon(
                                    Icons.arrow_forward), // Right arrow icon
                                label: Text('Button'), // Text of the button
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 20), // Add some space between the image and the text
              Column(children: [
                Container(
                  height: 310, // Set the height as needed
                  width: double.infinity, // Make it full width
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                top: 5,
                                bottom: 5), // Add left padding to the column
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sponserd ', // Your additional text
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 230, // 80% of the container's height
                        width: double.infinity, // Make it full width
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(10), // Add border radius
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://cdn.pixabay.com/photo/2020/05/03/19/09/nike-5126389_640.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              10), // Add some space between the image and the text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 20), // Add left padding to the column
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Up to 50% off ', // Your additional text
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 10), // Add right padding to the button
                            child: GestureDetector(
                              onTap: () {
                                // Add functionality for the icon
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Add padding to the icon
                                child: Icon(
                                  Icons.arrow_forward, // Right arrow icon
                                  color: Colors.black, // Set icon color
                                  size: 24, // Set icon size
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
