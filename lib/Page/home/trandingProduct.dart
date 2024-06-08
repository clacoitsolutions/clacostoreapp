import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrendingProduct extends StatefulWidget {
  @override
  _TrendingProductState createState() => _TrendingProductState();
}

class _TrendingProductState extends State<TrendingProduct> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/category/getCatwithid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'MainCategoryCode': '13',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        products = responseData['data'] ?? [];
      });
    } else {
      // Handle the error
      throw Exception('Failed to load products');
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
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 5), // changes position of shadow
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
              height: 125,
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

                SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    'Price: ₹${product['OnlinePrice']}', // Product price with null check
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 3,),
                  Text(
                    ' ₹${product['RegularPrice']}', // Product price with null check
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough
                    ),
                  ),
                ],
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
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10), // Border radius for all sides
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 8), // Add top padding here
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deal of the Day',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 16, // Adjust the size as needed
                              ),
                              SizedBox(width: 4), // Add some space between the icon and the text
                              Text(
                                '22h 55m 20s remaining',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10, // Add space between text and button
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10), // Add padding to the right
                      child: ElevatedButton(
                        onPressed: () {
                          // Add functionality for the button
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent.withOpacity(0.8),
                          side: const BorderSide(color: Colors.white), // Add border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3), // Border radius for button
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('View all'),
                            Icon(Icons.arrow_forward), // Right arrow icon
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15), // Add space between images
        products.isNotEmpty
            ? GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7, // Adjust the aspect ratio as needed
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return buildProductCard(products[index]);
          },
        )
            : CircularProgressIndicator(),
        const SizedBox(height: 20),
      ],
    );
  }
}
