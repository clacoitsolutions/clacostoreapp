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