import 'package:claco_store/models/sizemodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryDetailPage extends StatefulWidget {
  final String srNo;

  CategoryDetailPage({required this.srNo});

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late Future<List<Data>> futureProductDetails;

  @override
  void initState() {
    super.initState();
    futureProductDetails = fetchProductDetails(widget.srNo);
  }

  Future<List<Data>> fetchProductDetails(String srNo) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/category/getCatwithid'),
        body: {
          "MainCategoryCode": srNo,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('data')) {
          List<dynamic> data = jsonResponse['data'];

          List<Data> products =
              data.map((item) => Data.fromJson(item)).toList();
          return products;
        } else {
          throw Exception('Failed to load product details: No data found');
        }
      } else {
        throw Exception(
            'Failed to load product details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product details: $e');
      throw Exception('Failed to load product details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Detail'),
      ),
      body: FutureBuilder<List<Data>>(
        future: futureProductDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Data productDetail = snapshot.data![index];
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                          productDetail.productMainImageUrl,
                          width: double.infinity,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          productDetail.productName,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Price: \$${productDetail.regularPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Description:',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          productDetail.productDescription,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Delivery Time: ${productDetail.deliveryTime}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
