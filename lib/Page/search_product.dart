import 'package:flutter/material.dart';
import 'filter_page.dart';
import 'package:claco_store/models/Category_filter.dart';

class SearchProduct extends StatefulWidget {
  final List<dynamic> products;
  final List<CategoryProduct> categoryProducts;

  SearchProduct({Key? key, required this.products, required this.categoryProducts}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isAdditionalRowVisible = false;
  List<CategoryProduct> filteredCategoryProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isAdditionalRowVisible = _searchController.text.isNotEmpty;
      _isSearching = _searchController.text.isNotEmpty;
      // filteredCategoryProducts = widget.categoryProducts
      //     .where((categoryProduct) =>
      //     categoryProduct.productCategory.toLowerCase().contains(_searchController.text.toLowerCase()))
      //     .toList();
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
                padding: const EdgeInsets.only(right: 10.0), // Adjust right padding as needed
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Filter()),
                    );
                  },
                  icon: Icon(Icons.filter_list, color: Colors.black, size: 14,),
                  label: Text(
                    "Filter",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _isAdditionalRowVisible,
            child: _buildAdditionalRow(),
          ),
          _isSearching ? _buildSearchResults() : _buildInitialProducts(),
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
            child: _buildProductCard(
              name: 'Model Black saari...',
              imageUrl: 'https://cdn.pixabay.com/photo/2017/06/06/23/57/birds-2378923_640.jpg',
              price: '₹ 3000',
              rating: ' 4.8',
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildProductCard(
              name: 'Model White T-shirt...',
              imageUrl: 'https://cdn.pixabay.com/photo/2016/11/18/17/42/barbecue-1836053_640.jpg',
              price: '₹ 500',
              rating: ' 4.6',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialProducts() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.75, // Adjust this ratio as per your needs
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          var product = widget.products[index];
          return GestureDetector(
            onTap: () {
              _navigateToProductDetail(product);
            },
            child: _buildProductCard(
              name: product['ProductName'],
              imageUrl: product['ProductMainImageUrl'],
              price: '₹ ${product['SalePrice']}',
              rating: ' ${product['Rating']}',
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredCategoryProducts.length,
        itemBuilder: (context, index) {
          var categoryProduct = filteredCategoryProducts[index];
          return _buildCategoryProductCard(categoryProduct: categoryProduct);
        },
      ),
    );
  }

  Widget _buildCategoryProductCard({required CategoryProduct categoryProduct}) {
    return GestureDetector(
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    categoryProduct.catImg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    categoryProduct.productCategory,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String imageUrl,
    required String price,
    required String rating,
  }) {
    return Container(
      height: 100, // Set desired height for the container
      width: 100, // Set desired width for the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0, // Ensure aspect ratio is square
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
                      fontSize: 9,
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.star,
                        color: Colors.green,
                        size: 12, // Adjust the size as needed
                      ),
                    ),
                    SizedBox(width: 2),
                    Text(
                      rating,
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }




  void _navigateToProductDetail(product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              product['ProductMainImageUrl'],
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Regular Price: ₹ ${product['RegularPrice']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Sale Price: ₹ ${product['SalePrice']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryProductDetailsPage extends StatelessWidget {
  final CategoryProduct categoryProduct;

  CategoryProductDetailsPage({Key? key, required this.categoryProduct}) : super(key: key);

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