import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/Grocery_api.dart';
import '../product_details.dart';

class Vegitable extends StatefulWidget {
  @override
  _GroceryHomePage createState() => _GroceryHomePage();
}

class _GroceryHomePage extends State<Vegitable> {
  List<dynamic> products = [];
  final ApiService apiService = ApiService();
  final String customerId = 'ayush@gmail.com'; // Hardcoded Customer ID

  @override
  void initState() {
    super.initState();
    fetchProductsGrocery();
  }

  Future<void> fetchProductsGrocery() async {
    try {
      final fetchedProducts = await apiService.fetchProductsGrocery('40276');
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

  Widget buildProductCard(dynamic product) {
    double? regularPrice = parsePrice(product?['RegularPrice']);
    double? onlinePrice = parsePrice(product?['OnlinePrice']);
    double? discountPercentage;

    if (regularPrice != null && onlinePrice != null) {
      discountPercentage = calculateDiscountPercentage(regularPrice, onlinePrice);
    }

    bool isFavorited = false;

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
            margin: EdgeInsets.all(0),
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
                        height: 120,
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
                          SizedBox(height: 4),
                          if (discountPercentage != null && discountPercentage > 0)
                            Text(
                              '${discountPercentage.toStringAsFixed(2)}% off',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
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
