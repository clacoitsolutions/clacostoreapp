import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Api services/service_api.dart';
import '../product_details.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String categoryName;
  final List<String> srNoList;

  const CategoryDetailsPage({
    required this.categoryName,
    required this.srNoList,
  });

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  String? selectedCategoryName;
  List<dynamic> products = [];
  Map<String, bool> favoritedProducts = {}; // Map to store favorited state for each product
  final String customerId = 'CUST000394';

  @override
  void initState() {
    super.initState();
    getCategoryDetails();
    fetchProducts();
  }

  void getCategoryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategoryName = prefs.getString('selectedCategoryName') ?? widget.categoryName;
    });
  }

  Future<void> _navigateToProductDetail(String productId, String srno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SrNo', srno);
    await prefs.setString('ProductCode', productId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(productId: productId),
      ),
    );
  }

  Future<void> _addToWishlist(String variationId, String productId, StateSetter setState) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/AddWishlist1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'VariationId': variationId,
          'ProductId': productId,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          favoritedProducts[productId] = true; // Mark the product as favorited
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

  Future<void> fetchProducts() async {
    try {
      List<dynamic> fetchedProducts = await APIService.fetchProductsdetails(widget.srNoList);
      setState(() {
        products.addAll(fetchedProducts);
        // Initialize favoritedProducts map based on fetched products, assuming initially not favorited
        favoritedProducts = Map.fromIterable(fetchedProducts, key: (product) => product['ProductCode'], value: (_) => false);
      });
    } catch (e) {
      print('Error fetching products: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: products.isEmpty
            ? CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 5,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final regularPrice = product['RegularPrice'];
              final salePrice = product['SalePrice'];
              final discountPercentage = ((regularPrice - salePrice) / regularPrice) * 100;

              final productId = product['ProductCode'].toString();
              final isFavorited = favoritedProducts[productId] ?? false;

              return GestureDetector(
                onTap: () => _navigateToProductDetail(product['ProductCode'], product['SrNo']),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.network(
                              product['ProductMainImageUrl'] ?? '',
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['ProductName'] ?? '',
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
                                    if (regularPrice != null &&
                                        salePrice != null &&
                                        regularPrice > salePrice)
                                      Text(
                                        '₹${product['RegularPrice']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.redAccent,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.red,
                                        ),
                                      ),
                                    SizedBox(width: 3),
                                    Text(
                                      '₹${product['SalePrice']}',
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
                                  children: List.generate(
                                    5,
                                        (index) => Icon(
                                      Icons.star,
                                      color: Colors.green,
                                      size: 15,
                                    ),
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
                            _addToWishlist(customerId, productId, setState);
                            setState(() {
                              favoritedProducts[productId] = !isFavorited;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
