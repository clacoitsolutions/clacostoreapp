import 'dart:convert';
import 'package:claco_store/Page/product_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Page/home/productdetails_demo.dart';

class RecentProductsScreen extends StatefulWidget {
  @override
  _RecentProductsScreenState createState() => _RecentProductsScreenState();
}

class _RecentProductsScreenState extends State<RecentProductsScreen> {
  late Future<List<dynamic>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = getRecentProducts();
  }

  Future<List<dynamic>> getRecentProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentProducts = prefs.getStringList('recentProducts') ?? [];

    // Reverse the list so that most recent products come first
    recentProducts = recentProducts.reversed.toList();

    return recentProducts.map((productJson) => jsonDecode(productJson)).toList();
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

  Future<void> saveProductToRecent(dynamic product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentProducts = prefs.getStringList('recentProducts') ?? [];

    // Add the product as JSON string to recent products list
    recentProducts.add(jsonEncode(product));

    // Save the updated list to SharedPreferences
    await prefs.setStringList('recentProducts', recentProducts);
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
        MaterialPageRoute(builder: (context) => ProductDetails(productId: null,)),
      );
    } catch (e) {
      print('Error saving product details: $e');
    }
  }

  Widget buildProductCard(dynamic product) {
    double? regularPrice = parsePrice(product['RegularPrice']);
    double? salePrice = parsePrice(product['SalePrice']);
    double? discountPercentage;

    if (regularPrice != null && salePrice != null) {
      discountPercentage = calculateDiscountPercentage(regularPrice, salePrice);
    }

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
        height: 120.0,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white70,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 100.0,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        product['ProductMainImageUrl'] ?? '',
                        height: 60.0,
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          product['ProductName'] ?? '',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recent products found.'));
          } else {
            return Container(
              height: 180.0, // Height of the horizontal list view
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return buildProductCard(snapshot.data![index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
