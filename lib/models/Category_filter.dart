import 'dart:convert';

class CategoryProduct {
  final String srNo;
  final String productCategory;
  final String catImg;
  final int cnt;

  CategoryProduct({
    required this.srNo,
    required this.productCategory,
    required this.catImg,
    required this.cnt,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      srNo: json['SrNo'] ?? '',
      productCategory: json['ProductCategory'] ?? '',
      catImg: json['CatImg'] ?? '',
      cnt: json['cnt'] ?? 0,
    );
  }
}
