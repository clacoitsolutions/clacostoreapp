import 'dart:convert';
import 'package:claco_store/Page/product_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = 'https://clacostoreapi.onrender.com';

class CategoryData {
  final int hid;
  final String catId;
  final String catName;
  final String heading;
  final String indexing;
  final bool isActive;

  CategoryData({
    required this.hid,
    required this.catId,
    required this.catName,
    required this.heading,
    required this.indexing,
    required this.isActive,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      hid: json['HID'],
      catId: json['CatId'],
      catName: json['CatName'] ?? '',
      heading: json['Heading'],
      indexing: json['Indexing'],
      isActive: json['IsActive'],
    );
  }
}

class TrendingProduct extends StatefulWidget {
  @override
  _TrendingProductState createState() => _TrendingProductState();
}

class _TrendingProductState extends State<TrendingProduct> {
  final String customerId = '';
  List<dynamic> products = [];
  final APIService apiService = APIService();

  @override
  void initState() {
    super.initState();
    fetchProductsForAllCategories();
  }

  Future<void> fetchProductsForAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/category/getcatgorytop'),
      );

      if (response.statusCode == 200) {
        final List<CategoryData> categories = (json.decode(response.body) as List)
            .map((data) => CategoryData.fromJson(data))
            .toList();

        for (CategoryData category in categories) {
          final response = await http.post(
            Uri.parse('$apiUrl/category/getCatwithid'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'MainCategoryCode': category.catId,
            }),
          );

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            print('Response data for category ${category.catId}: $responseData');

            if (responseData is List) {
              setState(() {
                products.addAll(responseData);
              });
            } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
              final data = responseData['data'];
              if (data is List) {
                setState(() {
                  products.addAll(data);
                });
              } else {
                print('Unexpected data format: $data');
              }
            } else {
              print('Unexpected response format for category ${category.catId}: $responseData');
            }
          } else {
            print('Failed to load products for category ${category.catId}: ${response.statusCode}');
          }
        }
      } else {
        print('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
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
    double? regularPrice = parsePrice(product['RegularPrice']);
    double? onlinePrice = parsePrice(product['OnlinePrice']);
    double? discountPercentage;

    if (regularPrice != null && onlinePrice != null && regularPrice > onlinePrice) {
      discountPercentage = calculateDiscountPercentage(regularPrice, onlinePrice);
    }

    bool isFavorited = false;

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
        child: Column(
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
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
                        return Icon(Icons.star, color: Colors.green, size: 15);
                      }
                    }),
                  ),
                ],
              ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Products'),
      ),
      body: products.isNotEmpty
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return buildProductCard(products[index]);
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class APIService {
  Future<void> addToWishlist(String customerId, String productId) async {
    final url = Uri.parse('$apiUrl/wishlist');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'CustomerID': customerId,
        'ProductID': productId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  }
}
