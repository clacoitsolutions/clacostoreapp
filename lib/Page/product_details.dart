import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? srno;
  String? productId;
  Map<String, dynamic>? productDetails;
  int _currentIndex = 0;
  List<String> _images = [];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselController _carouselController = CarouselController();

  bool isLoading = true;
  Map<String, dynamic>? productDetailss;
  bool showFullDescription = false;

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
    final url = 'https://clacostoreapi.onrender.com/getProductDetails';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'CatId': srno, 'productId': productId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        productDetailss = json.decode(response.body)['data'][0];
        _images = [
          productDetailss!['ProductMainImageUrl'],
          // Add other image URLs if available in productDetailss
        ];
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Failed to load product details');
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

  @override
  Widget build(BuildContext context) {
    double? regularPrice = parsePrice(productDetailss?['RegularPrice']);
    double? salePrice = parsePrice(productDetailss?['SalePrice']);
    double? discountPercentage;

    if (regularPrice != null && salePrice != null) {
      discountPercentage = calculateDiscountPercentage(regularPrice, salePrice);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "${productDetailss?['ProductCategory'] ?? ''}",
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
                    "${productDetailss?['ProductName'] != null ? (productDetailss!['ProductName'].length > 200 ? productDetailss!['ProductName'].substring(0, 200) + '...' : productDetailss!['ProductName']) : 'Product Name'}",
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
                      Icon(Icons.star, color: Colors.yellow, size:
                      15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star, color: Colors.yellow, size: 15),
                      Icon(Icons.star_half, color: Colors.grey, size: 15),
                      SizedBox(width: 5),
                      Text(
                        "${productDetailss?['rating'] ?? ''} ", // Product rating with null check
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    " ${productDetailss?['size'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "${productDetailss?['ProductDescription'] != null ? (showFullDescription ? productDetailss!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), '') : (productDetailss!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), '').length > 10000000 ? productDetailss!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), '').substring(0, 100000) + '...' : productDetailss!['ProductDescription'].replaceAll(RegExp(r'<[^>]*>'), ''))) : 'Image Details'}",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: showFullDescription ? null : 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (productDetailss?['ProductDescription'] != null && productDetailss!['ProductDescription'].length > 100)
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
                        onPressed: () {
                          // Handle button tap
                        },
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
                          // Handle button tap
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
