import 'dart:async';

import 'package:claco_store/Page/Category_Page.dart';
import 'package:flutter/material.dart';
import 'filter_page.dart';
import 'package:claco_store/models/Category_filter.dart';
import 'package:claco_store/models/sizemodel.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchProduct extends StatefulWidget {
  final List<dynamic> products;
  final List<CategoryProduct> categoryProducts;
  final List<RatingModel> ratingProducts;
  final List<DiscountModel> discountproducts;
  final List<SizeModel> sizeProducts;

  SearchProduct({
    Key? key,
    required this.products,
    required this.categoryProducts,
    required this.ratingProducts,
    required this.discountproducts,
    required this.sizeProducts,
  }) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController _searchController = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Search for products...';
  Timer? _listenTimer;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speech.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });

      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
          _searchController.text = _text;
        });
      });

      _listenTimer = Timer(Duration(seconds: 5), () {
        _stopListening();
      });
    }
  }

  void _stopListening() async {
    _listenTimer?.cancel();
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
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
                  setState(() {});
                },
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _text, // Display recognized text here
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: AvatarGlow(
                  animate: _isListening,
                  glowColor: Colors.pink,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  if (_isListening) {
                    _stopListening();
                  } else {
                    _startListening();
                  }
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Implement short functionality
                },
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                label: Text(
                  "Short",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 10.0), // Adjust right padding as needed
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Filter()),
                    );
                  },
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.black,
                    size: 14,
                  ),
                  label: Text(
                    "Filter",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            // Use Expanded to fill available space
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (widget.products.isNotEmpty) {
      return _buildProductGrid(widget.products);
    } else if (widget.categoryProducts.isNotEmpty) {
      // Show _buildCategoryGrid ONLY if it's the intended filter
      return _buildCategoryGrid(widget.categoryProducts);
    } else if (widget.ratingProducts.isNotEmpty) {
      return _buildRatingGrid(widget.ratingProducts);
    } else if (widget.discountproducts.isNotEmpty) {
      return _buildDiscountGrid(widget.discountproducts);
    } else if (widget.sizeProducts.isNotEmpty) {
      return _buildSizeGrid(widget.sizeProducts);
    } else {
      // No filter applied or no data for any filter
      return CategoryScreen();
    }
  }

  Widget _buildProductGrid(List<dynamic> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        var product = products[index];
        return GestureDetector(
          onTap: () {
            _navigateToProductDetail(context, product);
          },
          child: _buildProductCard(
            name: _truncateProductName(product['ProductName'], 4),
            imageUrl: product['ProductMainImageUrl'],
            price: '₹ ${product['SalePrice']}',
          ),
        );
      },
    );
  }

  Widget _buildCategoryGrid(List<CategoryProduct> categories) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var category = categories[index];
        return _buildCategoryCard(category: category);
      },
    );
  }

  Widget _buildRatingGrid(List<RatingModel> ratings) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        var rating = ratings[index];
        return _buildRatingCard(rating: rating);
      },
    );
  }

  Widget _buildDiscountGrid(List<DiscountModel> discounts) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        var discount = discounts[index];
        return _buildDiscountCard(discount: discount);
      },
    );
  }

  Widget _buildSizeGrid(List<SizeModel> sizes) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        var size = sizes[index];
        return GestureDetector(
          onTap: () {
            _navigateToSizeDetailPage(context, size);
          },
          child: _buildSizeCard(size: size, context: context),
        );
      },
    );
  }

  Widget _buildRatingCard({required RatingModel rating}) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (rating.image != null)
              Image.network(
                rating.image, // Assuming 'image' is a String with the image URL
                height: 130, // Adjust height as needed
                width: 100, // Adjust width as needed
                fit: BoxFit.cover, // You might need to adjust the fit property
              ),
            SizedBox(height: 2.0),
            Text(
              ' ${rating.CustomertName ?? 'N/A'}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.0),
            Text(
              'Rating: ${rating.ReviewStatus} stars',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 2.0),
            Text(
              'Review: ${rating.ReviewDiscription ?? ''}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String imageUrl,
    required String price,
  }) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    price,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 4.0),
                //       child: Icon(
                //         Icons.star,
                //         color: Colors.green,
                //         size: 12,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountCard({required DiscountModel discount}) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            // Wrap Image.network in a SizedBox
            height: 130,
            width: 100,
            child: Image.network(
              discount.ProductMainImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _truncateProductName(discount.ProductName, 4),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.0),
                Text(
                  '₹${discount.SalePrice}',
                  style: TextStyle(fontSize: 12.0),
                ),
                SizedBox(height: 1.0),
                Text(
                  'Discount : ${_formatDiscount(discount.DiscountPercentage)}%',
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDiscount(double discountPercentage) {
    // You can format the discount percentage as needed here
    // For example, to always show two decimal places:
    return discountPercentage.toStringAsFixed(2);
  }

  Widget _buildCategoryCard({required CategoryProduct category}) {
    return GestureDetector(
      onTap: () {
        // Handle navigation to category details if needed
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                category.catImg,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                category.productCategory,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductDetail(context, product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  String _truncateProductName(String productName, int maxWords) {
    List<String> words = productName.split(' ');
    if (words.length <= maxWords) {
      return productName;
    } else {
      return '${words.sublist(0, maxWords).join(' ')}...';
    }
  }
}

Widget _buildSizeCard(
    {required BuildContext context, required SizeModel size}) {
  return GestureDetector(
    onTap: () {
      _navigateToSizeDetailPage(context, size); // Pass context and size data
    },
    child: Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              size.ProductMainImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  size.ProductName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  '₹${size.SalePrice}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                // ... Add more details from your SizeModel as needed ...
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _navigateToSizeDetailPage(context, size) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SizeDetailPage(size: size),
    ),
  );
}

class ProductDetailPage extends StatelessWidget {
  final product;

  ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['ProductName']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: Image.network(
                product['ProductMainImageUrl'],
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductNameWidget(product['ProductName']),
                  _buildDetailRow(
                      'Regular Price:', '₹ ${product['RegularPrice']}'),
                  _buildDetailRow(
                    'Product Type:',
                    product['ProductType'],
                  ),
                  _buildDetailRow('Discount:', '${product['Discper']}%'),
                  _buildDetailRow('Category:', product['ProductCategory']),
                  // Add more detail rows as needed using _buildDetailRow
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product['ProductDescription'],
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the product name widget
  Widget _buildProductNameWidget(String productName) {
    List<String> words = productName.split(' ');
    if (words.length <= 4) {
      // If 4 words or less, display as a single line
      return _buildDetailRow('Product Name:', productName);
    } else {
      // If more than 4 words, split into two lines
      String firstLine = words.sublist(0, 4).join(' ');
      String secondLine = words.sublist(4).join(' ');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Product Name:', firstLine),
          _buildDetailRow('', secondLine), // Empty label for second line
        ],
      );
    }
  }

  // Helper function to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class CategoryProductDetailsPage extends StatelessWidget {
  final CategoryProduct categoryProduct;

  CategoryProductDetailsPage({Key? key, required this.categoryProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryProduct.productCategory),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              categoryProduct.catImg,
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Number of Products: ${categoryProduct.cnt}', // Display the count of products in this category
              style: TextStyle(fontSize: 18),
            ),
            // Add other details about the category product as needed
          ],
        ),
      ),
    );
  }
}

class SizeDetailPage extends StatelessWidget {
  final SizeModel size;

  SizeDetailPage({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(size.ProductName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: Image.network(
                size.ProductMainImageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Product Code:', size.ProductCode),
                  _buildDetailRow('Product Name:', size.ProductName),
                  _buildDetailRow('Regular Price:', '₹ ${size.RegularPrice}'),
                  _buildDetailRow('Sale Price:', '₹ ${size.SalePrice}'),
                  _buildDetailRow('Product Type:', size.ProductType),
                  _buildDetailRow('Discount:', '${size.DiscPer}%'),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    size.ProductDescription,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
