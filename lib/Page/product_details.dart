import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Api services/service_api.dart';
import '../models/product_details_api.dart';
import 'home/Chekout_page.dart'; // Adjust import path based on your project

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? srno;
  String? productId;
  String? quantity;
  int _currentIndex = 0;
  String? customerId;
  List<String> _images = [];
  List<String> _sizes = [];
  List<String> _colors = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselController _carouselController = CarouselController();

  bool isLoading = true;
  Map<String, dynamic>? productDetails;
  bool showFullDescription = false;
  bool showSizes = false; // Flag to control when to show sizes
  bool showColors = false; // Flag to control when to show colors
  int productCount = 1; // Initial product count

  final APIService _productService = APIService();
  final APIServices _productServices = APIServices();

  @override
  void initState() {
    super.initState();
    loadProductDetails();
  }

  Future<void> loadProductDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      srno = prefs.getString('SrNo');
      productId = prefs.getString('ProductCode');
      quantity = prefs.getString('quantity');
    });

    if (srno != null && productId != null) {
      await fetchProductDetails(srno!, productId!);
      fetchProductSizes(productId!);
      fetchProductColors(productId!);
      fetchProductImages(productId!);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProductDetails(String srno, String productId) async {
    try {
      final data = await _productService.fetchProductDetails(srno, productId);
      setState(() {
        productDetails = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching product details: $e');
      setState(() {
        isLoading = false;
      });
      // Handle error, show snackbar, etc.
    }
  }

  Future<void> fetchProductSizes(String productId) async {
    try {
      final data = await _productServices.fetchProductSizes(productId);
      setState(() {
        _sizes = List<String>.from(data['data'].map((sizeData) => sizeData['Size_Value']));
        showSizes = true; // Show sizes when successfully fetched
      });
    } catch (e) {
      print('Error fetching product sizes: $e');
      // Handle error, show snackbar, etc.
    }
  }

  Future<void> fetchProductColors(String productId) async {
    try {
      final data = await _productServices.fetchProductColor(productId);
      setState(() {
        _colors = List<String>.from(data['data'].map((colorData) => colorData['colorname']));
        showColors = true; // Show colors when successfully fetched
      });
    } catch (e) {
      print('Error fetching product colors: $e');
      // Handle error, show snackbar, etc.
    }
  }

  Future<void> fetchProductImages(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/getAllImageProductWise'),
        body: jsonEncode({
          'ProductId': productId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> images = List<String>.from(data['data'].map((imageData) => imageData['ImageUrl']));
        setState(() {
          _images = images;
        });
      } else {
        print('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  double calculateDiscountPercentage(double regularPrice, double salePrice) {
    return ((regularPrice - salePrice) / regularPrice) * 100;
  }

  double? parsePrice(dynamic price) {
    if (price is String) {
      return double.tryParse(price);
    } else if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    }
    return null;
  }

  Future<void> addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getString('customerId');
    if (customerId == null || productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer ID or Product ID is missing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await _productServices.addToCart(customerId!, productId!, quantity!);

      if (response.containsKey('message')) {
        var apiMessage = response['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(apiMessage),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add item to cart'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred while adding item to cart. Please check your internet connection.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double? regularPrice = parsePrice(productDetails?['RegularPrice']);
    double? salePrice = parsePrice(productDetails?['SalePrice']);
    double? discountPercentage;

    if (regularPrice != null && salePrice != null && regularPrice > salePrice) {
      discountPercentage = calculateDiscountPercentage(regularPrice, salePrice);
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        title: Text(
        "${productDetails?['ProductCategory'] ?? ''}",
        style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.pink,
    iconTheme: IconThemeData(color: Colors.white),
    ),
    body: isLoading
    ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SizedBox(height: 8),
    Stack(
    children: [
    CarouselSlider(
    carouselController: _carouselController,
    options: CarouselOptions(
    height: 300,
    viewportFraction: 1.0,
    onPageChanged: (index, _) {
    setState(() {
    _currentIndex = index;
    });
    },
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 3),
    autoPlayAnimationDuration: Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    ),
    items: _images.map((image) {
    return GestureDetector(
    onTap: () {
    _showImageDialog(image);
    },
    child: Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
    color: Colors.white,
    ),
    child: Image.network(
    image,
    fit: BoxFit.cover,
    ),
    ),
    );
    }).toList(),
    ),
    Positioned(
    left: 0,
    top: 0,
    bottom: 0,
    child: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
    _carouselController.previousPage();
    },
    ),
    ),
    Positioned(
    right: 0,
    top: 0,
    bottom: 0,
    child: IconButton(
    icon: Icon(Icons.arrow_forward),
    onPressed: () {
    _carouselController.nextPage();
    },
    ),
    ),
    ],
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: _images.asMap().entries.map((entry) {
    int index = entry.key;
    String url = entry.value;
    return Container(
    width: 8.0,
    height: 8.0,
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
    ),
    );
    }).toList(),
    ),
    Padding(
    padding: EdgeInsets.all(10.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Text(
    "${productDetails?['ProductName'] ?? 'Product Name'}",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 2, // Adjust to 2.5 lines
      overflow: TextOverflow.ellipsis,
    ),
        SizedBox(height: 8),
        if (regularPrice != null &&
    salePrice != null &&
    regularPrice > salePrice &&
    discountPercentage != null &&
    discountPercentage > 0)
        Row(
    children: [
    Text(
    '₹${regularPrice.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: 15,
        color: Colors.red,
        decoration:
        salePrice != null ? TextDecoration.lineThrough : null,
      ),
    ),
    if (salePrice != null)
    Text(
    '  ₹${salePrice.toStringAsFixed(2)}',
    style: TextStyle(
    fontSize: 15,
    color: Colors.black,
    ),
    ),
    if (discountPercentage != null)
    Text(
    '  (${discountPercentage.toStringAsFixed(2)}% off)',
    style: TextStyle(
    fontSize: 15,
    color: Colors.green,
    ),
    ),
    ],
    )
    else if (salePrice != null)
    Text(
    '₹${salePrice.toStringAsFixed(2)}',
    style: TextStyle(
    fontSize: 15,
    color: Colors.black,
    ),
    ),
    SizedBox(height: 8),
    Row(
    children: [
    Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
    color: Colors.pink, // Pink background color
    borderRadius: BorderRadius.circular(4),
    ),
    child: IconButton(
    icon: const Icon(Icons.remove, color: Colors.white, size: 15),
    onPressed: () {
    setState(() {
    if (productCount > 0) productCount--;
    // Update the productId and quantity
    productId = productDetails?['ProductCode']?.toString();
    quantity = productCount.toString();
    });
    },
    ),
    ),
    Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Text(
    productCount.toString(),
    style: TextStyle(
    fontSize: 15,
    ),
    ),
    ),
    Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
    color: Colors.pink, // Pink background color
    borderRadius: BorderRadius.circular(4),
    ),
    child: IconButton(
    icon: const Icon(Icons.add, color: Colors.white, size: 15),
    onPressed: () {
    setState(() {
    productCount++;
    // Update the productId and quantity
    productId = productDetails?['ProductCode']?.toString();
    quantity = productCount.toString();
    });
    },
    ),
    ),
    ],
    ),
    SizedBox(height: 10),
    if (showSizes) // Only show sizes when fetched successfully
    Wrap(
    spacing: 8.0,
    children: _sizes.map((size) {
    return Chip(
    label: Text(size),
    );
    }).toList(),
    ),
    SizedBox(height: 8),
    if (showColors && _colors.isNotEmpty)
    Wrap(
    spacing: 8.0,
    children: _colors.map((color) {
    return Chip(
    label: Text(color),
    );
    }).toList(),
    ),
    SizedBox(height: 4),
    Row(
    children: [
    Icon(Icons.star, color: Colors.yellow, size: 15),
    Icon(Icons.star, color: Colors.yellow, size: 15),
    Icon(Icons.star, color: Colors.yellow, size: 15),
    Icon(Icons.star, color: Colors.yellow, size: 15),
    Icon(Icons.star, color: Colors.yellow, size: 15),
    Icon(Icons.star_half, color: Colors.grey, size: 15),
    SizedBox(width: 5),
    Text(
    "${productDetails?['rating'] ?? ''}",
    style: TextStyle(
    fontSize: 13,
    color: Colors.grey,
    ),
    ),
    ],
    ),
    SizedBox(height: 8),
    Text(
    (productDetails?['StockStatus'] != null &&
    (int.tryParse(productDetails!['StockStatus'].toString()) ?? 0) >
    0)
    ? "Available (in Stock)"
        : "Out of stock",
    style: TextStyle(
    fontSize: 14,
    color: (productDetails?['StockStatus'] != null &&
    (int.tryParse(productDetails!['StockStatus'].toString()) ?? 0) >
    0)
    ? Colors.green
        : Colors.red,
    ),
    ),
    SizedBox(height: 12),
    Text(
    'Product Details :',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8),
    Text(
    "${productDetails?['ProductDescription'] ?? ''}",
    style: TextStyle(
    fontSize: 14,
    ),
    maxLines: showFullDescription ? null : 5,
    overflow: showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,
    ),
    if (productDetails?['ProductDescription'] != null &&
    productDetails!['ProductDescription'].length > 1000)
    InkWell(
    onTap: () {
    setState(() {
    showFullDescription = !showFullDescription;
    });
    },
    child: Padding(
    padding: EdgeInsets.only(top: 4),
    child: Text(
    showFullDescription ? "Read less..." : "Read more...",
    style: TextStyle(color: Colors.blue),
    ),
    ),
    ),
    SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    ElevatedButton(
    onPressed: addToCart,
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pink,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    ),
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Icon(Icons.shopping_cart, color: Colors.white),
    SizedBox(width: 8),
    Text(
    'Add to Cart',
    style: TextStyle(color: Colors.white),
    ),
    ],
    ),
    ),
    SizedBox(width: 12),
    ElevatedButton(
    onPressed: () {
    addToCart(); // Call your addToCart function here if needed
    // Navigate to the checkout page
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Checkout()),
    );
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pink,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    ),
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Icon(Icons.touch_app, color: Colors.white),
    SizedBox(width: 8),
    Text(
    'Buy Now',
    style: TextStyle(color: Colors.white),
    ),
    ],
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    );
  }
}

