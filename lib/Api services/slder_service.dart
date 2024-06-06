// Your API service (slider_service.dart)
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Page/home/banner.dart';

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