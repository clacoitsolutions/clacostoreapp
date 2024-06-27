import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Api services/service_api.dart';

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

  Future<void> fetchProducts() async {
    try {
      List<dynamic> fetchProductsdetails = await APIService.fetchProductsdetails(widget.srNoList as List<String>);
      setState(() {
        products.addAll(fetchProductsdetails);
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
          selectedCategoryName ?? "Category Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink, // Set the background color to pink
        iconTheme: IconThemeData(color: Colors.white), // Set the color of the back arrow button to white
      ),
      body: Center(
        child: products.isEmpty
            ? CircularProgressIndicator()
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            childAspectRatio: 0.7, // Adjust this value to change the card size ratio
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final regularPrice = product['RegularPrice'];
            final salePrice = product['SalePrice'];
            final discountPercentage = ((regularPrice - salePrice) / regularPrice) * 100;

            return Card(
              elevation: 5,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                                      '  ${product['RegularPrice']}', // Product price with null check
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
                                    product['Avg']?.toString() ?? '', // Product rating with null check
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
          },
        ),
      ),
    );
  }
}
