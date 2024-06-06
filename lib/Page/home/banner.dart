import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Api services/slder_service.dart' as serviceapi;
import '../../models/slider_model.dart';

class BannerWithModel extends StatefulWidget {
  const BannerWithModel({Key? key}) : super(key: key);

  @override
  State<BannerWithModel> createState() => _BannerWithModelState();
}

class _BannerWithModelState extends State<BannerWithModel> {
  List<Banner> _banners = [];

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    try {
      final banners = await serviceapi.fetchBanners();
      setState(() {
        _banners = banners;
        for (var banner in banners) {
          print('Banner Image URL: ${banner.bannerImage}'); // Print the URL
        }
      });
    } catch (e) {
      print('Failed to fetch banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _banners.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
      height: 150, // Adjust banner height as needed
      child: CarouselSlider.builder(
        itemCount: _banners.length,
        itemBuilder: (context, index, realIndex) {
          final banner = _banners[index];
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CachedNetworkImage(
                imageUrl: banner.bannerImage, // Use the bannerImage from your API response
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150, // Adjust height as needed
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10.0),
                child: Text(
                  banner.bannerTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
        options: CarouselOptions(
          height: 150, // Adjust height as needed
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          viewportFraction: 1,
        ),
      ),
    );
  }
}

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
      entryDate: json['EntryDate'] != null
          ? DateTime.parse(json['EntryDate'])
          : null,
      entryBy: json['EntryBy'] ?? "",
    );
  }
}