import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/service_api.dart';

class HomeCategory extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<HomeCategory> {
  late Future<List<Map<String, dynamic>>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = APIService.fetchCategories(); // Using the API provider
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
        } else if (snapshot.hasData) {
          return SlidingCategoryList(categories: snapshot.data!);
        } else {
          return Center(child: Text("No data available"));
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
      height: 150,
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
              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
  String? selectedSrNo;

  @override
  void initState() {
    super.initState();
    getCategoryDetails();
  }

  void getCategoryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategoryName = prefs.getString('selectedCategoryName');
      selectedSrNo = prefs.getString('selectedSrNo');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategoryName ?? "Category Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Category Name: $selectedCategoryName',
            ),
            Text(
              'SrNo: $selectedSrNo',
            ),
          ],
        ),
      ),
    );
  }
}
