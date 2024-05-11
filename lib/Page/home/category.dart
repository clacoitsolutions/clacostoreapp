import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget homeCategory() {
  List<String> imageUrls = [
    'https://cdn.pixabay.com/photo/2017/06/06/23/57/birds-2378923_640.jpg',
    'https://cdn.pixabay.com/photo/2024/01/24/15/10/ai-generated-8529788_640.jpg',
    'https://cdn.pixabay.com/photo/2023/10/19/21/08/ai-generated-8327632_640.jpg',
    'https://cdn.pixabay.com/photo/2019/04/14/20/05/duck-meet-4127713_640.jpg',
    'https://cdn.pixabay.com/photo/2024/02/15/16/57/cat-8575768_640.png',
  ];
  List<String> texts = ['Birds1', 'Dog', 'Birds3', 'Duck', 'Cat'];

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(imageUrls.length, (index) {
      return Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(texts[index]),
        ],
      );
    }),
  );
}