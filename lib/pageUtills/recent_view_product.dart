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
                          if (regularPrice != null && salePrice != null && regularPrice > salePrice)
                            Text(
                              ' ₹${product['RegularPrice']}', // Product price with null check
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          SizedBox(width: 3),
                          Text(
                            ' ₹${product['SalePrice']}', // Product price with null check
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
                          )
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
                icon: Icon(Icons.favorite_border), // Use your heart icon here
                onPressed: () {
                  // Handle heart icon click event
                  print('Heart clicked for product: ${product['ProductName']}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveProductToRecent(dynamic product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentProducts = prefs.getStringList('recentProducts') ?? [];

    String productJson = jsonEncode(product);

    // Add the new product to the beginning of the list
    recentProducts.insert(0, productJson);

    // Limit to 10 recent products
    if (recentProducts.length > 10) {
      recentProducts = recentProducts.sublist(0, 10);
    }

    await prefs.setStringList('recentProducts', recentProducts);

    // Update the UI to reflect the new order
    setState(() {
      futureProducts = getRecentProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('हाल ही में देखे गए उत्पाद'),
      ),
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
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return buildProductCard(snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
