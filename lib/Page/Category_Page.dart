import 'package:claco_store/Page/details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/categorymodel.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategories;

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
        Uri.parse('https://clacostoreapi.onrender.com/category/getCategory'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: snapshot.data![index]);
              },
              padding: EdgeInsets.all(10.0),
            );
          } else {
            return Center(child: Text('No categories available'));
          }
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('SrNo', category.srNo);
          print('srNo stored: ${category.srNo}');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(srNo: category.srNo),
            ),
          );
        } catch (e) {
          print('Error storing srNo: $e');
        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image.network(
                category.categoryImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Text(
              'SrNo: ${category.srNo}', // Display srNo
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                category.productCategory,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
