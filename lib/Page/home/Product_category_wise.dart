import 'dart:convert';
import 'package:claco_store/Page/home/trandingProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryWiseProduct extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CategoryWiseProduct({
    this.padding = const EdgeInsets.all(8.0),
    this.margin = const EdgeInsets.all(8.0),
  });

  @override
  _CategoryWiseProductState createState() => _CategoryWiseProductState();
}

class _CategoryWiseProductState extends State<CategoryWiseProduct> {
  final String baseUrl = 'https://clacostoreapi.onrender.com';

  Future<List<Map<String, String>>> fetchCategories() async {
    final response =
    await http.get(Uri.parse('$baseUrl/category/getcatgorytop'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> categories = [];
      for (var category in data['cities']) {
        categories.add({
          'CatName': category['CatName'],
          'CatId': category['CatId'],
        });
      }
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories().then((categories) {
      setState(() {
        // Update the UI with fetched categories
        // No need to navigate here, just set the state
      });
    }).catchError((error) {
      print('Error fetching categories: $error');
      // Handle error scenario, e.g., show an error message
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Navigate to TrendingProduct widget passing fetched categories
          return TrendingProduct(categories: snapshot.data!);
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
