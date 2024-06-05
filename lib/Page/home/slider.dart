import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Replace this with your actual API URL
const String apiUrl = 'https://clacostoreapi.onrender.com/getBanner';

Future<List<dynamic>> fetchBannerData() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
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

Widget homeScreenSlider() {
  return FutureBuilder<List<dynamic>>(
    future: fetchBannerData(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final bannerData = snapshot.data!;
        return CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            autoPlay: true,
            viewportFraction: 1,
            enlargeCenterPage: true,
          ),
          items: bannerData.map((banner) {
            return Container(
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(banner['BannerImage']), // Access 'BannerImage' correctly
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        );
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return const CircularProgressIndicator(); // Show loading indicator
      }
    },
  );
}