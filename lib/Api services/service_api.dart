import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/slider_model.dart';

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

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    var url = '$apiUrl/getregister';
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    var response = await http.post(
      urlParse,
      body: body,
      headers: {
        "Content-Type": "application/json",
      },
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception('Failed to register user');
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
}
