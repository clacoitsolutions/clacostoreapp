import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'search_product.dart';
import 'package:claco_store/models/filter_price.dart';
import 'package:claco_store/models/Category_filter.dart';
import 'package:claco_store/models/sizemodel.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String selectedText =
      'Gender'; // Track the selected text and set "Gender" as default
  bool showGenderOptions = false; // Track whether to show gender options or not
  bool? isMaleChecked; // Track the state of Male checkbox
  bool? isFemaleChecked; // Track the state of Female checkbox
  bool? isGirlsChecked; // Track the state of Girls checkbox
  bool? isBoysChecked; // Track the state of Boys checkbox
  bool? isUnisexChecked; // Track the state of Unisex checkbox
  bool? isBabyBoysChecked; // Track the state of Baby Boys checkbox
  bool? isWomenChecked = false; // Add this line
  bool? isKidsChecked = false; // Add this line
  bool? isMensChecked = false; // Add this line
  bool isRs399BelowChecked =
      false; // Track the state of Rs. 399 and Below checkbox
  bool isRs500BelowChecked =
      false; // Track the state of Rs. 500 and Below checkbox
  bool isRs500To999Checked =
      false; // Track the state of Rs. 500 To Rs. 999 checkbox
  bool isRs1000To1500Checked =
      false; // Track the state of Rs. 1000 To Rs. 1500 checkbox
  bool isRs1500To2000Checked =
      false; // Track the state of Rs. 1500 To Rs. 2000 checkbox
  bool? isBrand1;
  bool? isBrand2;
  bool? isBrand3;
  bool? isSize1;
  bool? isSize2;
  bool? isSize3;
  bool? is4Star;
  bool? is3Star;
  bool? is30Discount;
  bool? is40Discount;
  bool? is50Discount;
  bool? isSpecialPrice;
  bool? isBySave;
  bool? isWhite;
  bool? isBlue;
  bool? isBlack;
  bool? isGrey;
  bool? isRed;

  List<dynamic> products = [];
  List<CategoryProduct> categoryProducts = [];
  List<RatingModel> ratingProducts = [];
  List<DiscountModel> discountproducts = [];
  List<SizeModel> sizeProducts = [];

  /// API Start //////////////////////////////////////////////////////////////

  ///  Price Filter APi ////

  Future<List<dynamic>> fetchData(String min, String max) async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/getProductDetailsprice'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Max': max,
        'Min': min,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load products');
    }
  }

  ///  Ratings Filter APi ////

  Future<void> fetchRatingData(String rating) async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/getrating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rating': rating,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        // Convert the fetched JSON data into CategoryProduct objects
        ratingProducts = (jsonDecode(response.body)['data'] as List)
            .map((json) => RatingModel.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load rating products');
    }
  }

  ///  Category Filter APi ////

  Future<void> fetchCategoryData() async {
    final response = await http.get(
      Uri.parse('https://clacostoreapi.onrender.com/Bindmain'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Convert the fetched JSON data into CategoryProduct objects
      setState(() {
        // Convert the fetched JSON data into CategoryProduct objects
        categoryProducts = (jsonDecode(response.body)['data'] as List)
            .map((json) => CategoryProduct.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load category products');
    }
  }

  ///  Discount Filter APi ////

  Future<void> fetchDiscount(String discountPercentage) async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/offermaster'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'DiscountPercentage': discountPercentage,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        discountproducts = (jsonDecode(response.body)['data'] as List)
            .map((json) => DiscountModel.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load offer products');
    }
  }

  ///  Size API

  Future<void> fetchSize(String sizeCode) async {
    final response = await http.post(
      Uri.parse('https://clacostoreapi.onrender.com/getSize'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sizecode': sizeCode,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        sizeProducts = (jsonDecode(response.body)['data'] as List)
            .map((json) => SizeModel.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load size products');
    }
  }

  ////////////////// API End ///////////////////

  void applyFilter() async {
    List<dynamic> filteredProducts = [];
    List<DiscountModel> discountmodel = [];
    List<SizeModel> sizemodel = [];
    List<RatingModel> ratemodel = [];
    List<CategoryProduct> categorymodel = [];

    if (selectedText == 'Price') {
      if (isRs399BelowChecked) {
        filteredProducts = await fetchData('1', '399');
      } else if (isRs500BelowChecked) {
        filteredProducts = await fetchData('1', '500');
      } else if (isRs500To999Checked) {
        filteredProducts = await fetchData('500', '999');
      } else if (isRs1000To1500Checked) {
        filteredProducts = await fetchData('1000', '1500');
      } else if (isRs1500To2000Checked) {
        filteredProducts = await fetchData('1500', '2000');
      } else {
        filteredProducts = await fetchData(
            '1', '5000'); // Default case if no checkbox is selected
      }
    } else if (selectedText == 'Category') {
      await fetchCategoryData();
      categorymodel = categoryProducts;
    } else if (selectedText == 'Customer Rating') {
      if (is4Star == true) {
        await fetchRatingData('4');
        ratemodel = ratingProducts;
      } else if (is3Star == true) {
        await fetchRatingData(
            '3'); // Assuming API accepts "3" for 3 stars and above
        ratemodel = ratingProducts;
      }
    } else if (selectedText == 'Discount') {
      if (is30Discount == true) {
        await fetchDiscount('30'); // Fetch products with 30% or more discount
        discountmodel = discountproducts;
      } else if (is40Discount == true) {
        await fetchDiscount('40');
        discountmodel = discountproducts;
      } else if (is50Discount == true) {
        await fetchDiscount('50');
        discountmodel = discountproducts;
      }
    } else if (selectedText == 'Size-UK/India') {
      if (isSize1 == true) {
        await fetchSize('1');
        sizemodel = sizeProducts;
      } else if (isSize2 == true) {
        await fetchSize('2');
        sizemodel = sizeProducts;
      } else if (isSize3 == true) {
        await fetchSize('3');
        sizemodel = sizeProducts;
      }
      // ... add logic for other sizes if needed ...
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchProduct(
          products: filteredProducts,
          ratingProducts: ratemodel,
          categoryProducts: categorymodel,
          discountproducts: discountmodel,
          sizeProducts: sizemodel,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Reset the selectedText state when the page is initialized
    selectedText = 'Gender';
    // Show gender options by default when the page is initialized
    showGenderOptions = true;

    fetchData('5000', '1'); // Initial fetch with default price range
  }

  void toggleMaleCheckBox(bool? value) {
    setState(() {
      isMaleChecked = value; // Update the checkbox state when clicked
    });
  }

  void toggleFemaleCheckBox(bool? value) {
    setState(() {
      isFemaleChecked = value; // Update the checkbox state when clicked
    });
  }

  void toggleGirlsCheckBox(bool? value) {
    setState(() {
      isGirlsChecked = value; // Update the checkbox state when clicked
    });
  }

  void toggleBoysCheckBox(bool? value) {
    setState(() {
      isBoysChecked = value; // Update the checkbox state when clicked
    });
  }

  void toggleUnisexCheckBox(bool? value) {
    setState(() {
      isUnisexChecked = value; // Update the checkbox state when clicked
    });
  }

  void toggleBabyBoysCheckBox(bool? value) {
    setState(() {
      isBabyBoysChecked = value; // Update the checkbox state when clicked
    });
  }

  void setFilterText(String text) {
    setState(() {
      selectedText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.08),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: <Widget>[
            Text(
              'Filters',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.grey,
                  height: 700,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildTextWithGestureDetector('Gender'),
                        buildTextWithGestureDetector('Category'),
                        buildTextWithGestureDetector('Price'),
                        buildTextWithGestureDetector('Brand'),
                        buildTextWithGestureDetector('Size-UK/India'),
                        buildTextWithGestureDetector('Customer Rating'),
                        buildTextWithGestureDetector('Discount'),
                        buildTextWithGestureDetector('Offer'),
                        buildTextWithGestureDetector('Color'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                height: 700,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Render gender options only if showGenderOptions is true
                      if (showGenderOptions)
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isMaleChecked ??
                                      false, // Use null-aware operator to provide a default value
                                  onChanged: (value) {
                                    toggleMaleCheckBox(
                                        value); // Toggle the checkbox state
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text('Men'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isFemaleChecked ??
                                      false, // Use null-aware operator to provide a default value
                                  onChanged: (value) {
                                    toggleFemaleCheckBox(
                                        value); // Toggle the checkbox state
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text('Women'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isGirlsChecked ??
                                      false, // Use null-aware operator to provide a default value
                                  onChanged: (value) {
                                    toggleGirlsCheckBox(
                                        value); // Toggle the checkbox state
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text('Girls'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isBoysChecked ??
                                      false, // Use null-aware operator to provide a default value
                                  onChanged: (value) {
                                    toggleBoysCheckBox(
                                        value); // Toggle the checkbox state
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text('Boys'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isUnisexChecked ??
                                      false, // Use null-aware operator to provide a default value
                                  onChanged: (value) {
                                    toggleUnisexCheckBox(
                                        value); // Toggle the checkbox state
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text('Unisex'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isBabyBoysChecked ??
                                      false, // Use null-aware operator to provide a default value
                                  onChanged: (value) {
                                    toggleBabyBoysCheckBox(
                                        value); // Toggle the checkbox state
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text('Baby Boys'),
                                ),
                              ],
                            ),
                            // Repeat the same for other rows...
                          ],
                        ),
                      // Check if the selected text is "Price" to render the corresponding checkboxes
                      if (selectedText == 'Price')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isRs399BelowChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isRs399BelowChecked = value ?? false;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Rs. 399 and Below"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isRs500BelowChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isRs500BelowChecked = value ?? false;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Rs. 500 and Below"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isRs500To999Checked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isRs500To999Checked = value ?? false;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Rs. 500 To Rs. 999"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isRs1000To1500Checked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isRs1000To1500Checked = value ?? false;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Rs. 1000 To Rs. 1500"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isRs1500To2000Checked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isRs1500To2000Checked = value ?? false;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Rs. 1500 To Rs. 2000"),
                                ),
                              ],
                            ),
                          ],
                        ),

                      // Check if the selected text is "Category" to render the corresponding checkboxes
                      // Check if the selected text is "Category" to render the corresponding checkboxes
                      if (selectedText == 'Category')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isWomenChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isWomenChecked = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Women's"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isKidsChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isKidsChecked = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Kid's"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isMensChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isMensChecked = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Men's"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      // Check if the selected text is "Brand" to render the corresponding checkboxes
                      if (selectedText == 'Brand')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isBrand1 ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isBrand1 = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Brand 1"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isBrand2 ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isBrand2 = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Brand 2"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isBrand3 ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isBrand3 = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Brand 3"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      // Check if the selected text is "Size-UK/India" to render the corresponding checkboxes
                      if (selectedText == 'Size-UK/India')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isSize1 ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isSize1 = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Size 1"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isSize2 ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isSize2 = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Size 2"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isSize3 ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isSize3 = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text("Size 3"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      // Check if the selected text is "Customer Rating" to render the corresponding checkboxes
                      if (selectedText == 'Customer Rating')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: is4Star ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      is4Star = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      Text("4 "),
                                      Icon(Icons.star_outline,
                                          size:
                                              18), // Outline star icon with size 20
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("& above"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: is3Star ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      is3Star = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      Text("3 "),
                                      Icon(Icons.star_outline,
                                          size:
                                              18), // Outline star icon with size 20
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("& above"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      // Check if the selected text is "Discount" to render the corresponding checkboxes

                      if (selectedText == 'Discount')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: is30Discount ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      is30Discount = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("30% or more"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: is40Discount ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      is40Discount = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("40% or more"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: is50Discount ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      is50Discount = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("50% or more"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (selectedText == 'Offer')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isBySave ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isBySave = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text(
                                          "Buy More, Save More"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isSpecialPrice ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isSpecialPrice = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("Special Price"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (selectedText == 'Color')
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isRed ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isRed = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("Red"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isWhite ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isWhite = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("White"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isBlack ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isBlack = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("Black"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isBlue ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isBlue = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("Blue"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isGrey ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      isGrey = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width:
                                              5), // Adjust the spacing between the icon and the text
                                      Text("Grey"), // Additional text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Count Product',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 16), // Adjust the width according to your needs
            ElevatedButton(
              onPressed: applyFilter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.pink), // Change the color according to your needs
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Set border radius to 0.0
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextWithGestureDetector(String text, {double leftPadding = 20}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection by checking if selectedText matches the tapped text
          selectedText = selectedText == text ? '' : text;
          // Show gender options only when "Gender" is clicked
          showGenderOptions = selectedText == 'Gender';
        });
        print('$text clicked!');
      },
      child: Container(
        width: double.infinity,
        color: selectedText == text ? Colors.white : null,
        child: Padding(
          padding: EdgeInsets.only(left: leftPadding, top: 15, bottom: 15),
          child: Text(
            text,
            style: TextStyle(
              color: selectedText == text ? Colors.pink : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
