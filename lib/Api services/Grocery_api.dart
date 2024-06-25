import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Add_address_model.dart';
import '../models/category_model.dart';
import '../models/slider_model.dart';
import '../models/wishlist_model.dart';

const String apiUrl = 'https://clacostoreapi.onrender.com';


class ApiService {
  Future<List<dynamic>> fetchProductsGrocery(String mainCategoryCode) async {
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
}



class CartApiService {
  static const String baseUrl = 'https://clacostoreapi.onrender.com';

  static Future<List<dynamic>> fetchCartItems(String customerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addToCart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'CustomerId': customerId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  static Future<void> updateCartItemQuantity(String customerId, String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateCartItemQuantity'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'CustomerId': customerId,
          'ProductId': productId,
          'Quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        print('Cart size updated successfully');
      } else {
        print('Failed to update cart size. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart size: $e');
      throw Exception('Failed to update cart size');
    }
  }
}
