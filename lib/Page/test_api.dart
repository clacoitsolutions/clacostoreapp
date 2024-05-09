import 'package:flutter/material.dart';
import 'package:claco_store/Api%20services/service_api.dart';
import 'package:claco_store/models/slider_model.dart' as SliderModel;

class BannerScreen extends StatefulWidget {
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  late Future<List<SliderModel.Banner>> futureBanners;

  @override
  void initState() {
    super.initState();
    futureBanners = fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner Screen'),
      ),
      body: Center(
        child: FutureBuilder<List<SliderModel.Banner>>(
          future: futureBanners,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final banners = snapshot.data!;
              return ListView.builder(
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sr No: ${banner.srNo}'),
                      Text('Banner Type: ${banner.bannerType}'),
                      Text('Banner Title: ${banner.bannerTitle}'),
                      Text('Discount Type: ${banner.discountType}'),
                      Text('Discount Value: ${banner.discountValue}'),
                      Text('Category ID: ${banner.categoryId}'),
                      Text('Banner Image: ${banner.bannerImage}'),
                      Text('Is Active: ${banner.isActive}'),
                      Text('Entry Date: ${banner.entryDate}'),
                      Text('Entry By: ${banner.entryBy}'),
                      SizedBox(height: 10),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator(); // Display loading indicator while fetching data
          },
        ),
      ),
    );
  }
}
