import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wishlist_model.dart'; // Adjust path as per your project structure

class WishlistService {
  static const String _baseUrl = 'https://clacostoreapi.onrender.com';

  static Future<List<WishList>> loadWishlistData(String customerId) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/wishlist'),
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

  static Future<String> removeItemFromWishlist(String customerId, String productId) async {
    final url = Uri.parse('$_baseUrl/DeleteWishlist');
    try {
      final response = await http.delete(
        url,
        body: jsonEncode({
          'EntryBy': customerId,
          'ProductId': productId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        throw Exception('Failed to remove item from wishlist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while removing item from wishlist: $e');
    }
  }

  static Future<String> addToCart(String customerId, String productId) async {
    final url = Uri.parse('$_baseUrl/addtocart3');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'customerid': customerId,
          'productid': productId,
          'quantity': '1',
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        throw Exception('Failed to add item to cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while adding item to cart: $e');
    }
  }
}
