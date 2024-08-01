import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Add_address_model.dart';
import '../models/category_model.dart';
import '../models/slider_model.dart';
import '../models/wishlist_model.dart';

const String apiUrl = 'https://clacostoreapi.onrender.com';

class APIService {
  Future<List<Banner>> fetchBanners() async {
    final response = await http.get(Uri.parse('$apiUrl/getBanner'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Banner> banners = [];
      for (var item in data) {
        banners.add(Banner.fromJson(item));
      }
      return banners;
    } else {
      throw Exception('Failed to load banner data');
    }
  }

  Future<Map<String, dynamic>> register(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$apiUrl/getregister'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Handle both 200 and 201 status codes as successful
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to register: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to register');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await http.get(Uri.parse('$apiUrl/category/getCategory'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> categories = List<Map<String, dynamic>>.from(json.decode(response.body));
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<dynamic>> fetchProducts(String mainCategoryCode) async {
    final response = await http.post(
      Uri.parse('$apiUrl/category/getCatwithid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'MainCategoryCode': mainCategoryCode,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['data'] ?? [];
    } else {
      throw Exception('Failed to load products');
    }
  }

//Contact Us
  Future<Map<String, dynamic>> submitContactForm({
    required String fullName,
    required String email,
    required String mobileNo,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$apiUrl/ContactUs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'FullNames': fullName,
        'EmailAddresss': email,
        'MobileNos': mobileNo,
        'Messages': message,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception(responseBody['message'] ?? 'Failed to submit form: ${response.statusCode}');
    }
  }
 static Future<List<dynamic>> fetchProductsdetails(List<String> srNoList) async {
    List<dynamic> products = [];
    for (String srNo in srNoList) {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/category/getCatwithid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'MainCategoryCode': srNo,
        }),
      );

      if (response.statusCode == 200) {
        products.addAll(json.decode(response.body)['data']);
      } else {
        throw Exception('Failed to load products');
      }
    }
    return products;
  }



  // add to cart

  Future<List<dynamic>> fetchData(String customerId) async {
    final url = Uri.parse('$apiUrl/addToCart');
    final response = await http.post(
      url,
      body: jsonEncode({'CustomerId': customerId}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }
  //add quantity
  Future<void> updateCartItem(String customerId, String productId, int quantity) async {
    final url = 'https://clacostoreapi.onrender.com/updatecartsize1';
    final body = {
      "customerid": customerId,
      "productid": productId,
      "quantity": quantity.toString(),
    };

    try {
      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        // Successful update
        print('Item updated successfully');
      } else {
        // Handle other status codes
        print('Failed to update item: ${response.statusCode}');
        throw Exception('Failed to update item');
      }
    } catch (e) {
      // Handle network or server errors
      print('Exception during update: $e');
      throw Exception('Failed to update item: $e');
    }
  }






  // add to cart remove product
  Future<void> removeItemFromCart(String customerId, String cartListId) async {
    final url = Uri.parse('$apiUrl/deletecart');
    final response = await http.delete(
      url,
      body: jsonEncode({
        'CustomerID': customerId,
        'CartListID': cartListId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart');
    }
  }


// ProductDetails api
  Future<Map<String, dynamic>?> fetchProductDetails( String productId) async {
    final url = '$apiUrl/getProductDetails';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({ 'productId': productId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'][0];
      return data;
    } else {
      print('Failed to load product details');
      return null;
    }
  }



  Future<List<dynamic>> fetchProduct(String categoryId) async {
    final response = await http.get(Uri.parse('$apiUrl/products?category=$categoryId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }


  Future<List<WishList>> fetchWishlist(String customerId) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/wishlist'),
        body: jsonEncode({'CustomerId': customerId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return List<WishList>.from(
          responseData['data'].map((item) => WishList.fromJson(item)),
        );
      } else {
        throw Exception('Failed to load wishlist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while loading wishlist: $e');
    }
  }

  Future<void> removeItemFromWishlist(String customerId, String productId) async {
    try {
      var response = await http.delete(
        Uri.parse('$apiUrl/DeleteWishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ProductId': productId,
          'EntryBy': customerId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove item from wishlist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while removing item from wishlist: $e');
    }
  }

  addToWishlist(String customerId, String productId) {}

  // New method to add a product to the wishlist






}
