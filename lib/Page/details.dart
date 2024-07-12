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
      final body = json.encode({"MainCategoryCode": srNo});
      print("Request body: $body");

      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/category/getCatwithid'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

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
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Data productDetail = snapshot.data![index];
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Image.network(
                            productDetail.productMainImageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          productDetail.productName.split(' ').length >= 4
                              ? '${productDetail.productName.split(' ').take(4).join(' ')}...'
                              : productDetail.productName,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4.0),
                        Text(
                          'Price: \₹${productDetail.regularPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 10.0),
                        ),
                        // SizedBox(height: 4.0),
                        // Text(
                        //   'Delivery Time: ${productDetail.deliveryTime}',
                        //   style: TextStyle(fontSize: 12.0),
                        // ),
                      ],
                    ),
                  ),
                );
              },
              padding: EdgeInsets.all(10.0),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
