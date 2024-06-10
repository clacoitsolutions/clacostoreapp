import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/service_api.dart';
import 'Category_details_product.dart';

class HomeCategory extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<HomeCategory> {
  late Future<List<Map<String, dynamic>>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = APIService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SlidingCategoryList(categories: snapshot.data!);
        } else {
          return Center(child: Text("No categories available"));
        }
      },
    );
  }
}

class SlidingCategoryList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const SlidingCategoryList({
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('selectedCategoryName', categories[index]['ProductCategory']);
              prefs.setString('selectedSrNo', categories[index]['SrNo'].toString());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailsPage(
                    categoryName: categories[index]['ProductCategory'],
                    srNoList: [categories[index]['SrNo'].toString()],
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5),
              child: Column(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        categories[index]['CategoryImage'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 65,
                            height: 65,
                            color: Colors.grey,
                            child: Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    categories[index]['ProductCategory'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
