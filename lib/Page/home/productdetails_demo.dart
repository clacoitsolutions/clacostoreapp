import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? srno;
  String? productId;
  Map<String, dynamic>? productDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProductDetails();
  }

  Future<void> loadProductDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      productId = prefs.getString('productId');
    });

    if (productId != null) {
      await fetchProductDetails( productId!);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProductDetails( String productId) async {
    final url = 'https://clacostoreapi.onrender.com/getProductDetails';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'CatId': srno, 'productId': productId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        productDetails = json.decode(response.body)['data'][0];
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Failed to load product details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : productDetails == null
            ? Text('Failed to load product details')
            : SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  productDetails!['ProductMainImageUrl'] ?? '',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                productDetails!['ProductName']?.length > 30
                    ? '${productDetails!['ProductName']!.substring(0, 30)}...' // Truncate if length exceeds 30 characters
                    : productDetails!['ProductName'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    ' ₹${productDetails!['SalePrice']}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(width: 4),
                  Text(
                    ' ₹${productDetails!['RegularPrice']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                productDetails!['ProductDescription'] ?? 'No description',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Delivery Time: ${productDetails!['DeliveryTime']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Product Category: ${productDetails!['ProductCategory']}',
                style: TextStyle(fontSize: 16),
              ),
              // Add more fields as required
            ],
          ),
        ),
      ),
    );
  }
}
