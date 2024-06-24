import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Api services/service_api.dart';
import 'home/Chekout_page.dart';

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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselController _carouselController = CarouselController();

  bool isLoading = true;
  Map<String, dynamic>? productDetails;
  bool showFullDescription = false;

  final APIService _productService = APIService();

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
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProductDetails(String srno, String productId) async {
    final data = await _productService.fetchProductDetails(srno, productId);
    setState(() {
      productDetails = data;
      _images = [
        productDetails!['ProductMainImageUrl'],
        // Add other image URLs if available in productDetails
      ];
      isLoading = false;
    });
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

    final url = Uri.parse('https://clacostoreapi.onrender.com/addtocart3');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'customerid': customerId,
          'productid': productId,
          'quantity': quantity,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Item added to cart. Response: $responseData');

        // Assuming the API returns a message in the response
        var apiMessage = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(apiMessage),
        ));
      } else {
        print('Failed to add item to cart. Status code: ${response.statusCode}');
        var errorMessage = 'Failed to add item to cart. Status code: ${response.statusCode}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Error occurred: $e');
      var errorMessage = 'Error occurred while adding item to cart. Please check your internet connection.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double? regularPrice = parsePrice(productDetails?['RegularPrice']);
    double? salePrice = parsePrice(productDetails?['SalePrice']);
    double? discountPercentage;

    if (regularPrice != null && salePrice != null) {
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
          children: [
            SizedBox(height: 8),
            Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 200,
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
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
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
              children: _images.map((url) {
                int index = _images.indexOf(url);
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
                    "${productDetails?['ProductName'] != null ? (productDetails!['ProductName'].length > 200 ? productDetails!['ProductName'].substring(0, 200) + '...' : productDetails!['ProductName']) : 'Product Name'}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (regularPrice != null && salePrice != null && regularPrice > salePrice)
                    Row(
                      children: [
                        Text(
                          '${regularPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '₹${salePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                        if (discountPercentage != null && discountPercentage > 0)
                          Text(
                            '${discountPercentage.toStringAsFixed(2)}% off',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          ),
                        SizedBox(width: 5),
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
                  SizedBox(height: 4),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle button tap
                        },
                        child: Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 1), // Border color and width
                            borderRadius: BorderRadius.zero, // Border radius
                          ),
                          child: const Center(
                            child: Text(
                              's',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          side: BorderSide(color: Colors.red, width: 1), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text('m'),
                      ),
                      SizedBox(width: 5), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.red, width: 1), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text('xl'),
                      ),
                      SizedBox(width: 5), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.red, width: 1), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text('xxl'),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star_half, color: Colors.grey, size: 15),
                      SizedBox(width: 5),
                      Text(
                        "${productDetails?['rating'] ?? ''} ", // Product rating with null check
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    " ${productDetails?['size'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${productDetails?['ProductDescription'] != null ? (showFullDescription ? productDetails!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), '') : (productDetails!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), '').length > 10000000 ? productDetails!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), '').substring(0, 100000) + '...' : productDetails!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), ''))) : 'Image Details'}",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: showFullDescription ? null : 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (productDetails?['ProductDescription'] != null && productDetails!['ProductDescription'].length > 100)
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart),
                            SizedBox(width: 8),
                            Text('Go to cart'),
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
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.touch_app),
                            SizedBox(width: 8),
                            Text('Buy Now'),
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
