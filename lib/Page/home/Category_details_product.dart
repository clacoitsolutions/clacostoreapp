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
            return Card(
              elevation: 5,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product['ProductMainImageUrl'],
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product['ProductName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                 child:  Row(
                    children: [
                      Text(
                        'Price: ₹${product['OnlinePrice']}', // Product price with null check
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 3),
                      Text(
                        ' ₹${product['RegularPrice']}', // Product price with null check
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
              ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
