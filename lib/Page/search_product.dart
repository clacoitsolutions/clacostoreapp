import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];

  Future<void> _searchProducts(String searchText) async {
    String apiUrl = 'https://clacostoreapi.onrender.com/SearchProduct';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'SearchText': searchText,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _searchResults = data['data'];
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch search results. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      _searchProducts(searchText);
      setState(() {
        _isSearching = true;
      });
    } else {
      setState(() {
        _isSearching = false;
        _searchResults.clear(); // Clear search results if search text is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFA2365),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for products...',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _onSearchTextChanged();
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _searchProducts(value);
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.mic, color: Colors.grey),
                onPressed: () {
                  // Implement voice search functionality
                },
              ),
            ],
          ),
        ),
      ),
      body: _isSearching
          ? _buildSearchResults()
          : Center(
        child: Text('Start searching by entering a keyword.'),
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: EdgeInsets.all(8.0), // Adjusted padding around the GridView
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0, // Reduced spacing between cards horizontally
        mainAxisSpacing: 8.0, // Reduced spacing between rows vertically
        childAspectRatio: 0.7, // Adjusted aspect ratio for better mobile view
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        var product = _searchResults[index];
        String productName = product['ProductName'];
        if (productName.length > 20) {
          productName = productName.substring(0, 20) + '...';
        }

        String regularPrice = product['RegularPrice'].toString();
        String salePrice = product['SalePrice'].toString();

        // Calculate percentage discount
        double regularPriceValue = double.parse(regularPrice);
        double salePriceValue = double.parse(salePrice);
        double discountPercentage = ((regularPriceValue - salePriceValue) / regularPriceValue) * 100;

        // Check if there's a discount to display
        bool hasDiscount = discountPercentage > 0;

        return Card(
          elevation: 7,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.network(
                  product['ProductMainImageUrl'],
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          ' ₹${salePrice}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          ' ₹${regularPrice}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    if (hasDiscount)
                      Text(
                        '${discountPercentage.toStringAsFixed(0)}% off', // Display percentage discount
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 4),
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
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
