import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../Api services/slder_service.dart' as serviceapi;

class BannerWithModel extends StatefulWidget {
  const BannerWithModel({Key? key}) : super(key: key);

  @override
  State<BannerWithModel> createState() => _BannerWithModelState();
}

class _BannerWithModelState extends State<BannerWithModel> {
  late Future<List<Banner>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    _bannersFuture = serviceapi.fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Banner>>(
      future: _bannersFuture, // Use the future for banner data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Show a loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Show an error message
        } else if (snapshot.hasData) {
          final banners = snapshot.data!;
          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              viewportFraction: 1,
            ),
            items: banners.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        height: 150,
                        child: CachedNetworkImage(
                          imageUrl: banner.bannerImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return Center(
              child: Text(
                  'No banners available')); // Handle the case where there's no data
        }
      },
    );
  }
}

// ... (Your existing slider_model.dart and API service code) ...

// Your slider model (slider_model.dart)
class Banner {
  final String srNo;
  final String bannerType;
  final String bannerTitle;
  final String discountType;
  final int discountValue;
  final String categoryId;
  final String bannerImage; // This should now hold the Firebase Storage URL
  final bool isActive;
  final DateTime? entryDate;
  final String entryBy;

  Banner({
    required this.srNo,
    required this.bannerType,
    required this.bannerTitle,
    required this.discountType,
    required this.discountValue,
    required this.categoryId,
    required this.bannerImage,
    required this.isActive,
    this.entryDate,
    required this.entryBy,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      srNo: json['SrNo'] ?? "",
      bannerType: json['BannerType'] ?? "",
      bannerTitle: json['Bannertitle'] ?? "",
      discountType: json['DiscountType'] ?? "",
      discountValue: json['DiscountValue'] ?? 0,
      categoryId: json['CategoryId'] ?? "",
      bannerImage: json['BannerImage'] ?? "", // Get the URL from your API
      isActive: json['IsActive'] ?? false,
      entryDate:
          json['EntryDate'] != null ? DateTime.parse(json['EntryDate']) : null,
      entryBy: json['EntryBy'] ?? "",
    );
  }
}
