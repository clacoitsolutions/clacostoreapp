import 'dart:async';

import 'package:claco_store/Page/Category_Page.dart';
import 'package:claco_store/Page/product_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'filter_page.dart';
import 'package:claco_store/models/Category_filter.dart';
import 'package:claco_store/models/sizemodel.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  String _text = '';
  Timer? _listenTimer;
  List<dynamic> _filteredProducts = [];
  List<dynamic> _searchResults = [];
  bool _isSearching = false;


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
  Future<void> saveProductDetailsAndNavigate( String? productId) async {
    if ( productId == null) {
      print(' productId = $productId');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ProductCode', productId);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetails(productId: productId)),
      );
    } catch (e) {
      print('Error saving product details: $e');
    }
  }
  Future<void> saveProductToRecent(dynamic product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentProducts = prefs.getStringList('recentProducts') ?? [];

    String productJson = jsonEncode(product);

    recentProducts.removeWhere((item) => item == productJson);
    recentProducts.add(productJson);

    if (recentProducts.length > 10) {
      recentProducts = recentProducts.sublist(recentProducts.length - 10);
    }

    await prefs.setStringList('recentProducts', recentProducts);
  }


  @override
  void initState() {
    super.initState();
    _initSpeech();
    _filteredProducts = widget.products;
    _searchController.addListener(_filterProducts);
    _searchController.addListener(_onSearchTextChanged);

  }





  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {});
    } else {
      // Handle initialization error
      print("The user has denied the use of speech recognition.");
    }
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




  void _stopListening() async {
    _listenTimer?.cancel();
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = widget.products
          .where((product) => product
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList();
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
            : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
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
                  label: const Text(
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

        return GestureDetector(
            onTap: () {

          final productId = product['ProductCode']?.toString();
          saveProductToRecent(product).then((_) {
            saveProductDetailsAndNavigate( productId);
          });
        },
         child: Card(
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
                          ' ₹${regularPrice}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                        SizedBox(width: 3),
                        Text(
                          ' ₹${salePrice}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
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
                      children: List.generate(5, (index) {
                        if (product['Avg'] != null && product['Avg'] >= index + 1) {
                          return Icon(Icons.star, color: Colors.green, size: 15);
                        } else {
                          return Icon(Icons.star_border, color: Colors.green, size: 15);
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        );
      },
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
