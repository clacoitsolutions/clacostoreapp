// Your API service (slider_service.dart)
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Page/home/banner.dart';
import '../models/category_model.dart';

const String apiUrl = 'https://clacostoreapi.onrender.com';

Future<List<Banner>> fetchBanners() async {
  final response = await http.get(Uri.parse('$apiUrl/getBanner'));
  if (response.statusCode == 200 || response.statusCode == 201) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> bannerData = data['data'];
    List<Banner> banners =
    bannerData.map((item) => Banner.fromJson(item)).toList();
    return banners;
  } else {
    throw Exception('Failed to load banner data');
  }
}



Future<List<dynamic>> fetchBannerData() async {
  final response = await http.get(Uri.parse('$apiUrl/getBanner'));

  if (response.statusCode == 200 ||response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data['data']; // Access the 'data' array directly
  } else if (response.statusCode == 404) {
    throw Exception('API endpoint not found');
  } else if (response.statusCode >= 500) {
    throw Exception('Server error');
  } else {
    throw Exception('Failed to load banner data');
  }
}


