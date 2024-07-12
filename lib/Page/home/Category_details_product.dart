import 'package:claco_store/Page/product_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/service_api.dart';


class CategoryDetailsPage extends StatefulWidget {
  final String categoryName;
  final List<String> srNoList;

  const CategoryDetailsPage({
    required this.categoryName,
    required this.srNoList,
  });

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  String? selectedCategoryName;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    getCategoryDetails();
    fetchProducts();
  }

  void getCategoryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategoryName = prefs.getString('selectedCategoryName') ?? widget.categoryName;
    });
  }

  Future<void> _navigateToProductDetail(String productId, String srno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SrNo', srno);
    await prefs.setString('ProductCode', productId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(productId: productId),
      ),
    );
  }

  Future<void> fetchProducts() async {
    try {
      List<dynamic> fetchProductsdetails = await APIService.fetchProductsdetails(widget.srNoList);
      setState(() {
        products.addAll(fetchProductsdetails);
      });
    } catch (e) {
      print('Error fetching products: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: products.isEmpty
            ? CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 5  ,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final regularPrice = product['RegularPrice'];
              final salePrice = product['SalePrice'];
              final discountPercentage =
                  ((regularPrice - salePrice) / regularPrice) * 100;

              return GestureDetector(
                onTap: () => _navigateToProductDetail(
                  product['ProductCode'],
                  product['SrNo'],
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(2, 2,),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            product['ProductMainImageUrl'] ?? '',
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['ProductName'] ?? '',
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
                                  if (regularPrice != null &&
                                      salePrice != null &&
                                      regularPrice > salePrice)
                                    Text(
                                      '₹${product['RegularPrice']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.redAccent,
                                        decoration:
                                        TextDecoration.lineThrough,
                                          decorationColor: Colors.red,
                                      ),
                                    ),
                                  SizedBox(width: 3),
                                  Text(
                                    '₹${product['SalePrice']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              if (discountPercentage != null &&
                                  discountPercentage > 0)
                                Text(
                                  '${discountPercentage.toStringAsFixed(2)}% off',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  5,
                                      (index) => Icon(
                                    Icons.star,
                                    color: Colors.green,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
