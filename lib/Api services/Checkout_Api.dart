import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://clacostoreapi.onrender.com';

  static Future<Map<String, dynamic>> fetchAddressData(String customerId) async {
    final url = Uri.parse('$_baseUrl/address');
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
      throw Exception('Failed to load address data');
    }
  }

  static Future<List<dynamic>> fetchCartDatacheckout(String customerId) async {
    final url = Uri.parse('$_baseUrl/addToCart');
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
      throw Exception('Failed to load cart data');
    }
  }
}
