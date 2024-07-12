import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api services/service_api.dart';
import '../product_details.dart';

class TrendingProduct extends StatefulWidget {
  final List<Map<String, String>> categories;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const TrendingProduct({
    required this.categories,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  });

  @override
  _TrendingProductState createState() => _TrendingProductState();
}

class _TrendingProductState extends State<TrendingProduct> {
  List<Map<String, dynamic>> categoryProducts = [];
  final APIService apiService = APIService();
  final String customerId = '';

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    for (var category in widget.categories) {
      try {
        final fetchedProducts = await apiService.fetchProducts(category['']!);
        setState(() {
          categoryProducts.add({
            'CatName': category['CatName'],
            'Products': fetchedProducts,
          });
        });
      } catch (e) {
        print('Failed to load products for category: ${category['CatName']}');
      }
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetails(productId: productId)),
      );
    } catch (e) {
      print('Error saving product details: $e');
    }
  }

  Future<void> saveProductToRecent(dynamic product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentProducts = prefs.getStringList('recentProducts') ?? [];

    String productJson = jsonEncode(product);

    recentProducts.removeWhere((item) => item == productJson);
    recentProducts.add(productJson);

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
                        product['ProductMainImageUrl'] ?? '',
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
                              if (regularPrice != null && onlinePrice != null && regularPrice > onlinePrice)
                                Text(
                                  ' ₹${product['RegularPrice']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              SizedBox(width: 3),
                              Text(
                                ' ₹${product['OnlinePrice']}',
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
                            children: List.generate(5, (index) {
                              if (product['Avg'] != null && product['Avg'] >= index + 1) {
                                return Icon(Icons.star, color: Colors.green, size: 15);
                              } else {
                                return Icon(Icons.star_border, color: Colors.green, size: 15);
                              }
                            }),
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
                      try {
                        final productId = product['ProductCode']?.toString();
                        if (productId != null) {
                          await apiService.addToWishlist(customerId, productId);
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
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: categoryProducts.isNotEmpty
          ? ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categoryProducts.length,
        itemBuilder: (context, index) {
          final category = categoryProducts[index];
          final products = category['Products'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                height: 40,
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                color: Colors.pink,
                child: Text(
                  category['CatName'] ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, productIndex) {
                  return buildProductCard(products[productIndex]);
                },
              ),
            ],
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
