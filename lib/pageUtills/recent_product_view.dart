import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Widget buildProductCard(dynamic product) {
    double? regularPrice = parsePrice(product['RegularPrice']);
    double? salePrice = parsePrice(product['SalePrice']);
    double? discountPercentage;

    if (regularPrice != null && salePrice != null) {
      discountPercentage = calculateDiscountPercentage(regularPrice, salePrice);
    }

    return GestureDetector(
      onTap: () {
        // Navigate to product details page or handle tap event
      },

      child:Container(
        height: 120.0,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white70,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Display images dynamically from imageList
                SizedBox(
                  width: 100.0,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Add border radius
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.5), // Set border color and opacity
                        width: 1.0, // Set border width
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
                       padding: EdgeInsets.symmetric(horizontal: 4,),
                       child:Text(
                         product['ProductName'] ?? '',
                         maxLines: 1,
                         style: TextStyle(
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     )
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
            return Center(child: Text('कोई हाल ही में देखा गया उत्पाद नहीं मिला'));
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
