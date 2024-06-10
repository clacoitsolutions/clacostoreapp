import 'package:claco_store/Page/home/productdetails_demo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api services/service_api.dart';
import '../product_details.dart';

class TrendingProduct extends StatefulWidget {
  @override
  _TrendingProductState createState() => _TrendingProductState();
}

class _TrendingProductState extends State<TrendingProduct> {
  List<dynamic> products = [];
  final APIService apiService = APIService();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await apiService.fetchProducts('13');
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      // Handle the error
      print(e);
    }
  }

  Future<void> saveProductDetailsAndNavigate(String? srno, String? productId) async {
    if (srno == null || productId == null) {
      print('Invalid product details: srno = $srno, productId = $productId');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('SrNo', srno);
      await prefs.setString('ProductCode', productId);
      print('Product details saved: SrNo = $srno, ProductCode = $productId');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetails()),
      );
    } catch (e) {
      print('Error saving product details: $e');
    }
  }

  double calculateDiscountPercentage(double regularPrice, double salePrice) {
    return ((regularPrice - salePrice) / regularPrice) * 100;
  }

  double? parsePrice(dynamic price) {
    if (price is String) {
      return double.tryParse(price);
    } else if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    }
    return null;
  }
  Widget buildProductCard(dynamic product) {
    double? regularPrice = parsePrice(product?['RegularPrice']);
    double? salePrice = parsePrice(product?['SalePrice']);
    double? discountPercentage;

    if (regularPrice != null && salePrice != null) {
      discountPercentage = calculateDiscountPercentage(regularPrice, salePrice);
    }

    return GestureDetector(
      onTap: () {
        final srno = product['SrNo']?.toString();
        final productId = product['ProductCode']?.toString();
        print('Product card tapped: ${product['ProductName']}');
        saveProductDetailsAndNavigate(srno, productId);
      },
      child: Container(
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  child: Image.network(
                    product['ProductMainImageUrl'] ?? '', // Use product's image URL with null check
                    width: double.infinity,
                    height: 120,
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
                      SizedBox(height: 4),
                      Row(
                        children: [
                          if (regularPrice != null && salePrice != null && regularPrice > salePrice)
                          Text(
                            '  ${product['RegularPrice']}', // Product price with null check
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(
                            ' ₹${product['SalePrice']}', // Product price with null check
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      if (discountPercentage != null && discountPercentage > 0)
                        Text(
                          '${discountPercentage.toStringAsFixed(2)}% off',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
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
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.favorite_border), // Use your heart icon here
                onPressed: () {
                  // Handle heart icon click event
                  print('Heart clicked for product: ${product['ProductName']}');
                },
              ),
            ),
          ],
        ),
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
