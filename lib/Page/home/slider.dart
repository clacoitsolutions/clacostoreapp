import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Api services/slder_service.dart';

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
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: banner['BannerImage'], // Use CachedNetworkImage directly
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(
                            child: Icon(Icons.error),
                          ),
                    ),
                  ),
                );
              },
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