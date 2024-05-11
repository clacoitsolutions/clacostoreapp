import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

Widget homeScreenSlider() {
  return CarouselSlider(
    options: CarouselOptions(
      aspectRatio: 16 / 9,
      autoPlay: true,
      viewportFraction: 1,
      enlargeCenterPage: true,
    ),
    items: [
      'https://cdn.pixabay.com/photo/2017/01/25/12/31/bitcoin-2007769_640.jpg',
      'https://cdn.pixabay.com/photo/2016/06/01/08/40/money-1428594_640.jpg',
      'https://cdn.pixabay.com/photo/2018/03/26/02/08/woman-3261425_640.jpg',
    ].map((item) {
      return Container(
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(item),
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList(),
  );
}

