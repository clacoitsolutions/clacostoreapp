import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api services/service_api.dart';
import '../Page/product_details.dart'; // Adjust import as per your project structure

class ProductGrid extends StatefulWidget {
  final String categoryId;
  String customerId = '';
  ProductGrid({required this.categoryId});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future<List<Map<String, dynamic>>> _productListFuture;
  Map<String, bool> favoritedProducts = {}; // Map to store favorited state for each product
  bool isFavorited = false;
  String customerId = '';

  @override
  void initState() {
    super.initState();
    _productListFuture = fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/getSimmiliarProductsSubCategory'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"catid": widget.categoryId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((product) => product as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

          final productList = snapshot.data!;

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              final regularPrice = product['RegularPrice']?.toDouble() ?? 0.0;
              final salePrice = product['SalePrice']?.toDouble() ?? 0.0;
              final discountPercentage = product['Discper']?.toDouble() ?? 0.0;
              final productId = product['ProductCode'];

              return ProductCard(
                productData: product,
                regularPrice: regularPrice,
                salePrice: salePrice,
                discountPercentage: discountPercentage,
                productId: productId,
              );
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> productData;
  final double regularPrice;
  final double salePrice;
  final double discountPercentage;
  final String productId;

  ProductCard({
    required this.productData,
    required this.regularPrice,
    required this.salePrice,
    required this.discountPercentage,
    required this.productId,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorited = false; // Track favorite status
  final APIService apiService = APIService();
  String customerId = 'CUST000394';
  Map<String, bool> favoritedProducts = {}; // Map to store favorited state for each product

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

  Future<void> _navigateToProductDetails(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ProductCode', productId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(productId: productId),
      ),
    );
  }

  Future<void> _addToWishlist(String customerId, String productId, StateSetter setState) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/AddWishlist1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'VariationId': customerId,
          'ProductId': productId,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          favoritedProducts[productId] = true; // Update the state to show the favorited icon
        });

        // Show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to wishlist'),
          ),
        );
      } else {
        print('Failed to add to wishlist: ${response.statusCode}');
        // Handle error
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
      // Handle error
    }
  }



  @override
  Widget build(BuildContext context) {
    double? regularPrice = parsePrice(widget.productData?['RegularPrice']);
    double? onlinePrice = parsePrice(widget.productData?['SalePrice']);
    double? discountPercentage;

    if (regularPrice != null && onlinePrice != null) {
      discountPercentage = calculateDiscountPercentage(regularPrice, onlinePrice);
    }

    return GestureDetector(
      onTap: () => _navigateToProductDetails(widget.productId),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5),
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
                    widget.productData['ProductMainImageUrl'] ?? '',
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productData['ProductName'] ?? '',
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
                          if (widget.regularPrice > widget.salePrice)
                            Text(
                              ' ₹${widget.regularPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          SizedBox(width: 3),
                          Text(
                            ' ₹${widget.salePrice.toStringAsFixed(2)}',
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
                onPressed: () {
                  _addToWishlist(customerId, widget.productId, setState);
                  setState(() {
                    favoritedProducts[widget.productId] = !isFavorited;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
