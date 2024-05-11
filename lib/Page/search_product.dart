import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isAdditionalRowVisible = false; // Variable to track additional row visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFA2365), // Set background color to #FA2365
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back when arrow is pressed
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
                icon: Icon(Icons.search, color: Colors.grey), // Search icon
                onPressed: () {
                  setState(() {
                    _isSearching = true; // Start searching
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
                    setState(() {
                      _isAdditionalRowVisible = value.isNotEmpty; // Toggle additional row visibility
                    });
                    // Implement search functionality
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.mic, color: Colors.grey), // Mic icon
                onPressed: () {
                  // Implement voice search functionality
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Popular Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Implement short functionality
                },
                icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                label: Text("Short",style: TextStyle(color: Colors.black),),
              ),
              TextButton.icon(
                onPressed: () {
                  // Implement filter functionality
                },
                icon: Icon(Icons.filter_list,color: Colors.black,),
                label: Text("Filter",style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
          Visibility(
            visible: _isAdditionalRowVisible, // Toggle visibility based on text input
            child: _buildAdditionalRow(),
          ),
          _isSearching ? _buildSearchResults() : _isAdditionalRowVisible ? Container() : _buildInitialProducts(), // Conditionally show the three-column row
        ],
      ),
    );
  }

  Widget _buildAdditionalRow() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildProductCard1(
              'Model Black saari...',
              'https://cdn.pixabay.com/photo/2017/06/06/23/57/birds-2378923_640.jpg',
              '₹ 3000', // ₹ symbol for rupee
              ' 4.8',
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildProductCard1(
              'Model White T-shirt...',
              'https://cdn.pixabay.com/photo/2016/11/18/17/42/barbecue-1836053_640.jpg',
              '₹ 500', // ₹ symbol for rupee
              ' 4.6',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialProducts() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildProductCard(
                  'Model Black saari...',
                  'https://cdn.pixabay.com/photo/2017/06/06/23/57/birds-2378923_640.jpg',
                   ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildProductCard(
                  'Model  Black saari...',
                  'https://cdn.pixabay.com/photo/2016/11/18/17/42/barbecue-1836053_640.jpg',
                                 ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildProductCard(
                  'Model Black saari...',
                  'https://cdn.pixabay.com/photo/2017/06/06/23/57/birds-2378923_640.jpg',

                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    // Implement the UI for search results
    return Container();
  }
  Widget _buildProductCard1(String name, String imageUrl, String price, String rating) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 130,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      // Rupee icon
                      SizedBox(width: 5),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.green), // Rating icon
                      SizedBox(width: 5),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProductCard(String name, String imageUrl,) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 130,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
