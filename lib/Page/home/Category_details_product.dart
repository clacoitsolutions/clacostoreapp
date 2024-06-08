import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    for (String srNo in widget.srNoList) {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/category/getCatwithid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'MainCategoryCode': srNo,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          products.addAll(json.decode(response.body)['data']);
        });
      } else {
        throw Exception('Failed to load products');
      }
    }
  }

  Widget buildProductCard(dynamic product) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            child: Image.network(
              product['ProductMainImageUrl'] ?? '', // Use product's image URL with null check
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4), // Adjust padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['ProductName'] ?? 'No name', // Product name with null check
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: ₹${product['OnlinePrice']}', // Product price with null check
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
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
                        fontSize: 15,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategoryName ?? "Category Details"),
      ),
      body: Center(
        child: products.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: buildProductCard(product),
            );
          },
        ),
      ),
    );
  }
}
