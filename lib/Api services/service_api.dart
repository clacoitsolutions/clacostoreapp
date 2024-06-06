import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/slider_model.dart'; // Import the models class once


const String apiUrl = 'https://clacostoreapi.onrender.com'; // URL variable
class APIService {

  Future<List<Banner>> fetchBanners() async {
    final response = await http.get(
        Uri.parse('$apiUrl/getBanner')); // Using the URL variable
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Banner> banners = [];
      for (var item in data) {
        banners.add(Banner.fromJson(item)); // Use the models class directly
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
      return responseData;
    }
  }
}