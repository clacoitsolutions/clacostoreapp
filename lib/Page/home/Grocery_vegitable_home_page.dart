import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/Grocery_api.dart';
import '../../pageUtills/bottom_navbar.dart';
import '../home_page.dart';
import '../search_product.dart';
import 'Chekout_page.dart';
import 'Vegitable_Fruit.dart';
import 'grocery_home_page.dart';
import 'package:claco_store/pageUtills/top_navbar.dart';

class GroceryHome extends StatefulWidget {
  @override
  State<GroceryHome> createState() => _GroceryHomeState();
}

class _GroceryHomeState extends State<GroceryHome> {
  String selectedButton = 'home'; // Default to 'home'
  List<dynamic> _cartItems = [];
  String _fullLocationName = ''; // To display the full address
  bool _showTrending = true; // Initial state for trending products
  String? _userName; // For displaying user name in the drawer
  String _searchQuery = ''; // For searching locations
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

  String _getCityOrPincode() {
    if (_city != null && _pinCode != null) {
      return '$_city, $_pinCode';
    } else if (_city != null) {
      return _city!;
    } else if (_pinCode != null) {
      return _pinCode!;
    } else {
      return 'Location not found'; // Handle edge case if neither city nor pincode is available
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
    _loadLocationDetails();
  }

  void _refreshCartModal() {
    setState(() {}); // This empty setState will trigger a rebuild of the modal
  }

  Future<void> _fetchCartItems() async {
    try {
      final cartItems = await CartApiService.fetchCartItems('CUST000394');
      setState(() {
        _cartItems = cartItems;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      // Handle error
    }
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

  Future<void> _loadLocationDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullLocationName = prefs.getString('fullLocationName') ?? '';
      _city = prefs.getString('city') ?? '';
      _pinCode = prefs.getString('pinCode') ?? '';
    });
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

  Future<void> _updateCartSize(
      String customerId, String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/updatecartsize1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "customerid": customerId,
          "productid": productId,
          "quantity": quantity.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('Cart size updated successfully');
        // Fetch the cart items again to reflect the updated quantity
        await _fetchCartItems();
      } else {
        print(
            'Failed to update cart size. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart size: $e');
    }
  }

  void _decrementCounter(String productId, int currentQuantity) async {
    int index = _cartItems.indexWhere((item) => item['ProductID'] == productId);
    if (currentQuantity > 1 && index != -1) {
      int newQuantity = currentQuantity - 1;
      await _updateCartSize('CUST000394', productId, newQuantity);
      setState(() {
        _cartItems[index]['Quantity'] = newQuantity;
      });
      _refreshCartModal(); // Refresh modal to reflect updated cart
    }
  }

  void _incrementCounter(String productId, int currentQuantity) async {
    int index = _cartItems.indexWhere((item) => item['ProductID'] == productId);
    if (index != -1) {
      int newQuantity = currentQuantity + 1;
      await _updateCartSize('CUST000394', productId, newQuantity);
      setState(() {
        _cartItems[index]['Quantity'] = newQuantity;
      });
      _refreshCartModal(); // Refresh modal to reflect updated cart
    }
  }

  void _showCartModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: _buildCartItems(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart,
                                        color: Colors.pink),
                                    SizedBox(width: 5),
                                    Text(
                                      '${_cartItems.length} items',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(0),
                                border:
                                    Border.all(color: Colors.pink, width: 2),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Checkout()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCartItems() {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final productId = _cartItems[index]['ProductID'];
          final currentQuantity = _cartItems[index]['Quantity'];

          return Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                // Image Container (20% width)
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 80,
                    margin: EdgeInsets.all(8),
                    child: Image.network(
                      _cartItems[index]['ProductMainImageUrl'],
                      fit: BoxFit.cover,
                      height: 60,
                    ),
                  ),
                ),
                // Text Container (80% width)
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _cartItems[index]['ProductName'],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹ ${_cartItems[index]['OnlinePrice'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.pink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _decrementCounter(
                                      productId, currentQuantity),
                                  padding: EdgeInsets.all(0),
                                  constraints: BoxConstraints(),
                                  splashRadius: 20,
                                  iconSize: 18,
                                  icon: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 5),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.pink, // Pink background color
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child:
                                        Icon(Icons.remove, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 0.2),
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    currentQuantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _incrementCounter(
                                      productId, currentQuantity),
                                  padding: EdgeInsets.all(0),
                                  constraints: BoxConstraints(),
                                  splashRadius: 20,
                                  iconSize: 18,
                                  icon: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.pink, // Pink background color
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
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
              preferredSize: Size.fromHeight(60),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                              Expanded(
                                child: Center(
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Search any products..',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.withOpacity(0.5)),
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
          ),
          SliverFillRemaining(
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: 20, left: 20, top: 20, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: selectedButton == 'home'
                                        ? Colors.pink
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButton = 'home';
                                  });
                                },
                                child: Text('Grocery'),
                                style: TextButton.styleFrom(
                                  foregroundColor: selectedButton == 'home'
                                      ? Colors.pink
                                      : Colors.black,
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: selectedButton == 'second'
                                        ? Colors.pink
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButton = 'second';
                                  });
                                },
                                child: Text('Vegetable & Fruit'),
                                style: TextButton.styleFrom(
                                  foregroundColor: selectedButton == 'second'
                                      ? Colors.pink
                                      : Colors.black,
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    selectedButton == 'home' ? GroceryHomePage() : Vegitable(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    _showCartModalSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.pink),
                      SizedBox(width: 5),
                      Text(
                        '${_cartItems.length} items',
                        style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(color: Colors.pink, width: 2),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Checkout()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
