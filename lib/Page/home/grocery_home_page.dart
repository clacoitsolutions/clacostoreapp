import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Api services/Grocery_api.dart';
import '../product_details.dart';

class GroceryHomePage extends StatefulWidget {
  @override
  _GroceryHomePage createState() => _GroceryHomePage();
}

class _GroceryHomePage extends State<GroceryHomePage> {
  List<dynamic> products = [];
  final ApiService apiService = ApiService();
  int _currentIndex = 0;
  String? customerId;
  String? srno;
  String? productId;
  String? quantity;

  @override
  void initState() {
    super.initState();
    fetchProductsGrocery();
    fetchCustomerId(); // Fetch the customer ID on initialization
  }

  Future<void> fetchCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString('customerId');
    });
  }

  Future<void> fetchProductsGrocery() async {
    try {
      final fetchedProducts = await apiService.fetchProductsGrocery('30223');
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      // Handle the error
      print(e);
    }
  }

  Future<void> saveProductDetailsAndNavigate(String? srno, String? productId) async {
    if (srno == null || productId == null) {
      print('Invalid product details: srno = $srno, productId = $productId');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('SrNo', srno);
      await prefs.setString('ProductCode', productId);
      print('Product details saved: SrNo = $srno, ProductCode = $productId');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetails()),
      );
    } catch (e) {
      print('Error saving product details: $e');
    }
  }

  // Recent view store data
  Future<void> saveProductToRecent(dynamic product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentProducts = prefs.getStringList('recentProducts') ?? [];

    String productJson = jsonEncode(product);

    // Duplicate check: remove if already exists to update its position
    recentProducts.removeWhere((item) => item == productJson);

    recentProducts.add(productJson);

    // Limit to 10 recent products
    if (recentProducts.length > 10) {
      recentProducts = recentProducts.sublist(recentProducts.length - 10);
    }

    await prefs.setStringList('recentProducts', recentProducts);
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

  Future<void> addToCart(String productId, int productCount) async {
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
          'quantity': productCount.toString(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Item added to cart. Response: $responseData');

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

  Widget buildProductCard(dynamic product) {
    double? regularPrice = parsePrice(product?['RegularPrice']);
    double? onlinePrice = parsePrice(product?['OnlinePrice']);
    double? discountPercentage;

    if (regularPrice != null && onlinePrice != null) {
      discountPercentage = calculateDiscountPercentage(regularPrice, onlinePrice);
    }

    bool isFavorited = false;
    int productCount = 0; // Add a variable to track product count

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () {
            final srno = product['SrNo']?.toString();
            final productId = product['ProductCode']?.toString();
            print('Product card tapped: ${product['ProductName']}');

            saveProductToRecent(product).then((_) {
              saveProductDetailsAndNavigate(srno, productId);
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 0,right: 0),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                      child: Image.network(
                        product['ProductMainImageUrl'] ?? '', // Use product's image URL with null check
                        width: double.infinity,
                        height: 105,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4), // Adjust padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['ProductName'] ?? '', // Product name with null check
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              if (regularPrice != null && onlinePrice != null && regularPrice > onlinePrice)
                                Text(
                                  '  ${product['RegularPrice']}', // Product price with null check
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              SizedBox(width: 3),
                              Text(
                                ' ₹${product['OnlinePrice']}', // Product price with null check
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          if (discountPercentage != null && discountPercentage > 0)
                            Text(
                              '${discountPercentage.toStringAsFixed(2)}% off',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 15),
                              Icon(Icons.star, color: Colors.yellow, size: 15),
                              Icon(Icons.star, color: Colors.yellow, size: 15),
                              Icon(Icons.star, color: Colors.yellow, size: 15),
                              Icon(Icons.star_half, color: Colors.grey, size: 15),
                              SizedBox(width: 5),
                              Text(
                                product['rating']?.toString() ?? '0', // Product rating with null check
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Add a row with increment and decrement buttons and the cart icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.pink, // Pink background color
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white, size: 10),
                                onPressed: () {
                                  setState(() {
                                    if (productCount > 0) productCount--;
                                    // Update the productId and quantity
                                    productId = product['ProductCode']?.toString();
                                    quantity = productCount.toString();
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                productCount.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.pink, // Pink background color
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add, color: Colors.white, size: 10),
                                onPressed: () {
                                  setState(() {
                                    productCount++;
                                    // Update the productId and quantity
                                    productId = product['ProductCode']?.toString();
                                    quantity = productCount.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_cart),
                          onPressed: () {
                            // Handle add to cart functionality here
                            if (productId != null && productCount > 0) {
                              addToCart(productId!, productCount);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : null,
                    ),
                    onPressed: () async {
                      // Handle heart icon click event
                      try {
                        final productId = product['ProductCode']?.toString();
                        if (productId != null) {
                          // await apiService.addToWishlist(customerId, productId);
                          setState(() {
                            isFavorited = !isFavorited;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to wishlist'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add to wishlist'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15), // Add space between images
        products.isNotEmpty
            ? GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7, // Adjust the aspect ratio as needed
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return buildProductCard(products[index]);
          },
        )
            : CircularProgressIndicator(),
        const SizedBox(height: 20),
      ],
    );
  }
}
