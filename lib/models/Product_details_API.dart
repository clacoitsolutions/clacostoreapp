import 'package:http/http.dart' as http;
import 'dart:convert';

class APIServices {
  static const String baseUrl = 'https://clacostoreapi.onrender.com';

  Future<Map<String, dynamic>> fetchProductDetail(String srno, String productId) async {
    final url = Uri.parse('$baseUrl/fetchProductDetails');
    final response = await http.post(
      url,
      body: jsonEncode({'srno': srno, 'productId': productId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<Map<String, dynamic>> fetchProductSizes(String productId) async {
    final url = Uri.parse('$baseUrl/getProductDetailSize');
    final response = await http.post(
      url,
      body: jsonEncode({'productId': productId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch product sizes');
    }
  }

  Future<Map<String, dynamic>> fetchProductColor(String productId) async {
    final url = Uri.parse('$baseUrl/getProductDetailColor');
    final response = await http.post(
      url,
      body: jsonEncode({'productId': productId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch product sizes');
    }
  }

  Future<Map<String, dynamic>> addToCart(String customerId, String productId, String quantity) async {
    final url = Uri.parse('$baseUrl/addtocart3');
    final response = await http.post(
      url,
      body: jsonEncode({
        'customerid': customerId,
        'productid': productId,
        'quantity': quantity,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add item to cart');
    }
  }
}
